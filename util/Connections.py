import os
import sys
import mysql.connector
import json
path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0,path)

from config import settings

def stg_db_connect():
	db_config = settings.DB_CONFIG
	conn = mysql.connector.MySQLConnection(host=db_config["host"], port=db_config["port"], user=db_config["user"], passwd=db_config["passwd"], db=db_config["staging_db"],auth_plugin=db_config["auth_plugin"])
	return conn

def dw_db_connect():
	db_config = settings.DB_CONFIG
	conn = mysql.connector.MySQLConnection(host=db_config["host"], port=db_config["port"], user=db_config["user"], passwd=db_config["passwd"], db=db_config["dw_db"],auth_plugin=db_config["auth_plugin"])
	return conn

def log_db_connect():
	db_config = settings.DB_CONFIG
	conn = mysql.connector.MySQLConnection(host=db_config["host"], port=db_config["port"], user=db_config["user"], passwd=db_config["passwd"], db=db_config["dw_db"],auth_plugin=db_config["auth_plugin"])
	return conn

def src_file_connect():
	file_path = settings.SRC_DATA_DIR
	files = sorted(os.listdir(file_path))
	return file_path,files

def get_etl_flow_settings_json():
	file = open(settings.ETL_FLOW_SETTINGS,'r')
	return file

def etl_file_json(data_source_cd):
	file_conn = get_etl_flow_settings_json()
	with file_conn as json_file:
		data = json.load(json_file)
	etl_file_names = data["etl_file_names"]
	for i in range(len(etl_file_names)):
		if (etl_file_names[i]["data_source_cd"]==data_source_cd):
			etl_required_file_names= etl_file_names[i]
	return etl_required_file_names

def create_staging_file_connect(data_source_cd):
	data = etl_file_json(data_source_cd)
	file_name = data['STG_CREATE_JSON']
	file = open(file_name, 'r')
	return file,file_name
	
def get_staging_db_name():
	db_config = settings.DB_CONFIG
	db = db_config["staging_db"]
	return db

def export_dir_connect():
	file_path = settings.EXPORT_FILE_DIR
	return file_path

def json_etl_stg_schema_file_connect():
	file_name = settings.JSON_ETL_STG_SCHEMA
	return file_name

def json_etl_dim_schema_file_connect():
	file_name = settings.JSON_ETL_DIM_SCHEMA
	return file_name

def json_etl_fact_schema_file_connect():
	file_name = settings.JSON_ETL_FACT_SCHEMA
	return file_name

def json_dim_load_file_connect(data_source_cd):
	data =etl_file_json(data_source_cd)
	file_name=data['JSON_DIM_LOAD']
	file = open(file_name, 'r')
	return file,file_name

def json_export_file_connect(data_source_cd):
	data =etl_file_json(data_source_cd)
	file_name=data['DW_PATIENT_APP_EXPORT_JSON_FILE']
	file = open(file_name, 'r')
	return file,file_name

def json_export_schema_file_connect():
	file_name =settings.DW_PATIENT_APP_EXPORT_JSON_VALIDATE_FILE
	return file_name

def json_fact_load_file_connect(data_source_cd):
	data =etl_file_json(data_source_cd)
	file_name=data['JSON_FACT_LOAD']
	file = open(file_name, 'r')
	return file,file_name



