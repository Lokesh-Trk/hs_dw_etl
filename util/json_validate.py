import json
import jsonschema

def json_dup_check(data):
    unique_list=[]  
    for x in data:
        tb_nm = x['tablename']
        if tb_nm not in unique_list:
            unique_list.append(tb_nm)
        elif tb_nm in unique_list:
            raise Exception("There is duplication in ",tb_nm)

def json_validate(data, json_schema_file,dupe_check_flg=True):
    with open(json_schema_file) as json_file:
        schema = json.load(json_file)
    try:
        jsonschema.validate(data, schema)
        if dupe_check_flg:
            json_dup_check(data["table_info"])

    except jsonschema.exceptions.ValidationError as e:
        print("well-formed but invalid JSON:", e)

    except json.decoder.JSONDecodeError as e:
        print("poorly-formed text, not JSON:", e)

    except Exception as e:
        raise Exception("Error",e) 
