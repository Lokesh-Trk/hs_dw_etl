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

def start_etl(load_id, elements):
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
		log_id, start_ts,end_ts = Log.check_current_status(etl,load_id,source,target)
        #if completed, return to parent program
		if log_id == "-1":
			return 0
		#get table schema
		target_database_nm, stg_table_schema = Load_Data.get_table_data(elements,'Staging_Refresh_DB','create')
        #drop and create staging db
		if not Log.check_status(load_id,etl,"","Refresh_Staging_DB","Completed"):
			sub_log_id,start_ts,end_ts = Log.insert_log(load_id,etl,"","Refresh_Staging_DB","Started")
            #connecting to dw_db_connect
			conn = Connections.dw_db_connect()
			cursor = conn.cursor()

			create_db_sql=f"CREATE DATABASE IF NOT EXISTS {target_database_nm}"
			cursor.execute(create_db_sql)
			affected_row_count = cursor.rowcount
			Log.update_log(sub_log_id,"Completed",affected_row_count)
			cursor.close
			conn.close

        #Reset sub_log_id
		sub_log_id = -1

        #drop and create staging db tables
		for table_data in stg_table_schema:
			table_name = f"{target_database_nm}.{table_data['tablename']}"
			#if file has been processed for the given load id successfully, then, skip it
			if not Log.check_status(load_id,etl,"healthscore_stg.create",table_name,"Completed"):
				sub_log_id,data_start_ts,data_end_ts = Log.insert_log(load_id,etl,"healthscore_stg.create",table_name,"Started")
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
				Log.update_log(sub_log_id,"Completed",affected_row_count)
		
		Log.update_log(log_id,"Completed","")
		return 0

	except mysql.connector.Error as error:
		Log.update_on_error(log_id,sub_log_id,error,sql)
		raise Exception

	except Exception as error:
		Log.update_on_error(log_id,sub_log_id,error,sql)	
		print("e",error)	
		return -1

	finally:
		if conn is not None:
				conn.close()

