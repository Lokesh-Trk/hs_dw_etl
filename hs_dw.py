import sys
import argparse
from scripts.etl import Load_DW_Etl

if __name__ == '__main__':
    try:
        parser=argparse.ArgumentParser()
        parser.add_argument("data_source_cd", type=str)
        args = parser.parse_args()
        success_flg = Load_DW_Etl.main(args.data_source_cd)
        if success_flg == -1:
            raise Exception("HS DW Load failed")
    
    except Exception as e:
        print (e)
        sys.exit(-1)