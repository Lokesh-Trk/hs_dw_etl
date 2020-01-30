import os
import sys
import mysql.connector
import json
import logging
from pathlib import Path
path = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0,path)
from util import Connections, Log, Load_Data

def start_etl(load_id,elements):
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
		log_id, start_ts,end_ts = Log.check_current_status(etl,load_id,source,target)
        #if completed, return to parent program
		if log_id == "-1":
			return 0

		conn = Connections.dw_db_connect()
		cursor = conn.cursor()
		#get table data for inserting
		target_database_nm, insert_dim_table_data = Load_Data.get_table_data(elements,'Staging_to_DW_Dimensions','insert')

		# Insert new data created in the load date range
		for table_data in insert_dim_table_data:
			table_name = f"{target_database_nm}.{table_data['tablename']}"

			#if file has been processed for the given load id successfully, then, skip it
			if not Log.check_status(load_id,etl,table_data["source_table"]+".insert",table_name,"Completed"):
				sub_log_id,data_start_ts,data_end_ts = Log.insert_log(load_id,etl,table_data["source_table"]+".insert",table_name,"Started")
				sql = f"INSERT INTO {table_name} ( {table_data['fields']} ) SELECT * FROM ({table_data['insert_query']}) as src "
				sql = f"{sql} ON DUPLICATE KEY UPDATE {table_data['update_fields']}"
				cursor.execute(sql)
				affected_row_count = cursor.rowcount
				conn.commit()
				Log.update_log(sub_log_id,"Completed",affected_row_count)
		
		#get table data for updating
		target_database_nm, update_dim_table_data = Load_Data.get_table_data(elements,'Staging_to_DW_Dimensions','update')

		# Update data that has been modified in the load date range
		for table_data in update_dim_table_data:
			table_name = f'{target_database_nm}.{table_data["tablename"]}'
			sql = f"UPDATE {table_name} dim JOIN ({table_data['join_query']}) src ON {table_data['on_clause']}" 
			sql = f"{sql} SET {table_data['fields']}"

			#if table has been processed for the given load id successfully, then, skip it
			if not Log.check_status(load_id,etl,table_data["source_table"]+".update",table_name,"Completed"):
				sub_log_id,data_start_ts,data_end_ts = Log.insert_log(load_id,etl,table_data["source_table"]+".updates",table_name,"Started","")
				cursor.execute(sql)
				affected_row_count = cursor.rowcount
				conn.commit()
				Log.update_log(sub_log_id,"Completed",affected_row_count)
		
		Log.update_log(log_id,"Completed","")
		return 0

	except mysql.connector.Error as err:
		Log.update_on_error(log_id,sub_log_id,err,sql)
		raise Exception

	except Exception as err:
		print(err)
		Log.update_on_error(log_id,sub_log_id,err,sql)
		if conn is not None:
			conn.rollback()
		return -1

	finally:
		if conn is not None:
			conn.close()

