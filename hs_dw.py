from scripts.etl import start_etl
import sys
if __name__ == '__main__':
    try:
        success_flg = start_etl.main()
        if success_flg == -1:
            raise Exception("HS DW Load failed")
    
    except Exception as e:
        print (e)
        sys.exit(-1)