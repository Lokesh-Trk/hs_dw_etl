DROP VIEW IF EXISTS healthscore_dw.hpn_hospital_master_view;
CREATE VIEW healthscore_dw.hpn_hospital_master_view
as   SELECT hospital_key, hospital_cd, hospital_nm, hospital_addr_line1, hospital_addr_line2, hospital_addr_city_nm, hospital_addr_state_nm, hospital_addr_country_nm, hospital_addr_zipcode, hospital_phone_num, hospital_email_addr, hospital_logo 
FROM healthscore_dw.dim_hospital dh 
where hospital_cd in ('HPN')
;
 
DROP VIEW IF EXISTS healthscore_dw.hpn_patient_master_view;
CREATE VIEW healthscore_dw.hpn_patient_master_view as
SELECT mph.hospital_key,dp.patient_key,patient_unique_id,patient_nm,patient_first_nm,patient_middle_nm,patient_last_nm,patient_gender,patient_birth_dt,patient_death_ts,patient_mother_nm
,patient_father_nm,blood_group,contact_addr_city_nm,contact_addr_state_nm,contact_addr_country_nm,contact_addr_zipcode, date(mph.hospital_registration_ts) as first_visit_date, mph.color_category_nm as patient_category, patient_socio_economic_status,patient_occupation_status,patient_marital_status,patient_religion,patient_spouse_occupation
 FROM healthscore_dw.dim_patient dp
join healthscore_dw.map_patient_hospital mph
on mph.patient_key = dp.patient_key
join healthscore_dw.hpn_hospital_master_view dh
on mph.hospital_key = dh.hospital_key ;

DROP VIEW IF EXISTS healthscore_dw.hpn_patient_assessments_view;
CREATE VIEW healthscore_dw.hpn_patient_assessments_view as
SELECT   
fpa.patient_assmt_key,fpa.patient_key,visit_hospital_key as hospital_key,patient_visit_key,assessed_date_key,assessed_time_key,assessed_ts, fpa.assessment_created_by_staff_key, fpa.assessment_modified_by_staff_key, hospital_dept_nm,
assessment_scale_master_id,fpa.patient_assessment_id , 
assessment_scale_desc as assessment_scale_full_nm,
SUBSTRING_INDEX(assessment_scale_desc,'-',1) as assessment_category,
SUBSTRING_INDEX(assessment_scale_desc,'-',-1) as assessment_scale_desc, 
trim(replace(result_item_display_txt,'Statistical Scores and comments','')) as result_item_display_txt ,
min(result_item_row_no) as result_item_row_no,min(result_item_column_no) as result_item_column_no,
max(result_item_ref_range_txt) result_item_ref_range_txt ,max(result_item_min_value) as result_item_min_value,max(result_item_max_value) as result_item_max_value ,
max(case when result_item_display_txt like '%Signing Credentials%' then replace(replace(result_item_value,'<p>',''),'</p>','\n')  when result_item_display_txt not like '%Statistical Scores and comments%' then fnStripTags(result_item_value) else null end) as result_item_value,
max(case when result_item_display_txt like '%Statistical Scores and comments%' then fnStripTags(result_item_value) else null end) as statistical_score_and_comment,
sum(case when result_item_value REGEXP '^[0-9]+$' then result_item_value else null end) as numeric_result_value
FROM healthscore_dw.fact_patient_assessments fpa
join healthscore_dw.fact_patient_assessment_results fpar
on fpa.patient_assmt_key=fpar.patient_assmt_key
join healthscore_dw.hpn_patient_master_view pm
on fpa.patient_key = pm.patient_key
join healthscore_dw.hpn_hospital_master_view hm
on fpa.visit_hospital_key = hm.hospital_key   
group by fpa.patient_assmt_key,fpa.patient_key,visit_hospital_key  ,patient_visit_key,assessed_date_key,assessed_time_key,assessed_ts,hospital_dept_nm,
assessment_scale_master_id,fpa.patient_assessment_id , assessment_scale_desc,
SUBSTRING_INDEX(assessment_scale_desc,'-',1)  ,
SUBSTRING_INDEX(assessment_scale_desc,'-',-1)  ,trim(replace(result_item_display_txt,'Statistical Scores and comments','')) 
;


