import json 
import io
import os
import logging
import sys
from pathlib import Path
import mysql.connector
path = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0,path)
from util import Connections, Log, Load_Data

def start_etl(load_id, data_source_cd):
	#log file metadata
	etl = Path(__file__).stem
	source = ""
	target = "healthscore_stg"
	sub_log_id = -1
	sql=""
	log_id = None
	conn = None
	error = None
	
	try:
		# if previous load failed, get the same load id and data date range, else skip
		log_id, start_ts,end_ts = Log.check_current_status(etl,load_id,source,target,data_source_cd)
        #if completed, return to parent program
		if log_id == "-1":
			return 0
		#get table schema
		target_database_nm, stg_table_schema = Load_Data.get_table_data(data_source_cd,'Staging_Refresh_DB','create')
        #drop and create staging db
		if not Log.check_status(load_id,etl,"","Refresh_Staging_DB","Completed",data_source_cd):
			sub_log_id,start_ts,end_ts = Log.insert_log(load_id,etl,"","Refresh_Staging_DB","Started",None,None,None,data_source_cd)
            #connecting to dw_db_connect
			conn = Connections.dw_db_connect(data_source_cd)
			cursor = conn.cursor()

			create_db_sql=f"CREATE DATABASE IF NOT EXISTS {target_database_nm}"
			cursor.execute(create_db_sql)
			affected_row_count = cursor.rowcount
			Log.update_log(sub_log_id,"Completed",affected_row_count,data_source_cd)
			cursor.close
			conn.close

        #Reset sub_log_id
		sub_log_id = -1

        #drop and create staging db tables
		for table_data in stg_table_schema:
			table_name = f"{target_database_nm}.{table_data['tablename']}"
			#if file has been processed for the given load id successfully, then, skip it
			if not Log.check_status(load_id,etl,"healthscore_stg.create",table_name,"Completed",data_source_cd):
				sub_log_id,data_start_ts,data_end_ts = Log.insert_log(load_id,etl,"healthscore_stg.create",table_name,"Started",None,None,None,data_source_cd)
				delete_table_sql  = f"DROP TABLE IF EXISTS {table_name};"
				create_table_sql  = f"CREATE TABLE {table_name}( {table_data['fields']}"
				create_table_sql += f", PRIMARY KEY ({table_data['primary_key']})" if 'primary_key' in table_data else ""
				create_table_sql += f", KEY ({table_data['index_key']})" if 'index_key' in table_data else ""
				create_table_sql += f") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;"		
				conn = Connections.stg_db_connect()
				cursor = conn.cursor()
				cursor.execute(delete_table_sql)
				cursor.execute(create_table_sql)
				affected_row_count = cursor.rowcount
				conn.commit()
				Log.update_log(sub_log_id,"Completed",affected_row_count,data_source_cd)
		
		Log.update_log(log_id,"Completed","",data_source_cd)
		return 0

	except mysql.connector.Error as error:
		Log.update_on_error(log_id,sub_log_id,error,sql,data_source_cd)
		raise Exception

	except Exception as error:
		Log.update_on_error(log_id,sub_log_id,error,sql,data_source_cd)	
		print("e",error)	
		return -1

	finally:
		if conn is not None:
				conn.close()

