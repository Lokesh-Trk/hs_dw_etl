import os
import sys
import mysql.connector
import json
import logging
from pathlib import Path
from itertools import product
path = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0,path)
from util import Connections, Log, Load_Data

def start_etl(load_id,elements):
	#log file metadata
	etl = Path(__file__).stem
	source = "Staging"
	target = "Facts"
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
		target_database_nm, insert_fact_table_data = Load_Data.get_table_data(elements,'Staging_to_DW_Facts','insert')
	#	Insert new data created in the load date range
		sql="SELECT hospital_key,hospital_cd from healthscore_dw.dim_hospital"
		cursor.execute(sql)
		hospital_data=cursor.fetchall()
		ranges = get_ranges(hospital_data, insert_fact_table_data)
		for h, t in product(*ranges):
			table_name=f"{target_database_nm}.{insert_fact_table_data[t]['tablename']}"
			if not Log.check_status(load_id,etl,insert_fact_table_data[t]["source_table"]+"-"+hospital_data[h][1]+".insert",table_name,"Completed"):
			#if file has been processed for the given load id successfully, then, skip it
				sub_log_id,data_start_ts,data_end_ts = Log.insert_log(load_id,etl,insert_fact_table_data[t]["source_table"]+"-"+hospital_data[h][1]+".insert",table_name,"Started")
				sql = f"INSERT INTO  {table_name} ( {insert_fact_table_data[t]['fields']} ) "
				sql += f"SELECT * FROM ({insert_fact_table_data[t]['insert_query']} WHERE {insert_fact_table_data[t]['where_clause']%hospital_data[h][0]}) as src"					
				if insert_fact_table_data[t]['update_fields']:
					sql = f"{sql} ON DUPLICATE KEY UPDATE {insert_fact_table_data[t]['update_fields']}"
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
		Log.update_on_error(log_id,sub_log_id,err,sql)
		if conn is not None:
			conn.rollback()
		return -1

	finally:
		if conn is not None:
			conn.close()

def get_ranges(data1, data2):
	len_data1=len(data1)
	len_data2=len(data2)
	ranges = [
    	range(0,len_data1),
    	range(0,len_data2)
		]
	return ranges