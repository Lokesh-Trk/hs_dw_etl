import json
from . import Connections as Connections
from . import json_validate as json_validate

def get_files(data_source,etl_stage):
	if etl_stage=="Staging_Refresh_DB":
		json_file, json_filename = Connections.create_staging_file_connect(data_source)
		json_schema_file = Connections.json_etl_stg_schema_file_connect()
	elif etl_stage=="Staging_to_DW_Dimensions":
		json_file, json_filename=Connections.json_dim_load_file_connect(data_source)
		json_schema_file = Connections.json_etl_dim_schema_file_connect()
	elif etl_stage=="Staging_to_DW_Facts":
		json_file, json_filename=Connections.json_fact_load_file_connect(data_source)
		json_schema_file = Connections.json_etl_fact_schema_file_connect()
	elif etl_stage=="DW_to_Patient_app_Exports":
		json_file, json_filename=Connections.json_export_file_connect(data_source)
		json_schema_file = Connections.json_export_schema_file_connect()
	return json_file, json_filename,json_schema_file

def get_table_data(data_sources,etl_stage,crud_type):
	data=[]
	for i in range(len(data_sources)):
		json_file, json_filename,json_schema_file = get_files(data_sources[i],etl_stage)
		data_dupe_check = False
		json_validate.json_validate(json_filename,json_schema_file,data_dupe_check)
		json_data = json.load(json_file)
		
		if crud_type=="create":
			data += json_data["create_table_info"]
		elif crud_type=="insert":
			data += json_data["insert_table_info"]
		elif crud_type=="update":
			data += json_data["update_table_info"]
		elif crud_type=="export":
			data += json_data["export_table_info"]
			return data
	target_database = json_data["database"]
	return target_database, data
