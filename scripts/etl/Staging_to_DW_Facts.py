import os
import sys
import mysql.connector
import json
import logging
from pathlib import Path
from itertools import product
path = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0,path)
from util import Connections, Log, json_validate

def startETL(load_id):
	#log file metadata
	etl = Path(__file__).stem
	source = "Staging"
	target = "Facts"
	sub_log_id = -1
	log_id = None
	conn = None
	sql = ""
	source_cd='HS_Shared'

	try:
		# if previous load failed, get the same load id and data date range, else skip
		log_id, startTs,endTs = Log.checkCurrentStatus(etl,load_id,source,target)
        #if completed, return to parent program
		if log_id == "-1":
			return 0

		conn = Connections.dw_db_connect()
		cursor = conn.cursor()
		json_schema_file_conn,json_schema_file_name=Connections.json_etl_fact_schema_file_connect()
		fact_schema_file_conn,fact_schema_file_name = Connections.json_fact_load_file_connect()

		with fact_schema_file_conn as json_file:
			data = json.load(json_file)
			data_dupe_check = False
			json_validate.json_validate(data,json_schema_file_name,data_dupe_check)
	#	Insert new data created in the load date range
		sql="SELECT hospital_key,hospital_cd from healthscore_dw.dim_hospital"
		cursor.execute(sql)
		hospital_data=cursor.fetchall()
		print(hospital_data)
		table_info=data['insert_table_info']
		no_of_hospital=len(hospital_data)
		len_table_data=len(table_info)
		ranges = [
    		range(0,no_of_hospital),
    		range(0,len_table_data)
			]
		for h, t in product(*ranges):
			print(h,t)
			print(hospital_data[h])
			table_name=f"{data['database']}.{table_info[t]['tablename']}"
			if not Log.checkStatus(load_id,etl,table_info[t]["source_table"]+"-"+h+".insert",table_name,"Completed"):
			#if file has been processed for the given load id successfully, then, skip it
				sub_log_id,data_start_ts,data_end_ts = Log.insert_log(load_id,etl,table_info[t]["source_table"]+"-"+".insert",table_name,"Started")
				sql = f"INSERT INTO  {table_name} ( {table_info[t]['fields']} ) "
				sql += f"SELECT * FROM ({table_info[t]['insert_query']} {table_info[t]['where_clause']%h}) as src"					
				if table_info[t]['update_fields']:
					sql = f"{sql} ON DUPLICATE KEY UPDATE {table_info[t]['update_fields']}"
				print(sql)			
				cursor.execute(sql)
				affected_row_count = cursor.rowcount
				conn.commit()
				Log.update_log(sub_log_id,"Completed",affected_row_count)				
		
		Log.update_log(log_id,"Completed","")
		return 0

	except mysql.connector.Error as err:
		Log.updateonerror(log_id,sub_log_id,err,sql)
		print(err)
		raise Exception

	except Exception as err:
		Log.updateonerror(log_id,sub_log_id,err,sql)
		print(err)
		if conn is not None:
			conn.rollback()
		return -1

	finally:
		if conn is not None:
			conn.close()