DROP VIEW IF EXISTS healthscore_dw.hpn_hospital_staff_master_view;
CREATE VIEW healthscore_dw.hpn_hospital_staff_master_view as
select ds.staff_key, ds.hospital_key, ds.hospital_staff_cd, ds.hospital_staff_full_nm,hospital_staff_user_nm,hospital_staff_gender,hospital_staff_type_nm,hospital_staff_kmc_reg_no,hospital_staff_dept_nm,ds.active_flg
from  healthscore_dw.dim_staff ds
 join healthscore_dw.hpn_hospital_master_view dh
  on ds.hospital_key = dh.hospital_key;
 
DROP VIEW IF EXISTS healthscore_dw.hpn_patient_visit_view;
CREATE VIEW healthscore_dw.hpn_patient_visit_view as
select fpv.patient_visit_key,fpv.patient_key,fpv.visit_hospital_key as hospital_key,visit_date_key,visit_time_key,patient_visit_cd,visit_doctor_staff_key,primary_ext_doctor_staff_key as primary_ext_doctor_staff_key,reference_ext_doctor_staff_key as reference_ext_doctor_staff_key,checkin_ts,checkout_ts,checkout_type, delivery_ts, outcome_type, condition_at_discharge, discharge_ts,case when visit_type = 1 then 'IN' else 'OUT' end as visit_type,visit_reason, visit_rate_category_nm, visit_ip_nbr,admission_method, cancel_reason, ward_nm, referral_source
,(case when pm.first_visit_date = date(fpv.checkin_ts) then 1 else 0 end) as first_visit_flg
, round(datediff(fpv.checkin_ts,pm.patient_birth_dt)/365,2) age_at_visit
, fpva.visit_diagnosis, fpva.prev_hospital_duration_of_stay,fpva.spl_req  
from healthscore_dw.fact_patient_visits fpv
join healthscore_dw.hpn_patient_master_view pm
on fpv.patient_key = pm.patient_key
join healthscore_dw.hpn_hospital_master_view hm
on fpv.visit_hospital_key = hm.hospital_key
left join healthscore_dw.fact_patient_visit_admission fpva 
on fpv.patient_visit_key = fpva.patient_visit_key  
; 

DROP VIEW IF EXISTS healthscore_dw.hpn_patient_past_history_view;
CREATE VIEW healthscore_dw.hpn_patient_past_history_view AS
SELECT fci.patient_key,patient_visit_key,group_concat(distinct concat(fnStripTags(clinical_info_desc),case when effective_from_ts is not null then concat(' since ',date(effective_from_ts)) else '' end)) as past_history
FROM healthscore_dw.fact_patient_clinical_info fci
join healthscore_dw.map_patient_hospital mph
on mph.patient_key = fci.patient_key
join healthscore_dw.hpn_hospital_master_view  hm
on mph.hospital_key = hm.hospital_key
WHERE clinical_info_type_cd='pasthistory'
group by fci.patient_key,patient_visit_key;

DROP VIEW IF EXISTS healthscore_dw.hpn_patient_family_history_view;
CREATE VIEW healthscore_dw.hpn_patient_family_history_view AS
SELECT fci.patient_key,patient_visit_key,group_concat(distinct concat(SUBSTRING_INDEX(fnStripTags(clinical_info_desc),'-',-1),case when effective_from_ts is not null then concat(' since ',date(effective_from_ts)) else '' end))  as family_history 
FROM healthscore_dw.fact_patient_clinical_info fci
join healthscore_dw.map_patient_hospital mph
on mph.patient_key = fci.patient_key
join healthscore_dw.hpn_hospital_master_view  hm
on mph.hospital_key = hm.hospital_key
WHERE clinical_info_type_cd='familyhistory'
group by fci.patient_key,patient_visit_key;


