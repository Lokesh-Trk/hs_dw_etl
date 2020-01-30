import mysql.connector
import json

from . import Staging_from_CSV as Staging_from_CSV
from . import Staging_Refresh_DB as Staging_Refresh_DB
from . import Staging_to_DW_Dimensions as Staging_to_DW_Dimensions
from . import Staging_to_DW_Facts as Staging_to_DW_Facts
from . import DW_to_Patient_app_Exports as DW_to_Patient_app_Exports
from util import Log,Connections

def main(data_source_cd):
    try:
        load_id=None
    # if previous load failed, get the same load id and data date range
        load_id, status = Log.check_current_load_details(data_source_cd)
        
        # if previous load did not fail, create a new load id
        if load_id == None:
            load_id = str(Log.insert_load_details(data_source_cd))
        else:
            if status == "Started":
                load_id = None
                raise Exception("Load currently in progress. Cannot start another in parallel. ")
        #get etl flow details based on the data_source_cd
        file_conn = Connections.get_etl_flow_settings_json()
        with file_conn as json_file:
            data = json.load(json_file)

        settings=data["etl_flow_settings"]
        for i in range(len(settings)):
            if settings[i]["data_source_cd"]==data_source_cd:
                elements=settings[i]['elements']
                etl_stages=settings[i]['etl_stages']
        for i in range(len(etl_stages)):
            value="etl_stage"+str(i)
            module=etl_stages[value]
            success_flg = eval(module).start_etl(load_id,elements)
            if success_flg == -1:
                raise Exception(module+" failed")

        Log.update_load_details(load_id,'Completed','')

    except mysql.connector.Error as err:
        raise Exception("Mysql connection error: ",err.msg)

    except Exception as e:
        if load_id is not None:
            Log.update_load_details(load_id,'Failed',str(e))
        print (str(e))
        return -1
        