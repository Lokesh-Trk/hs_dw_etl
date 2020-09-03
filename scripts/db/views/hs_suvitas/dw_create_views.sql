DROP VIEW IF EXISTS healthscore_dw.suvitas_bill_items_master_view;
CREATE VIEW healthscore_dw.suvitas_bill_items_master_view
as select dbi.hospital_key, bill_item_type,bill_item_category_cd,bill_item_category_nm,bill_item_category_desc,bill_item_cd,bill_item_nm,bill_item_amt,transaction_type_cd,pkg_effective_from_ts,pkg_effective_to_ts
,renewal_item_flg,effective_from_ts,effective_to_ts,rate_category_nm,dbi.active_flg
 from healthscore_dw.dim_bill_items dbi
join healthscore_dw.dim_hospital dh
on dbi.hospital_key = dh.hospital_key
where hospital_cd in ('SUVH','SUVB','SUVV')
;
 
DROP VIEW IF EXISTS healthscore_dw.suvitas_hospital_master_view;
CREATE VIEW healthscore_dw.suvitas_hospital_master_view
as   SELECT hospital_key, hospital_cd, hospital_nm, hospital_addr_line1, hospital_addr_line2, hospital_addr_city_nm, hospital_addr_state_nm, hospital_addr_country_nm, hospital_addr_zipcode, hospital_phone_num, hospital_email_addr, hospital_logo 
FROM healthscore_dw.dim_hospital dh 
where hospital_cd in ('SUVH','SUVB','SUVV')
;

DROP VIEW IF EXISTS healthscore_dw.suvitas_patient_master_view;
CREATE VIEW healthscore_dw.suvitas_patient_master_view as
SELECT mph.hospital_key,dp.patient_key,patient_unique_id,patient_nm,patient_first_nm,patient_middle_nm,patient_last_nm,patient_gender,patient_birth_dt,patient_death_ts,patient_mother_nm
,patient_father_nm,blood_group,contact_addr_city_nm,contact_addr_state_nm,contact_addr_country_nm,contact_addr_zipcode
 FROM healthscore_dw.dim_patient dp
join healthscore_dw.map_patient_hospital mph
on mph.patient_key = dp.patient_key
where mph.hospital_cd in ('SUVH','SUVB','SUVV');

DROP VIEW IF EXISTS healthscore_dw.suvitas_patient_visit_view;
CREATE VIEW healthscore_dw.suvitas_patient_visit_view as
select patient_visit_key,fpv.patient_key,fpv.visit_hospital_key as hospital_key,visit_date_key,visit_time_key,patient_visit_cd,visit_doctor_staff_key,primary_doctor_staff_key,reference_doctor_staff_key,checkin_ts,checkout_ts,checkout_type, delivery_ts, outcome_type, condition_at_discharge, discharge_ts,case when visit_type = 1 then 'IN' else 'OUT' end as visit_type,visit_reason, visit_rate_category_nm, visit_ip_nbr,admission_method, cancel_reason, ward_nm, referral_source
from healthscore_dw.fact_patient_visits fpv
join healthscore_dw.suvitas_patient_master_view pm
on fpv.patient_key = pm.patient_key
join healthscore_dw.suvitas_hospital_master_view hm
on fpv.visit_hospital_key = hm.hospital_key;

DROP VIEW IF EXISTS healthscore_dw.suvitas_patient_medications_view;
CREATE VIEW healthscore_dw.suvitas_patient_medications_view as
SELECT patient_medication_key, pm.patient_key, pharma_product_ref_id, pharma_product_ref_display_txt, pharma_brand_nm, dosage, drug_form_ref_id, drug_form_ref_display_txt, frequency, comments, start_dt, end_dt, active_flg, prescribed_doctor_staff_key, prescribed_hospital_key, prescribed_ts, prescribed_patient_visit_key,  prescribed_date_key, prescribed_time_key
FROM healthscore_dw.fact_patient_medications fpm
join  healthscore_dw.suvitas_patient_master_view pm
on fpm.patient_key = pm.patient_key
join healthscore_dw.suvitas_hospital_master_view hm
on fpm.prescribed_hospital_key = hm.hospital_key;

DROP VIEW IF EXISTS healthscore_dw.suvitas_patient_assessments_view;
CREATE VIEW healthscore_dw.suvitas_patient_assessments_view as
SELECT patient_assmt_key,fpa.patient_key,visit_hospital_key as hospital_key,patient_visit_key,health_assessment_scale_desc,hospital_dept_nm,assessment_result_item_seq_no,assessment_result_item_ref_range_txt,assessment_result_item_display_txt,assessment_result_item_value,assessed_date_key,assessed_time_key,assessed_ts
FROM healthscore_dw.fact_patient_assessments fpa
join healthscore_dw.suvitas_patient_master_view pm
on fpa.patient_key = pm.patient_key
join healthscore_dw.suvitas_hospital_master_view hm
on fpa.visit_hospital_key = hm.hospital_key
;

DROP VIEW IF EXISTS healthscore_dw.suvitas_hospital_staff_master_view;
CREATE VIEW healthscore_dw.suvitas_hospital_staff_master_view as
select ds.hospital_key, ds.hospital_staff_cd, ds.hospital_staff_full_nm,hospital_staff_user_nm,hospital_staff_gender,hospital_staff_type_nm,hospital_staff_kmc_reg_no,hospital_staff_dept_nm
from 
  healthscore_dw.dim_staff ds
  join healthscore_dw.dim_hospital dh
  on ds.hospital_key = dh.hospital_key
  where hospital_cd in ('SUVH','SUVB','SUVV');