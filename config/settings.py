import os
DB_CONFIG = {
"host": "localhost",
"user": "dw_user",
"passwd": "d33W$er99",
"staging_db": "healthscore_stg",
"dw_db":"healthscore_dw",
"port":"3306",
"auth_plugin":"mysql_native_password"
}
CONFIG_DIR = "config/"
DEBUG = True
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC_DATA_DIR = "/home/ubuntu/mysql-extract/dw_import/"
#SRC_DATA_DIR = "/Users/chiamala/mysql-extract/data/dw_import/"
#SRC_DATA_DIR = "/home/csoft-tech/Downloads/CSV/"
EXPORT_FILE_DIR="/home/ubuntu/mysql-extract/dw_export/"
#EXPORT_FILE_DIR="/Users/chiamala/mysql-extract/data/dw_export/"
#EXPORT_FILE_DIR="/home/csoft-tech/Downloads/CSV/"
DB_SCRIPTS_DIR = "scripts/db/"

def json_schema_file_path(file):
    file= "validation/"+file
    return file

ETL_FLOW_SETTINGS = CONFIG_DIR+"etl_flow_settings.json"
JSON_ETL_STG_SCHEMA = json_schema_file_path("etl_stg_json_schema.json")
JSON_ETL_DIM_SCHEMA = json_schema_file_path("etl_dim_json_schema.json")
JSON_ETL_FACT_SCHEMA =json_schema_file_path("etl_fact_json_schema.json")
DW_PATIENT_APP_EXPORT_JSON_VALIDATE_FILE = json_schema_file_path("dw_patient_app_export_json_schema.json")
EXCLUDE_DATA_SOURCES_FILTER="hs_meet','myhsapp"