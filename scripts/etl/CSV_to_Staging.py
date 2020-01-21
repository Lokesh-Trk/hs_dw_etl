import csv 
import glob
import os.path
import mysql.connector
import sys
import time
from pathlib import Path
path = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0,path)
from util import Connections, Log

def startETL(load_id):
    #log file metadata
    etl = Path(__file__).stem
    source = "CSV"
    target = "Staging"
    sub_log_id = -1
    log_id = None
    conn = None
    sql = ""
    table_name= None
    try:
        # if previous load failed, get the same load id and data date range, else skip
        log_id,startTs,endTs = Log.checkCurrentStatus(etl,load_id,source,target)
        #if completed, return to parent program
        if log_id == "-1":
            return 0
        
        #Reset sub_log_id
        sub_log_id = -1
        src_file_path, src_files = Connections.src_file_connect()
        stg_database_name = Connections.getStagingDBName()
        #loading csv files
        for f in src_files:
            if f.endswith(".csv"):
                file_without_extn = f.split('.')
                filename = file_without_extn[0].split('-')
                # if file contains database name & table name split
                if len(filename)>1:
                    table_name = filename[1]
                # if file contains time range
                if len(filename)>2:
                    time_split = filename[2].split('_')
                    if len(time_split)>1:
                        startTs = time_split[0]
                        endTs = time_split[1]

                file_name_with_path = f'{src_file_path}/{f}'
                #if file has been processed for the given load id successfully, then, skip it
                if not Log.checkStatus(load_id,etl,f,table_name,"Completed"):
                    sub_log_id,startTs,endTs = Log.insert_log(load_id,etl,f,table_name,"Started","",startTs,endTs)
                    conn = Connections.stg_db_connect()
                    cursor = conn.cursor(buffered=True)
                    check_sql = f"SELECT 1 FROM information_schema.tables WHERE table_schema = '{stg_database_name}' AND table_name = '{table_name}' LIMIT 1;"
                    cursor.execute(check_sql)
                    table_exists = cursor.rowcount
                    cursor.close()

                    if table_exists > 0:
                        sql  = f"LOAD DATA INFILE '{file_name_with_path}' INTO TABLE {table_name} CHARACTER SET latin1 FIELDS TERMINATED BY '^~^' ENCLOSED BY \"\" ESCAPED BY '\\\\' LINES TERMINATED BY  \'\\n\' IGNORE 1 LINES;" 
                        cursor = conn.cursor()
                        cursor.execute(sql)
                        affected_row_count = cursor.rowcount
                        conn.commit()
                        Log.update_log(sub_log_id,"Completed",affected_row_count)
                        #reset so that future errors dont attribute to this sub-load
                        sub_log_id = -1
                        cursor.close()
                      #  os.remove(file_name_with_path)
                    else:
                        Log.update_log(sub_log_id,"Skipped","Table does not exist")

                    

        Log.update_log(log_id,"Completed","")
        return 0

    except mysql.connector.Error as err:
        Log.updateonerror(log_id,sub_log_id,err,sql)
        raise Exception

    except Exception as err:
        Log.updateonerror(log_id,sub_log_id,err,sql)
        # Rollback in case there is any error
        if conn is not None:
            conn.rollback()
        return -1

    except:
        print("Unexpected error:", sys.exc_info()[0])
        return -1

    finally:
            if conn is not None:
                conn.close()
