from . import CSV_to_Staging as CSV_to_Staging
from . import Refresh_Staging_DB as Refresh_Staging_DB
from . import Staging_to_DW_Dimensions as Staging_to_DW_Dimensions
from . import Staging_to_DW_Facts as Staging_to_DW_Facts
from . import DW_to_Patient_app_Exports as DW_to_Patient_app_Exports
from util import Log
# 3rd party library imports
import mysql.connector

def main():
    try:
        load_id=None
    # if previous load failed, get the same load id and data date range
        load_id, status = Log.checkCurrentLoadDetails('HS_Shared')
        # if previous load did not fail, create a new load id
        if load_id == None:
            load_id = str(Log.insertLoadDetails('HS_Shared'))
        else:
            if status == "Started":
                load_id = None
                raise Exception("Load currently in progress. Cannot start another in parallel. ")

        success_flg = Refresh_Staging_DB.startETL(load_id)
        if success_flg == -1:
            raise Exception("Refresh_Staging_DB failed")
        success_flg = CSV_to_Staging.startETL(load_id)
        if success_flg == -1:
            raise Exception("CSV_to_Staging failed")
        success_flg = Staging_to_DW_Dimensions.startETL(load_id)
        if success_flg == -1:
            raise Exception("Staging_to_DW_Dimensions failed")
        success_flg = Staging_to_DW_Facts.startETL(load_id)
        if success_flg == -1:
            raise Exception("Staging_to_DW_Facts failed")
        success_flg = DW_to_Patient_app_Exports.startETL(load_id)
        if success_flg == -1:
            raise Exception("DW_to_Patient_app_Exports failed")

        Log.updateLoadDetails(load_id,'Completed','')

    except mysql.connector.Error as err:
        print("Mysql connection error: ",err.msg)
        print (str(err))
        if load_id is not None:
            raise Exception(err)
        return -1

    except Exception as e:
        if load_id is not None:
            Log.updateLoadDetails(load_id,'Failed',str(e))
        print (str(e))
        return -1
        