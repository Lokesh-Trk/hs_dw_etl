import json 
import os
import logging
import sys
from pathlib import Path
import mysql.connector
path = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0,path)
from util import Connections, Log, json_validate

def startETL(load_id):
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
		log_id, startTs,endTs = Log.checkCurrentStatus(etl,load_id,source,target)
        #if completed, return to parent program
		if log_id == "-1":
			return 0

		json_file=Connections.createStaging_file_connect()
		data = json.load(json_file)
        #drop and create staging db
		if not Log.checkStatus(load_id,etl,"","Refresh_Staging_DB","Completed"):
			sub_log_id,startTs,endTs = Log.insert_log(load_id,etl,"","Refresh_Staging_DB","Started")
            #connecting to dw_db_connect
			conn = Connections.dw_db_connect()
			cursor = conn.cursor()

			create_db_sql=f"CREATE DATABASE IF NOT EXISTS {data['database']}"
			cursor.execute(create_db_sql)
			affected_row_count = cursor.rowcount
			Log.update_log(sub_log_id,"Completed",affected_row_count)
			cursor.close
			conn.close

        #Reset sub_log_id
		sub_log_id = -1

        #drop and create staging db tables
		for table_data in data['table_info']:
			table_name = f"{data['database']}.{table_data['tablename']}"
			index_key = ""
			primary_key = ""
			if 'primary_key' in table_data:
				primary_key = table_data['primary_key']
			if 'index_key' in table_data:
				index_key = table_data['index_key']
			#if file has been processed for the given load id successfully, then, skip it
			if not Log.checkStatus(load_id,etl,"healthscore_stg.create",table_name,"Completed"):
				sub_log_id,data_start_ts,data_end_ts = Log.insert_log(load_id,etl,"healthscore_stg.create",table_name,"Started")
				delete_table_sql=f"DROP TABLE IF EXISTS {table_name};"
				create_table_sql_part_1 = f"CREATE TABLE {table_name}( {table_data['fields']}"
				if primary_key:
					create_table_sql_part_2 = f", PRIMARY KEY ({primary_key})"
				else:
					create_table_sql_part_2 = ""
				if index_key:
					create_table_sql_part_3 = f", KEY ({index_key})"
				else:
					create_table_sql_part_3 = ""
					
				create_table_sql_part_4 =") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;"
				create_table_sql = f"{create_table_sql_part_1} {create_table_sql_part_2} {create_table_sql_part_3} {create_table_sql_part_4}"
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
		print(error)
		Log.updateonerror(log_id,sub_log_id,error,sql)
		raise Exception

	except Exception as error:
		Log.updateonerror(log_id,sub_log_id,error,sql)	
		print(error)	
		return -1

	finally:
		if conn is not None:
				conn.close()

