import os

DB_CONFIG = {
"host": "localhost",
"user": "root",
"passwd": "root",
"staging_db": "healthscore_stg",
"dw_db":"healthscore_dw",
"port":"3309",
"auth_plugin":"mysql_native_password"
}

DEBUG = True
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC_DATA_DIR = "/Users/chiamala/mysql-extract/data/dw_import/"
#SRC_DATA_DIR = "/home/csoft-tech/Downloads/CSV/"
EXPORT_FILE_DIR="/Users/chiamala/mysql-extract/data/dw_export/"
#EXPORT_FILE_DIR="/home/csoft-tech/Downloads/CSV/"
DB_SCRIPTS_DIR = "scripts/db/"
CONFIG_DIR = "config/"
STG_CREATE_SCRIPT =DB_SCRIPTS_DIR + "dw_create_stg_script.sql"
DW_PATIENT_APP_EXPORT_JSON_FILE = CONFIG_DIR + "dw_patient_app_export.json"
DW_PATIENT_APP_EXPORT_JSON_VALIDATE_FILE = CONFIG_DIR + "dw_patient_app_export_json_schema.json"
EXPORT_SQL_FILE = EXPORT_FILE_DIR + "load_csv_to_patient_db_stg.sql"
JSON_ETL_SCHEMA = CONFIG_DIR +"etl_json_schema.json"
JSON_DIM_LOAD = CONFIG_DIR + "dw_dim_schema.json"