import os
DB_CONFIG = {
"host": "localhost",
"user": "root",
"passwd": "r00!r00T",
"staging_db": "healthscore_stg",
"dw_db":"healthscore_dw",
"port":"3306",
"auth_plugin":"mysql_native_password"
}
# DB_CONFIG = {
# "host": "localhost",
# "user": "root",
# "passwd": "root",
# "staging_db": "healthscore_stg",
# "dw_db":"healthscore_dw",
# "port":"3309",
# "auth_plugin":"mysql_native_password"
# }

DEBUG = True
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC_DATA_DIR = "/home/ubuntu/mysql-extract/dw_import/"
#SRC_DATA_DIR = "/Users/chiamala/mysql-extract/data/dw_import/"
# SRC_DATA_DIR = "/home/csoft-tech/Downloads/CSV/"
EXPORT_FILE_DIR="/home/ubuntu/mysql-extract/dw_export/"
#EXPORT_FILE_DIR="/Users/chiamala/mysql-extract/data/dw_export/"
# EXPORT_FILE_DIR="/home/csoft-tech/Downloads/CSV/"
DB_SCRIPTS_DIR = "scripts/db/"
CONFIG_DIR = "config/"
DW_PATIENT_APP_EXPORT_JSON_FILE = CONFIG_DIR + "dw_patient_app_export.json"
DW_PATIENT_APP_EXPORT_JSON_VALIDATE_FILE = CONFIG_DIR + "dw_patient_app_export_json_schema.json"
JSON_ETL_SCHEMA = CONFIG_DIR +"etl_json_schema.json"
JSON_ETL_FACT_SCHEMA = CONFIG_DIR +"etl_fact_json_schema.json"
JSON_DIM_LOAD = CONFIG_DIR + "dw_dim_schema.json"
STG_CREATE_JSON= CONFIG_DIR+"dw_stg_schema.json"
JSON_FACT_LOAD= CONFIG_DIR + "dw_fact_schema.json"