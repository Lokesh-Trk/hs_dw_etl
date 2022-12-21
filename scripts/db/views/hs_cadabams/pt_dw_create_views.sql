DROP VIEW IF EXISTS healthscore_dw.pt_hospital_master_view;
CREATE VIEW healthscore_dw.pt_hospital_master_view
as   SELECT hospital_key, hospital_cd, hospital_nm, hospital_addr_line1, hospital_addr_line2, hospital_addr_city_nm, hospital_addr_state_nm, hospital_addr_country_nm, hospital_addr_zipcode, hospital_phone_num, hospital_email_addr, hospital_logo 
FROM healthscore_dw.dim_hospital dh 
where hospital_cd like 'PT%'
;
 

DROP VIEW IF EXISTS healthscore_dw.pt_bill_items_master_view;
CREATE VIEW healthscore_dw.pt_bill_items_master_view
as select dbi.hospital_key, bill_item_key,bill_item_type,bill_item_category_cd,bill_item_category_nm,bill_item_category_desc,bill_item_cd,bill_item_nm,bill_item_amt,transaction_type_cd,
effective_from_ts,effective_to_ts,rate_category_nm,dbi.active_flg
 from healthscore_dw.dim_bill_items dbi
join healthscore_dw.pt_hospital_master_view dh
on dbi.hospital_key = dh.hospital_key
;
  
DROP VIEW IF EXISTS healthscore_dw.pt_patient_master_view;
CREATE VIEW healthscore_dw.pt_patient_master_view as
SELECT mph.hospital_key,dp.patient_key,patient_unique_id,patient_nm,patient_first_nm,patient_middle_nm,patient_last_nm,patient_gender,patient_birth_dt,patient_death_ts,patient_mother_nm
,patient_father_nm,blood_group,contact_addr_city_nm,contact_addr_state_nm,contact_addr_country_nm,contact_addr_zipcode, date(mph.hospital_registration_ts) as first_visit_date, mph.color_category_nm as patient_category, patient_socio_economic_status,patient_occupation_status,patient_marital_status,patient_religion,patient_spouse_occupation
 FROM healthscore_dw.dim_patient dp
join healthscore_dw.map_patient_hospital mph
on mph.patient_key = dp.patient_key
join healthscore_dw.pt_hospital_master_view dh
on mph.hospital_key = dh.hospital_key ;

DROP VIEW IF EXISTS healthscore_dw.pt_patient_medications_view;
CREATE VIEW healthscore_dw.pt_patient_medications_view as
SELECT patient_medication_key, pm.patient_key, pharma_product_ref_id, pharma_product_ref_display_txt, pharma_brand_nm, dosage, drug_form_ref_id, drug_form_ref_display_txt, frequency, comments, start_dt, end_dt, active_flg, prescribed_doctor_staff_key, prescribed_hospital_key, prescribed_ts, prescribed_patient_visit_key,  prescribed_date_key, prescribed_time_key
FROM healthscore_dw.fact_patient_medications fpm
join  healthscore_dw.pt_patient_master_view pm
on fpm.patient_key = pm.patient_key
join healthscore_dw.pt_hospital_master_view hm
on fpm.prescribed_hospital_key = hm.hospital_key;
​
DROP VIEW IF EXISTS healthscore_dw.pt_patient_assessments_view;
CREATE VIEW healthscore_dw.pt_patient_assessments_view as
SELECT fpa.patient_assmt_key,fpa.patient_key,visit_hospital_key as hospital_key,patient_visit_key,assessed_date_key,assessed_time_key,assessed_ts, fpa.assessment_created_by_staff_key, fpa.assessment_modified_by_staff_key, assessment_scale_desc,hospital_dept_nm,
patient_assessment_id ,patient_assessment_result_id,assessment_result_item_master_id,result_item_display_txt,result_item_value,result_item_row_no,result_item_column_no,result_item_ref_range_txt,result_item_min_value,result_item_max_value
FROM healthscore_dw.fact_patient_assessments fpa
join healthscore_dw.fact_patient_assessment_results fpar
on fpa.patient_assmt_key=fpar.patient_assmt_key
join healthscore_dw.pt_patient_master_view pm
on fpa.patient_key = pm.patient_key
join healthscore_dw.pt_hospital_master_view hm
on fpa.visit_hospital_key = hm.hospital_key
where fpar.active_flg = 1 and fpa.active_flg = 1
;
  
