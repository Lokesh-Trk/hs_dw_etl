# Standard library imports
import collections  
from datetime import datetime
import sys
# Local application import
from . import Connections

def insert_log(load_id, etl, source, target,status, message=None,data_start_ts=None,data_end_ts=None,data_source_cd=""):
    #connecting to db
    conn = Connections.log_db_connect(data_source_cd)
    # default times
    if data_start_ts is None:
        data_start_ts = '1900-01-01 00:00:00'
    if data_end_ts is None:
        data_end_ts = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    check_sql = f"SELECT max(etl_log_id) FROM etl_log WHERE load_id = {load_id} and etl = '{etl}' and source = '{source}' and target = '{target}'"
    cursor = conn.cursor()
    cursor.execute(check_sql)
    result_set = cursor.fetchall()
    if result_set is not None:
        for row in result_set:
            etl_log_id = row[0] 

    if etl_log_id:
        update_log(etl_log_id,'Started','Restarted',data_source_cd)
    else:
        lastload_sql = f"select data_end_ts FROM etl_log where etl_log_id = (SELECT max(etl_log_id) FROM etl_log WHERE etl = '{etl}' and source = '{source}' and target = '{target}' and status = 'Completed')"
        cursor.execute(lastload_sql)
        result_set = cursor.fetchall()
        if result_set is not None:
            for row in result_set:
                data_start_ts = row[0].strftime('%Y-%m-%d %H:%M:%S') #update start ts to last loaded end ts

        sql = f"INSERT INTO etl_log (load_id, etl, source, target,status,message,data_start_ts,data_end_ts) values ({load_id},'{etl}','{source}','{target}','{status}','{message}','{data_start_ts}','{data_end_ts}')"
        cursor.execute(sql) 
        conn.commit()
        etl_log_id = cursor.lastrowid

    conn.close()
    return etl_log_id,data_start_ts,data_end_ts

def update_log(log_id,status,message,data_source_cd):
    #connecting to db
    conn = Connections.log_db_connect(data_source_cd)
    cursor = conn.cursor()
    sql = f'update etl_log set status = "{status}", message = "{message}" where etl_log_id={log_id}'
    cursor.execute(sql) 
    conn.commit()
    conn.close()

def check_status(load_id,etl,source,target,status,data_source_cd):
    #connecting to db
    conn = Connections.log_db_connect(data_source_cd)
    cursor = conn.cursor() 
    sql = f"select count(*) from etl_log where load_id={load_id} and etl='{etl}' and source='{source}' and target='{target}' and status='{status}'"
    cursor.execute(sql)
    if (cursor.fetchone()[0] == 0):
        return False
    else:
        return True

def insert_load_details(source_cd):
    #connecting to db
    conn = Connections.log_db_connect(source_cd)
    cursor = conn.cursor() 
    status = 'Started'
    sql = f"insert into etl_load_details(source_cd,status) VALUES ('{source_cd}','{status}')"
    cursor.execute(sql)
    etl_load_id = cursor.lastrowid
    conn.commit()
    conn.close()
    return etl_load_id

def update_load_details(load_id,data_source_cd,status,message):
     #connecting to db
    conn = Connections.log_db_connect(data_source_cd)
    cursor = conn.cursor() 
    sql = f"update etl_load_details set status = '{status}', message = '{message}' where etl_load_id = {load_id}"
    cursor.execute(sql)
    conn.commit()
    conn.close()

def check_current_load_details(source):
    #connecting to db
    conn = Connections.log_db_connect(source)
    cursor = conn.cursor() 
    status = 'Failed'
    sql = f"select etl_load_id from etl_load_details where source_cd = '{source}' and status = '{status}'"
    cursor.execute(sql) 
    result_set = cursor.fetchall()
    load_id = None
    if result_set is not None:
        for row in result_set:
            load_id= str(row[0]) 
    
    if load_id == None:
        status = 'Started'
        sql = f"select etl_load_id from etl_load_details where source_cd = '{source}' and status = '{status}'"
        cursor.execute(sql) 
        result_set = cursor.fetchall()
        if result_set is not None:
            for row in result_set:
                load_id= str(row[0])
    return load_id, status

def check_current_status(etl,load_id,source,target,data_source_cd):
    #connecting to db
    conn = Connections.log_db_connect(data_source_cd)
    cursor = conn.cursor() 
    start_ts = None
    end_ts= None
    
    sql = f"select etl_log_id,status,data_start_ts,data_end_ts from etl_log where etl = '{etl}' and load_id = {load_id} and source = '{source}' and target = '{target}' and status in ('Failed','Completed')"
    cursor.execute(sql) 
    result_set = cursor.fetchall()
    etl_log_id = None
    if result_set is not None:
        for row in result_set:
            etl_log_id= str(row[0]) 
            status= row[1]
            start_ts = row[2]
            end_ts = row[3]

    # if previous load did not fail, create a new load id
    if etl_log_id == None:
        etl_log_id,start_ts,end_ts = insert_log(load_id,etl,source,target,"Started",None,None,None,data_source_cd)
    else:
        if status == "Started":
            etl_log_id = None
            raise Exception("Load currently in progress. Cannot start another in parallel. ")
        if status == "Completed":
            etl_log_id = "-1"
            start_ts = None
            end_ts= None
    return etl_log_id,start_ts,end_ts

def update_on_error(log_id,sub_log_id,error,sql,data_source_cd):
    if log_id:
        update_log(log_id,"Failed",format(error),data_source_cd)
    if sub_log_id != -1:
        update_log(sub_log_id,"Failed",sql,data_source_cd)