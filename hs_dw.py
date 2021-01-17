import sys
import argparse
from scripts.etl import Load_DW_Etl

if __name__ == '__main__':
    try:
        # call the function with source_cd as "hs_shared" or "myhsapp"
        parser=argparse.ArgumentParser()
        parser.add_argument("data_source_cd", type=str, help='hs_shared, hs_az, hs_nucleus, hs_suvitas, hs_uoh, myhsapp- to load the customer care dashboard')
        args = parser.parse_args()
        success_flg = Load_DW_Etl.main(args.data_source_cd)
        if success_flg == -1:
            raise Exception("HS DW Load failed")
    
    except Exception as e:
        print (e)
        sys.exit(-1)