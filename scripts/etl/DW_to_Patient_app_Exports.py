import os
import sys
import mysql.connector
import json
import logging
from pathlib import Path
path = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0,path)
from util import Connections, Log, Load_Data

def start_etl(load_id,data_source_cd):
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
		log_id, start_ts,end_ts = Log.check_current_status(etl,load_id,source,target,data_source_cd)
        #if completed, return to parent program
		if log_id == "-1":
			return 0
		
		conn = Connections.dw_db_connect(data_source_cd)
		cursor = conn.cursor()

		file_path= Connections.export_dir_connect()
		#get table data for inserting
		export_table_data = Load_Data.get_table_data(data_source_cd,'DW_to_Patient_app_Exports','export')
		
		# Insert new data created in the load date range
		for table_data in export_table_data:
			table_name = table_data['tablename']
			file_name=f"{file_path}{table_name}.csv"

			#if file has been processed for the given load id successfully, then, skip it
			if not Log.check_status(load_id,etl,"dw_data.export",file_name,"Completed",data_source_cd):
				sub_log_id,data_start_ts,data_end_ts = Log.insert_log(load_id,etl,"dw_data.export",file_name,"Started","",start_ts,end_ts,data_source_cd)
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
				Log.update_log(sub_log_id,"Completed",exported_row_count,data_source_cd)

		Log.update_log(log_id,"Completed","",data_source_cd)
		return 0
		
	except mysql.connector.Error as err:
		Log.update_on_error(log_id,sub_log_id,err,sql,data_source_cd)
		print(err)
		raise Exception

	except Exception as err:
		Log.update_on_error(log_id,sub_log_id,err,sql,data_source_cd)
		if conn is not None:
			conn.rollback()
		print(err)
		return -1

	finally:
			if conn is not None:
				conn.close()