​
DROP VIEW IF EXISTS healthscore_dw.hpn_patient_diagnosis_view;
CREATE VIEW healthscore_dw.hpn_patient_diagnosis_view AS
SELECT fci.patient_key,patient_visit_key,group_concat(distinct clinical_info_desc)  as diagnosis_nm 
FROM healthscore_dw.fact_patient_clinical_info fci
join healthscore_dw.map_patient_hospital mph
on mph.patient_key = fci.patient_key
join healthscore_dw.hpn_hospital_master_view  hm
on mph.hospital_key = hm.hospital_key
WHERE clinical_info_type_cd='diagnosis'
group by fci.patient_key,patient_visit_key;

  
-- CREATE USER hpn_db_viewer@localhost IDENTIFIED BY <PWD>; 
GRANT SELECT ON `healthscore_dw`.`hpn_hospital_master_view` TO 'hpn_db_viewer'@'localhost' ; 
GRANT SELECT ON `healthscore_dw`.`hpn_patient_master_view` TO 'hpn_db_viewer'@'localhost' ;  
GRANT SELECT ON `healthscore_dw`.`hpn_patient_assessments_view` TO 'hpn_db_viewer'@'localhost' ; 
GRANT SELECT ON `healthscore_dw`.`hpn_hospital_staff_master_view` TO 'hpn_db_viewer'@'localhost' ; 
GRANT SELECT ON `healthscore_dw`.`hpn_patient_visit_view` TO 'hpn_db_viewer'@'localhost' ;       
GRANT SELECT ON `healthscore_dw`.`hpn_patient_past_history_view` TO 'hpn_db_viewer'@'localhost' ;   
GRANT SELECT ON `healthscore_dw`.`hpn_patient_family_history_view` TO 'hpn_db_viewer'@'localhost' ;   

GRANT SELECT ON `healthscore_dw`.`hpn_patient_diagnosis_view` TO 'hpn_db_viewer'@'localhost' ;   

DROP VIEW IF EXISTS healthscore_dw.hpn_patient_master_view;
CREATE VIEW healthscore_dw.hpn_patient_master_view as
SELECT mph.hospital_key,dp.patient_key,patient_unique_id,patient_nm,patient_first_nm,patient_middle_nm,patient_last_nm,patient_gender,patient_birth_dt,patient_death_ts,patient_mother_nm
,patient_father_nm,blood_group,contact_addr_city_nm,contact_addr_state_nm,contact_addr_country_nm,contact_addr_zipcode, date(mph.hospital_registration_ts) as first_visit_date, mph.color_category_nm as patient_category, 
patient_socio_economic_status, 
pd.patient_occupation_status,
pd.patient_marital_status,
pd.patient_education_status,
patient_handedness_status,
patient_diet_status,
patient_L1_status,
patient_mother_tongue_status,
patient_retired_status
 FROM healthscore_dw.dim_patient dp
join healthscore_dw.map_patient_hospital mph
on mph.patient_key = dp.patient_key
join healthscore_dw.hpn_hospital_master_view dh
on mph.hospital_key = dh.hospital_key 
left join 
(SELECT   
fpa.patient_key,visit_hospital_key as hospital_key,
max(case when result_item_display_txt = 'Occupation' then result_item_value else null end) as patient_occupation_status,
max(case when result_item_display_txt = 'Marital Status' then result_item_value else null end) as patient_marital_status,
max(case when result_item_display_txt = 'Education' then result_item_value else null end ) as patient_education_status,
max(case when result_item_display_txt = 'Handedness' then result_item_value else null end ) as patient_handedness_status,
max(case when result_item_display_txt = 'Diet' then result_item_value else null end ) as patient_diet_status,
max(case when result_item_display_txt = 'L1' then result_item_value else null end ) as patient_L1_status,
max(case when result_item_display_txt = 'Mother tongue' then result_item_value else null end ) as patient_mother_tongue_status,
max(case when result_item_display_txt = 'Retired' then result_item_value else null end ) as patient_retired_status
FROM healthscore_dw.fact_patient_assessments fpa
join healthscore_dw.fact_patient_assessment_results fpar
on fpa.patient_assmt_key=fpar.patient_assmt_key 
where assessment_scale_desc = 'Patient Demographic' and result_item_value is not null
and result_item_display_txt in ('Occupation', 'Marital Status', 'Education')
group by  fpa.patient_key,visit_hospital_key 
) pd 
on pd.patient_key = dp.patient_key
and mph.hospital_key = pd.hospital_key 
;

