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
	source = "DW"
	target = "CSV"
	sub_log_id = -1
	log_id = None
	conn = None
	sql=""

	try:
		# if previous load failed, get the same load id and data date range, else skip
		log_id, startTs,endTs = Log.checkCurrentStatus(etl,load_id,source,target)
        #if completed, return to parent program
		if log_id == "-1":
			return 0
		
		conn = Connections.dw_db_connect()
		cursor = conn.cursor()

		file_path= Connections.export_dir_connect()

		json_schema_file_conn,json_schema_file_name=Connections.json_export_schema_file_connect()
		export_schema_file_conn,export_schema_file_name = Connections.json_export_file_connect()

		with export_schema_file_conn as json_file:
				data = json.load(json_file)
				data_dupe_check = True
				json_validate.json_validate(data,json_schema_file_name,data_dupe_check)
		
		# Insert new data created in the load date range
		for table_data in data['table_info']:
			table_name = table_data['tablename']
			file_name=f"{file_path}{table_name}.csv"

			#if file has been processed for the given load id successfully, then, skip it
			if not Log.checkStatus(load_id,etl,"dw_data.export",file_name,"Completed"):
				sub_log_id,data_start_ts,data_end_ts = Log.insert_log(load_id,etl,"dw_data.export",file_name,"Started","",startTs,endTs)
				sql=f"{table_data['query']} where "
				sql=f"{sql} ((src.inserted_ts BETWEEN '{data_start_ts}' AND '{data_end_ts}') OR (src.updated_ts BETWEEN '{data_start_ts}' AND '{data_end_ts}'))"
				
				if table_data.get('where_clause'):
					sql= f"{sql} and {table_data['where_clause']} " 
				sql=f"{sql} INTO OUTFILE '{file_name}' FIELDS ESCAPED BY '\\\\' TERMINATED BY '^~^' ENCLOSED BY \"\" LINES TERMINATED BY  \'\\n\';"
				if os.path.exists(file_name):
					os.remove(file_name)
				cursor.execute(sql)
				#subtracting 1 for the header 
				exported_row_count = cursor.rowcount-1
				Log.update_log(sub_log_id,"Completed",exported_row_count)

		Log.update_log(log_id,"Completed","")
		return 0
		
	except mysql.connector.Error as err:
		print(err)
		raise Exception

	except Exception as err:
		Log.updateonerror(log_id,sub_log_id,err,sql)
		if conn is not None:
			conn.rollback()
		print(err)
		return -1

	finally:
			if conn is not None:
				conn.close()
