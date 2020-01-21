import os
import sys
import mysql.connector
import json

path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0,path)

from config import settings

def stg_db_connect():
	db_config = settings.DB_CONFIG
	conn = mysql.connector.connect(host=db_config["host"], port=db_config["port"], user=db_config["user"], passwd=db_config["passwd"], db=db_config["staging_db"],auth_plugin=db_config["auth_plugin"])
	return conn

def dw_db_connect():
	db_config = settings.DB_CONFIG
	conn = mysql.connector.connect(host=db_config["host"], port=db_config["port"], user=db_config["user"], passwd=db_config["passwd"], db=db_config["dw_db"],auth_plugin=db_config["auth_plugin"])
	return conn

def log_db_connect():
	db_config = settings.DB_CONFIG
	conn = mysql.connector.connect(host=db_config["host"], port=db_config["port"], user=db_config["user"], passwd=db_config["passwd"], db=db_config["dw_db"],auth_plugin=db_config["auth_plugin"])
	return conn

def src_file_connect():
	file_path = settings.SRC_DATA_DIR
	files = sorted(os.listdir(file_path))
	return file_path, files

def createStaging_file_connect():
	file = open(settings.STG_CREATE_JSON, 'r')
	return file

def getStagingDBName():
	db_config = settings.DB_CONFIG
	db = db_config["staging_db"]
	return db

def export_dir_connect():
	file_path= settings.EXPORT_FILE_DIR
	return file_path

def json_etl_schema_file_connect():
	file = open(settings.JSON_ETL_SCHEMA, 'r')
	file_name = settings.JSON_ETL_SCHEMA
	return file,file_name

def json_etl_fact_schema_file_connect():
	file = open(settings.JSON_ETL_FACT_SCHEMA, 'r')
	file_name = settings.JSON_ETL_FACT_SCHEMA
	return file,file_name

def json_dim_load_file_connect():
	file = open(settings.JSON_DIM_LOAD, 'r')
	file_name = settings.JSON_DIM_LOAD
	return file,file_name

def json_export_file_connect():
	file = open(settings.DW_PATIENT_APP_EXPORT_JSON_FILE, 'r')
	file_name = settings.DW_PATIENT_APP_EXPORT_JSON_FILE
	return file,file_name

def json_export_schema_file_connect():
	file = open(settings.DW_PATIENT_APP_EXPORT_JSON_VALIDATE_FILE, 'r')
	file_name = settings.DW_PATIENT_APP_EXPORT_JSON_VALIDATE_FILE
	return file,file_name

def createStaging_file_connect():
	file = open(settings.STG_CREATE_JSON, 'r')
	return file

def json_fact_load_file_connect():
	file = open(settings.JSON_FACT_LOAD, 'r')
	file_name = settings.JSON_FACT_LOAD
	return file,file_name