DROP VIEW IF EXISTS healthscore_dw.hpn_patient_assessments_view;
CREATE VIEW healthscore_dw.hpn_patient_assessments_view as
SELECT   
fpa.patient_assmt_key,fpa.patient_key,visit_hospital_key as hospital_key,patient_visit_key,assessed_date_key,assessed_time_key,assessed_ts,hospital_dept_nm,
assessment_scale_master_id,fpa.patient_assessment_id , 
assessment_scale_desc as assessment_scale_full_nm,
SUBSTRING_INDEX(assessment_scale_desc,'-',1) as assessment_category,
SUBSTRING_INDEX(assessment_scale_desc,'-',-1) as assessment_scale_desc, 
trim(replace(result_item_display_txt,'Statistical Scores and comments','')) as result_item_display_txt ,
min(result_item_row_no) as result_item_row_no,min(result_item_column_no) as result_item_column_no,
max(result_item_ref_range_txt) result_item_ref_range_txt ,max(result_item_min_value) as result_item_min_value,max(result_item_max_value) as result_item_max_value ,
max(case when result_item_display_txt like '%Signing Credentials%' then replace(replace(result_item_value,'<p>',''),'</p>','\n') when result_item_display_txt like '%Recommendations%' then replace(replace(replace(replace(replace(replace(result_item_value,'<div>',''),'</div>','\n'),'<ul>','\n'),'</ul>','\n'),'<li>','* '),'</li>','\n')  when result_item_display_txt not like '%Statistical Scores and comments%' then fnStripTags(result_item_value) else null end) as result_item_value,
max(case when result_item_display_txt like '%Statistical Scores and comments%' then fnStripTags(result_item_value) else null end) as statistical_score_and_comment,
sum(case when result_item_value REGEXP '^([0-9]*\.)?[0-9]+$' then result_item_value else null end) as numeric_result_value
FROM healthscore_dw.fact_patient_assessments fpa
join healthscore_dw.fact_patient_assessment_results fpar
on fpa.patient_assmt_key=fpar.patient_assmt_key
join healthscore_dw.hpn_patient_master_view pm
on fpa.patient_key = pm.patient_key
join healthscore_dw.hpn_hospital_master_view hm
on fpa.visit_hospital_key = hm.hospital_key  
group by fpa.patient_assmt_key,fpa.patient_key,visit_hospital_key  ,patient_visit_key,assessed_date_key,assessed_time_key,assessed_ts,hospital_dept_nm,
assessment_scale_master_id,fpa.patient_assessment_id , assessment_scale_desc,
SUBSTRING_INDEX(assessment_scale_desc,'-',1)  ,
SUBSTRING_INDEX(assessment_scale_desc,'-',-1)  ,trim(replace(result_item_display_txt,'Statistical Scores and comments','')) 
union all 
SELECT   distinct
fpa.patient_assmt_key,fpa.patient_key,visit_hospital_key as hospital_key,patient_visit_key,assessed_date_key,assessed_time_key,assessed_ts,hospital_dept_nm,
assessment_scale_master_id,fpa.patient_assessment_id , 
assessment_scale_desc as assessment_scale_full_nm,
SUBSTRING_INDEX(assessment_scale_desc,'-',1) as assessment_category,
SUBSTRING_INDEX(assessment_scale_desc,'-',-1) as assessment_scale_desc, 
SUBSTRING_INDEX(assessment_scale_desc,'-',1) as result_item_display_txt ,
null as result_item_row_no,null as result_item_column_no,
null result_item_ref_range_txt ,
null as result_item_min_value,null as result_item_max_value ,
'-' as result_item_value,
null as statistical_score_and_comment,
null as numeric_result_value
FROM healthscore_dw.fact_patient_assessments fpa
join healthscore_dw.fact_patient_assessment_results fpar
on fpa.patient_assmt_key=fpar.patient_assmt_key
join healthscore_dw.hpn_patient_master_view pm
on fpa.patient_key = pm.patient_key
join healthscore_dw.hpn_hospital_master_view hm
on fpa.visit_hospital_key = hm.hospital_key   
group by fpa.patient_assmt_key,fpa.patient_key,visit_hospital_key  ,patient_visit_key,assessed_date_key,assessed_time_key,assessed_ts,hospital_dept_nm,
assessment_scale_master_id,fpa.patient_assessment_id , assessment_scale_desc,
SUBSTRING_INDEX(assessment_scale_desc,'-',1)  ,
SUBSTRING_INDEX(assessment_scale_desc,'-',-1) 
;