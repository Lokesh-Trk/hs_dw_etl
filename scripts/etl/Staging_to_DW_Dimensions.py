import os
import sys
import mysql.connector
import json
import logging
from pathlib import Path
path = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0,path)
from util import Connections, Log, json_validate

def startETL(load_id):
	#log file metadata
	etl = Path(__file__).stem
	source = "Staging"
	target = "Dimensions"
	sub_log_id = -1
	log_id = None
	conn = None
	sql = ""

	try:
		# if previous load failed, get the same load id and data date range, else skip
		log_id, startTs,endTs = Log.checkCurrentStatus(etl,load_id,source,target)
        #if completed, return to parent program
		if log_id == "-1":
			return 0

		conn = Connections.dw_db_connect()
		cursor = conn.cursor()

		json_schema_file_conn,json_schema_file_name=Connections.json_etl_schema_file_connect()
		dim_schema_file_conn,dim_schema_file_name = Connections.json_dim_load_file_connect()

		with dim_schema_file_conn as json_file:
				data = json.load(json_file)
				data_dupe_check = False
				json_validate.json_validate(data,json_schema_file_name,data_dupe_check)
		# Insert new data created in the load date range
		for table_data in data['insert_table_info']:
			table_name = f"{data['database']}.{table_data['tablename']}"
			

			#if file has been processed for the given load id successfully, then, skip it
			if not Log.checkStatus(load_id,etl,table_data["source_table"]+".insert",table_name,"Completed"):
				sub_log_id,data_start_ts,data_end_ts = Log.insert_log(load_id,etl,table_data["source_table"]+".insert",table_name,"Started")
				sql = f"INSERT INTO {table_name} ( {table_data['fields']} ) SELECT * FROM ({table_data['insert_query']}) as src "
				sql = f"{sql} ON DUPLICATE KEY UPDATE {table_data['update_fields']}"
				cursor.execute(sql)
				affected_row_count = cursor.rowcount
				conn.commit()
				Log.update_log(sub_log_id,"Completed",affected_row_count)

		# Update data that has been modified in the load date range
		for table_data in data['update_table_info']:
			table_name = f'{data["database"]}.{table_data["tablename"]}'
			sql = f"UPDATE {table_name} dim JOIN ({table_data['join_query']}) src ON {table_data['on_clause']}" 
			sql = f"{sql} SET {table_data['fields']}"

			#if table has been processed for the given load id successfully, then, skip it
			if not Log.checkStatus(load_id,etl,table_data["source_table"]+".update",table_name,"Completed"):
				sub_log_id,data_start_ts,data_end_ts = Log.insert_log(load_id,etl,table_data["source_table"]+".updates",table_name,"Started","")
				cursor.execute(sql)
				affected_row_count = cursor.rowcount
				conn.commit()
				Log.update_log(sub_log_id,"Completed",affected_row_count)
		
		Log.update_log(log_id,"Completed","")
		return 0

	except mysql.connector.Error as err:
		Log.updateonerror(log_id,sub_log_id,err,sql)
		raise Exception

	except Exception as err:
		Log.updateonerror(log_id,sub_log_id,err,sql)
		if conn is not None:
			conn.rollback()
		return -1

	finally:
		if conn is not None:
			conn.close()

