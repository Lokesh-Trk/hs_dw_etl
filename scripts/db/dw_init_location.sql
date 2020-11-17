INSERT INTO dim_location
(
zipcode,
area_nm,
city_nm,
state_nm,
country_nm,
country_cd,
latitude,
longitude)
SELECT   
zipcode,
area,
city,
state,
max(country),
max(country_code),
max(latitude),
max(longitude)
FROM healthscore_stg.hs_location_master
group by zipcode, area, city,state 