DROP VIEW IF EXISTS healthscore_dw.pt_hospital_staff_master_view;
CREATE VIEW healthscore_dw.pt_hospital_staff_master_view as
select ds.staff_key, ds.hospital_key, ds.hospital_staff_cd, ds.hospital_staff_full_nm,hospital_staff_user_nm,hospital_staff_gender,hospital_staff_type_nm,hospital_staff_kmc_reg_no,hospital_staff_dept_nm,ds.active_flg
from 
  healthscore_dw.dim_staff ds
 join healthscore_dw.pt_hospital_master_view dh
  on ds.hospital_key = dh.hospital_key;
 

​

DROP VIEW IF EXISTS healthscore_dw.pt_patient_visit_view;
CREATE VIEW healthscore_dw.pt_patient_visit_view as
select fpv.patient_visit_key,fpv.patient_key,fpv.visit_hospital_key as hospital_key,visit_date_key,visit_time_key,patient_visit_cd,visit_doctor_staff_key,primary_ext_doctor_staff_key as primary_ext_doctor_staff_key,reference_ext_doctor_staff_key as reference_ext_doctor_staff_key,checkin_ts,checkout_ts,checkout_type, delivery_ts, outcome_type, condition_at_discharge, discharge_ts,case when visit_type = 1 then 'IN' else 'OUT' end as visit_type,visit_reason, visit_rate_category_nm, visit_ip_nbr,admission_method, cancel_reason, ward_nm, referral_source
,(case when pm.first_visit_date = date(fpv.checkin_ts) then 1 else 0 end) as first_visit_flg
, round(datediff(fpv.checkin_ts,pm.patient_birth_dt)/365,2) age_at_visit
from healthscore_dw.fact_patient_visits fpv
join healthscore_dw.pt_patient_master_view pm
on fpv.patient_key = pm.patient_key
join healthscore_dw.pt_hospital_master_view hm
on fpv.visit_hospital_key = hm.hospital_key 
;

DROP VIEW IF EXISTS healthscore_dw.pt_visit_bill_items_view;
CREATE VIEW healthscore_dw.pt_visit_bill_items_view AS
SELECT  patient_visitbillitem_key,patient_visitbill_key,fvbi.bill_item_key,vbi_date_key AS transaction_date_key,vbi_time_key AS transaction_time_key,vbi_created_staff_key,bill_item_qty,bill_item_returned_qty,bill_item_unit_amt,bill_item_total_concession_amt,bill_item_final_amt,
bill_item_receipt_cd,bill_item_total_tax,pharmacy_item_flg,vbi_created_ts,vbv.patient_key,vbv.visit_hospital_key,vbv.patient_visit_key,visit_bill_cd,visit_bill_from_ts,visit_bill_to_ts,visit_bill_comments,visit_bill_created_ts,
case when bill_item_cd = 'PYR' then bill_item_final_amt else 0 end as payment_amt,
case when bill_item_cd = 'PRF' then bill_item_final_amt else 0 end as refund_amt,
case when bill_item_cd = 'WAI' then bill_item_final_amt else 0 end as waived_amt,
case when bill_item_receipt_cd is null then bill_item_final_amt else 0 end as bill_amt,
payment_method_desc,
(case when hospital_cd in ('PTBSK','PTGB') then 0.55 when hospital_cd='PTML' then 0.5 else 1 end) * bill_item_final_amt as recognizable_revenue_amt
FROM healthscore_dw.fact_patient_visitbillitems fvbi
JOIN healthscore_dw.fact_patient_visitbills vbv ON vbv.patient_visitbill_key = fvbi.patient_visitbill_key
JOIN healthscore_dw.pt_patient_visit_view pvv ON pvv.patient_visit_key = vbv.patient_visit_key
JOIN healthscore_dw.pt_bill_items_master_view bim ON fvbi.bill_item_key = bim.bill_item_key
join healthscore_dw.pt_hospital_master_view hm
on pvv.hospital_key = hm.hospital_key 
WHERE fvbi.active_flg = 1;
​ 
​
DROP VIEW IF EXISTS healthscore_dw.pt_patient_diagnosis_view;
CREATE VIEW healthscore_dw.pt_patient_diagnosis_view AS
SELECT fci.patient_key,patient_visit_key,clinical_info_desc as diagnosis_nm,effective_from_ts,effective_to_ts
FROM healthscore_dw.fact_patient_clinical_info fci
join healthscore_dw.map_patient_hospital mph
on mph.patient_key = fci.patient_key
join healthscore_dw.pt_hospital_master_view  hm
on mph.hospital_key = hm.hospital_key
WHERE clinical_info_type_cd='diagnosis';


