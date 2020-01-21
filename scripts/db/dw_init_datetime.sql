SET @d0 = "2015-01-01";
SET @d1 = "2100-12-31";

SET @date = date_sub(@d0, interval 1 day);

TRUNCATE TABLE healthscore_dw.dim_date ;
-- populate the table with dates
INSERT INTO healthscore_dw.dim_date 
(date_key,yr_mth,day_id,day_of_week_id,day_of_month_id,day_nm,week_id,month_id,month_nm,month_full_nm,
 quarter_id, year_id,lastday_mth,lastday_qtr,lastday_yr)
SELECT @date := date_add(@date, interval 1 day) as date_key, 
date_format(@date, "%Y-%m") as yr_mth,
date_format(@date, "%d") as day_id, 
date_format(@date, "%w") as day_of_week_id,
date_format(@date, "%j") as day_of_year_id,
date_format(@date, "%W") as day_nm , 
date_format(@date, "%U") as week_id,
date_format(@date, "%m") as month_id,
date_format(@date, "%b") as month_nm,
date_format(@date, "%M") as month_full_nm,
quarter(@date) as quarter_id,
year(@date) as year_id,
@date as lastday_mth,
@date as lastday_qtr,
@date as lastday_yr
FROM healthscore_stg.hs_location_master
WHERE date_add(@date, interval 1 day) <= @d1
ORDER BY date_key
; 

TRUNCATE TABLE healthscore_dw.dim_time;
  
  SET @date = "2019-12-30 00:00:00";
  SET @d1 = "2019-12-31 00:00:00";

  INSERT INTO  healthscore_dw.dim_time (time_key,hour,minute,second,ampm)
  select
            TIME(@date := date_add(@date, interval 1 SECOND)),
            HOUR(@date),
            MINUTE(@date),
            SECOND(@date),
            DATE_FORMAT(@date,'%p')
        FROM healthscore_stg.hs_location_master
WHERE date_add(@date, interval 1 second) <= @d1;

DROP TABLE IF EXISTS healthscore_dw.dim_location;

CREATE TABLE healthscore_dw.dim_location (
  location_key bigint(20) NOT NULL,
  zipcode varchar(20) NOT NULL,
  area_nm varchar(100) DEFAULT NULL,
  taluk_nm varchar(100) DEFAULT NULL,
  city_nm varchar(100) DEFAULT NULL,
  state_nm varchar(100) DEFAULT NULL,
  country_nm varchar(50) DEFAULT 'India',
  country_cd varchar(10) DEFAULT 'IND',
  latitude varchar(45) DEFAULT NULL,
  longitude varchar(45) DEFAULT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (location_key),
  UNIQUE (zipcode,area_nm,city_nm,state_nm)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 