DROP VIEW IF EXISTS healthscore_dw.pt_consultant_appt_view;
CREATE VIEW healthscore_dw.pt_consultant_appt_view AS
SELECT consultant_schedule_key,cas.hospital_key, cas.consulting_staff_key, cas.schedule_date_key, cas.schedule_start_time_key, cas.schedule_end_time_key ,cas.consultant_schedule_id,
 duration, active_flg,  timeslot_usage_limit,  timeslot_used_cnt 
FROM healthscore_dw.fact_consultant_appointment_schedule cas
join healthscore_dw.pt_hospital_master_view  hm
on cas.hospital_key = hm.hospital_key 
join (select max(consultant_schedule_id) as consultant_schedule_id, consulting_staff_key,hospital_key,schedule_date_key, schedule_start_time_key,schedule_end_time_key
from healthscore_dw.fact_consultant_appointment_schedule
GROUP BY  hospital_key, consulting_staff_key, schedule_date_key, schedule_start_time_key, schedule_end_time_key) max_sched
on max_sched.consultant_schedule_id=cas.consultant_schedule_id 
and cas.hospital_key = max_sched.hospital_key
and cas.consulting_staff_key = max_sched.consulting_staff_key
and cas.schedule_date_key = max_sched.schedule_date_key
and cas.schedule_start_time_key = max_sched.schedule_start_time_key
and cas.schedule_end_time_key = max_sched.schedule_end_time_key 
 ;

DROP VIEW IF EXISTS healthscore_dw.pt_patient_appt_view;
CREATE VIEW healthscore_dw.pt_patient_appt_view AS
SELECT patient_key, consultant_schedule_key, fpa.hospital_key, patient_appointment_id , schedule_status, visit_type,
 contact_type, appointment_status ,  appointment_created_ts, appointment_modified_ts, patient_visit_key 
FROM healthscore_dw.fact_patient_appointments fpa
join healthscore_dw.pt_hospital_master_view  hm
on fpa.hospital_key = hm.hospital_key ;
 

-- CREATE USER pt_db_viewer@localhost IDENTIFIED BY <PWD>;
GRANT SELECT ON `healthscore_dw`.`pt_bill_items_master_view` TO 'pt_db_viewer'@'localhost' ; 
GRANT SELECT ON `healthscore_dw`.`pt_hospital_master_view` TO 'pt_db_viewer'@'localhost' ; 
GRANT SELECT ON `healthscore_dw`.`pt_patient_master_view` TO 'pt_db_viewer'@'localhost' ; 
GRANT SELECT ON `healthscore_dw`.`pt_patient_medications_view` TO 'pt_db_viewer'@'localhost' ; 
GRANT SELECT ON `healthscore_dw`.`pt_patient_assessments_view` TO 'pt_db_viewer'@'localhost' ; 
GRANT SELECT ON `healthscore_dw`.`pt_hospital_staff_master_view` TO 'pt_db_viewer'@'localhost' ; 
GRANT SELECT ON `healthscore_dw`.`pt_patient_visit_view` TO 'pt_db_viewer'@'localhost' ;   
GRANT SELECT ON `healthscore_dw`.`pt_patient_diagnosis_view` TO 'pt_db_viewer'@'localhost' ;  
GRANT SELECT ON `healthscore_dw`.`pt_visit_bill_items_view` TO 'pt_db_viewer'@'localhost' ; 
GRANT SELECT ON `healthscore_dw`.`pt_consultant_appt_view` TO 'pt_db_viewer'@'localhost' ; 
GRANT SELECT ON `healthscore_dw`.`pt_patient_appt_view` TO 'pt_db_viewer'@'localhost' ; 