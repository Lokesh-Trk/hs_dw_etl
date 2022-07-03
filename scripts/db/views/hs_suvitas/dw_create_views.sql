DROP VIEW IF EXISTS healthscore_dw.suvitas_hospital_master_view;
CREATE VIEW healthscore_dw.suvitas_hospital_master_view
as   SELECT hospital_key, hospital_cd, hospital_nm, hospital_addr_line1, hospital_addr_line2, hospital_addr_city_nm, hospital_addr_state_nm, hospital_addr_country_nm, hospital_addr_zipcode, hospital_phone_num, hospital_email_addr, hospital_logo 
FROM healthscore_dw.dim_hospital dh 
where hospital_cd in ('SUVH','SUVB','SUVV','HCAH')
;

DROP VIEW IF EXISTS healthscore_dw.suvitas_bill_items_master_view;
CREATE VIEW healthscore_dw.suvitas_bill_items_master_view
as select dbi.hospital_key, bill_item_type,bill_item_category_cd,bill_item_category_nm,bill_item_category_desc,bill_item_cd,bill_item_nm,bill_item_amt,transaction_type_cd,pkg_effective_from_ts,pkg_effective_to_ts
,renewal_item_flg,effective_from_ts,effective_to_ts,rate_category_nm,dbi.active_flg
 from healthscore_dw.dim_bill_items dbi
join healthscore_dw.suvitas_hospital_master_view dh
on dbi.hospital_key = dh.hospital_key 
;
 


DROP VIEW IF EXISTS healthscore_dw.suvitas_patient_master_view;
CREATE VIEW healthscore_dw.suvitas_patient_master_view as
SELECT mph.hospital_key,dp.patient_key,patient_unique_id,patient_nm,patient_first_nm,patient_middle_nm,patient_last_nm,patient_gender,patient_birth_dt,patient_death_ts,patient_mother_nm
,patient_father_nm,blood_group,contact_addr_city_nm,contact_addr_state_nm,contact_addr_country_nm,contact_addr_zipcode, date(mph.hospital_registration_ts) as first_visit_date, mph.color_category_nm as patient_category, patient_socio_economic_status,patient_occupation_status,patient_marital_status,patient_religion,patient_spouse_occupation
 FROM healthscore_dw.dim_patient dp
join healthscore_dw.map_patient_hospital mph
on mph.patient_key = dp.patient_key
join healthscore_dw.suvitas_hospital_master_view dh
on mph.hospital_key = dh.hospital_key ;

DROP VIEW IF EXISTS healthscore_dw.suvitas_patient_medications_view;
CREATE VIEW healthscore_dw.suvitas_patient_medications_view as
SELECT patient_medication_key, pm.patient_key, pharma_product_ref_id, pharma_product_ref_display_txt, pharma_brand_nm, dosage, drug_form_ref_id, drug_form_ref_display_txt, frequency, comments, start_dt, end_dt, active_flg, prescribed_doctor_staff_key, prescribed_hospital_key, prescribed_ts, prescribed_patient_visit_key,  prescribed_date_key, prescribed_time_key
FROM healthscore_dw.fact_patient_medications fpm
join  healthscore_dw.suvitas_patient_master_view pm
on fpm.patient_key = pm.patient_key
join healthscore_dw.suvitas_hospital_master_view hm
on fpm.prescribed_hospital_key = hm.hospital_key;
​
DROP VIEW IF EXISTS healthscore_dw.suvitas_patient_assessments_view;
CREATE VIEW healthscore_dw.suvitas_patient_assessments_view as
SELECT fpa.patient_assmt_key,fpa.patient_key,visit_hospital_key as hospital_key,patient_visit_key,assessed_date_key,assessed_time_key,assessed_ts,assessment_scale_desc,hospital_dept_nm,
patient_assessment_id ,patient_assessment_result_id,assessment_result_item_master_id,result_item_display_txt,result_item_value,result_item_row_no,result_item_column_no,result_item_ref_range_txt,result_item_min_value,result_item_max_value
FROM healthscore_dw.fact_patient_assessments fpa
join healthscore_dw.fact_patient_assessment_results fpar
on fpa.patient_assmt_key=fpar.patient_assmt_key
join healthscore_dw.suvitas_patient_master_view pm
on fpa.patient_key = pm.patient_key
join healthscore_dw.suvitas_hospital_master_view hm
on fpa.visit_hospital_key = hm.hospital_key
where fpar.active_flg = 1 and fpa.active_flg = 1
;

DROP VIEW IF EXISTS healthscore_dw.suvitas_patient_admission_evaluations_view;
CREATE VIEW healthscore_dw.suvitas_patient_admission_evaluations_view as
SELECT fpa.patient_assmt_key,fpa.patient_key,visit_hospital_key as hospital_key,fpa.patient_visit_key,assessed_date_key,assessed_time_key,assessed_ts,fpa.assessment_scale_master_id, assessment_scale_desc,hospital_dept_nm,
patient_assessment_id ,patient_assessment_result_id,assessment_result_item_master_id,result_item_display_txt,fnStripTags(result_item_value) as result_item_value,result_item_row_no,result_item_column_no,result_item_ref_range_txt,result_item_min_value,result_item_max_value
FROM healthscore_dw.fact_patient_assessments fpa
join healthscore_dw.fact_patient_assessment_results fpar
on fpa.patient_assmt_key=fpar.patient_assmt_key
join healthscore_dw.suvitas_patient_master_view pm
on fpa.patient_key = pm.patient_key
join healthscore_dw.suvitas_hospital_master_view hm
on fpa.visit_hospital_key = hm.hospital_key
join (select distinct patient_assmt_key 
from healthscore_dw.fact_patient_assessment_results fpar
where result_item_display_txt like 'Assessment Timeline%'
and  result_item_value='Admission' and active_flg = 1  ) admission_assmt
on admission_assmt.patient_assmt_key = fpa.patient_assmt_key
;

DROP VIEW IF EXISTS healthscore_dw.suvitas_patient_discharge_evaluations_view;
CREATE VIEW healthscore_dw.suvitas_patient_discharge_evaluations_view as
SELECT fpa.patient_assmt_key,fpa.patient_key,visit_hospital_key as hospital_key,patient_visit_key,assessed_date_key,assessed_time_key,assessed_ts,assessment_scale_master_id,assessment_scale_desc,hospital_dept_nm,
patient_assessment_id ,patient_assessment_result_id,assessment_result_item_master_id, result_item_display_txt,fnStripTags(result_item_value) as result_item_value,result_item_row_no,result_item_column_no,result_item_ref_range_txt,result_item_min_value,result_item_max_value
FROM healthscore_dw.fact_patient_assessments fpa
join healthscore_dw.fact_patient_assessment_results fpar
on fpa.patient_assmt_key=fpar.patient_assmt_key
join healthscore_dw.suvitas_patient_master_view pm
on fpa.patient_key = pm.patient_key
join healthscore_dw.suvitas_hospital_master_view hm
on fpa.visit_hospital_key = hm.hospital_key
join (select distinct patient_assmt_key 
from healthscore_dw.fact_patient_assessment_results fpar
where result_item_display_txt like 'Assessment Timeline%'
and  result_item_value='Discharge' and active_flg = 1  ) discharge_assmt
on discharge_assmt.patient_assmt_key = fpa.patient_assmt_key
;
​
DROP VIEW IF EXISTS healthscore_dw.suvitas_hospital_staff_master_view;
CREATE VIEW healthscore_dw.suvitas_hospital_staff_master_view as
select ds.staff_key, ds.hospital_key, ds.hospital_staff_cd, ds.hospital_staff_full_nm,hospital_staff_user_nm,hospital_staff_gender,hospital_staff_type_nm,hospital_staff_kmc_reg_no,hospital_staff_dept_nm,ds.active_flg
from 
  healthscore_dw.dim_staff ds
 join healthscore_dw.suvitas_hospital_master_view dh
  on ds.hospital_key = dh.hospital_key;

DROP view if exists healthscore_dw.suvitas_active_visits_view;
CREATE VIEW healthscore_dw.suvitas_active_visits_view AS
SELECT as_of_date_key,patient_visit_key,patient_key,fav.hospital_key,daily_rate,billed_days,ward_nm,admitted_days,total_paid_amt,total_refund_amt,total_waived_amt,total_billed_amt,unbilled_consumables_amt,unbilled_canteen_amt,coalesce(previous_bill_balance_amt,0) as previous_bill_balance_amt,coalesce(current_balance_amt,0) as current_balance_amt, (coalesce(total_paid_amt,0)-coalesce(total_refund_amt,0)-coalesce(previous_bill_balance_amt,0)) as total_payment_received, (coalesce(admitted_days,0)-coalesce(billed_days,0)) as unbilled_days, ((coalesce(admitted_days,0)-coalesce(billed_days,0)) * coalesce(daily_rate,0)) as unbilled_care_package_amt,
case when ((coalesce(total_paid_amt,0)-coalesce(previous_bill_balance_amt,0)) - (coalesce(total_billed_amt,0) + ((coalesce(admitted_days,0)-coalesce(billed_days,0)) * coalesce(daily_rate,0))  + coalesce(unbilled_consumables_amt,0)+coalesce(unbilled_canteen_amt,0))) > 0 then ((coalesce(total_paid_amt,0)-coalesce(previous_bill_balance_amt,0)) - (coalesce(total_billed_amt,0) + ((coalesce(admitted_days,0)-coalesce(billed_days,0)) * coalesce(daily_rate,0))  + coalesce(unbilled_consumables_amt,0)+coalesce(unbilled_canteen_amt,0))) else 0 end as hospital_due_amt,
case when ((coalesce(total_paid_amt,0)-coalesce(previous_bill_balance_amt,0)) - (coalesce(total_billed_amt,0) + ((coalesce(admitted_days,0)-coalesce(billed_days,0)) * coalesce(daily_rate,0))  + coalesce(unbilled_consumables_amt,0)+coalesce(unbilled_canteen_amt,0))) < 0 then ((coalesce(total_paid_amt,0)-coalesce(previous_bill_balance_amt,0)) - (coalesce(total_billed_amt,0) + ((coalesce(admitted_days,0)-coalesce(billed_days,0)) * coalesce(daily_rate,0))  + coalesce(unbilled_consumables_amt,0)+coalesce(unbilled_canteen_amt,0))) * -1 else 0 end as patient_due_amt,
critical_flg
FROM healthscore_dw.fact_active_visits fav
join healthscore_dw.suvitas_hospital_master_view hm ON fav.hospital_key = hm.hospital_key;

DROP VIEW IF EXISTS healthscore_dw.suvitas_patient_visit_view;
CREATE VIEW healthscore_dw.suvitas_patient_visit_view as
select fpv.patient_visit_key,fpv.patient_key,fpv.visit_hospital_key as hospital_key,visit_date_key,visit_time_key,patient_visit_cd,visit_doctor_staff_key,primary_ext_doctor_staff_key as primary_ext_doctor_staff_key,reference_ext_doctor_staff_key as reference_ext_doctor_staff_key,checkin_ts,checkout_ts,checkout_type, delivery_ts, outcome_type, condition_at_discharge, discharge_ts,case when visit_type = 1 then 'IN' else 'OUT' end as visit_type,visit_reason, visit_rate_category_nm, visit_ip_nbr,admission_method, cancel_reason, ward_nm, referral_source
,(case when pm.first_visit_date = date(fpv.checkin_ts) then 1 else 0 end) as first_visit_flg
, round(datediff(fpv.checkin_ts,pm.patient_birth_dt)/365,2) age_at_visit
, fpva.visit_diagnosis, fpva.prev_hospital_duration_of_stay,fpva.spl_req , avg_daily_rate
from healthscore_dw.fact_patient_visits fpv
join healthscore_dw.suvitas_patient_master_view pm
on fpv.patient_key = pm.patient_key
join healthscore_dw.suvitas_hospital_master_view hm
on fpv.visit_hospital_key = hm.hospital_key
left join healthscore_dw.fact_patient_visit_admission fpva 
on fpv.patient_visit_key = fpva.patient_visit_key  
left join (
  select patient_visit_key, round(avg(ifnull(daily_rate,0)),2) as avg_daily_rate from healthscore_dw.suvitas_active_visits_view group by patient_visit_key
) pv_dly_rate
on fpv.patient_visit_key=pv_dly_rate.patient_visit_key
;
DROP VIEW IF EXISTS healthscore_dw.suvitas_patient_careplan_instructions_view;
CREATE VIEW healthscore_dw.suvitas_patient_careplan_instructions_view AS
SELECT fcpi.patient_careplan_key,fcp.patient_key,fcp.visit_hospital_key hospital_key,careplan_status_nm,careplan_summary,careplan_instruction_desc,careplan_instruction_type_nm,careplan_instruction_dept_nm,careplan_ins_status_nm,freq_num,freq_mode_nm,ins_started_ts,ins_ended_ts,comments,bill_item_key,patient_medication_key,stopped_flg,ins_created_date_key,ins_created_time_key,ins_created_ts,fcpi.active_flg
FROM healthscore_dw.fact_patient_careplan_instructions fcpi
JOIN healthscore_dw.fact_patient_careplans fcp 
ON fcp.patient_careplan_key = fcpi.patient_careplan_key
JOIN healthscore_dw.dim_careplan_instruction_master fcim 
ON fcim.careplan_instruction_master_key = fcpi.careplan_instruction_master_key
JOIN healthscore_dw.suvitas_hospital_master_view hm ON fcp.visit_hospital_key = hm.hospital_key
where fcpi.active_flg=1 and fcp.active_flg=1;
​
DROP VIEW IF EXISTS healthscore_dw.suvitas_bill_items_master_view;
CREATE VIEW healthscore_dw.suvitas_bill_items_master_view
as select dbi.hospital_key, bill_item_key,bill_item_type,bill_item_category_cd,bill_item_category_nm,bill_item_category_desc,bill_item_cd,bill_item_nm,bill_item_amt,transaction_type_cd,
effective_from_ts,effective_to_ts,rate_category_nm,dbi.active_flg
 from healthscore_dw.dim_bill_items dbi
join healthscore_dw.suvitas_hospital_master_view dh
on dbi.hospital_key = dh.hospital_key
;
​
DROP VIEW IF EXISTS healthscore_dw.suvitas_vist_bill_items_view;
CREATE VIEW healthscore_dw.suvitas_vist_bill_items_view AS
SELECT  patient_visitbillitem_key,fvbi.bill_item_key,vbi_date_key AS transaction_date_key,vbi_time_key AS transaction_time_key,vbi_created_staff_key,bill_item_qty,bill_item_returned_qty,bill_item_unit_amt,bill_item_total_concession_amt,bill_item_final_amt,
bill_item_receipt_cd,bill_item_total_tax,pharmacy_item_flg,vbi_created_ts,vbv.patient_key,vbv.visit_hospital_key,vbv.patient_visit_key,visit_bill_cd,visit_bill_from_ts,visit_bill_to_ts,visit_bill_comments,visit_bill_created_ts,
case when bill_item_cd = 'PYR' then bill_item_final_amt else 0 end as payment_amt,
case when bill_item_cd = 'PYO' then bill_item_final_amt else 0 end as prior_outstd_amt,
case when bill_item_cd = 'PRF' then bill_item_final_amt else 0 end as refund_amt,
case when bill_item_cd = 'WAI' then bill_item_final_amt else 0 end as waived_amt,
case when bill_item_receipt_cd is null and bill_item_cd <> 'PYO' then bill_item_final_amt else 0 end as bill_amt,
payment_method_desc,payment_comments,non_editable_comments,payment_last_cd,payment_approval_cd
FROM healthscore_dw.fact_patient_visitbillitems fvbi
JOIN healthscore_dw.fact_patient_visitbills vbv ON vbv.patient_visitbill_key = fvbi.patient_visitbill_key
JOIN healthscore_dw.suvitas_patient_visit_view pvv ON pvv.patient_visit_key = vbv.patient_visit_key
JOIN healthscore_dw.suvitas_bill_items_master_view bim ON fvbi.bill_item_key = bim.bill_item_key
WHERE fvbi.active_flg = 1
;
​
DROP view if exists healthscore_dw.suvitas_hospital_daily_statistics_view;
CREATE VIEW healthscore_dw.suvitas_hospital_daily_statistics_view AS
SELECT as_of_date as transaction_date_key,fhds.hospital_key,in_patient_cnt,out_patient_cnt,in_patient_admission_cnt,in_patient_checkout_cnt,out_patient_checkout_cnt,in_patient_avg_stay
FROM healthscore_dw.fact_hospital_daily_statistics fhds 
join healthscore_dw.suvitas_hospital_master_view hm ON fhds.hospital_key = hm.hospital_key;
​
DROP VIEW IF EXISTS healthscore_dw.suvitas_patient_diagnosis_view;
CREATE VIEW healthscore_dw.suvitas_patient_diagnosis_view AS
SELECT fci.patient_key,patient_visit_key,clinical_info_desc as diagnosis_nm,effective_from_ts,effective_to_ts
FROM healthscore_dw.fact_patient_clinical_info fci
join healthscore_dw.map_patient_hospital mph
on mph.patient_key = fci.patient_key
join healthscore_dw.suvitas_hospital_master_view  hm
on mph.hospital_key = hm.hospital_key
WHERE clinical_info_type_cd='diagnosis';

DROP VIEW IF EXISTS healthscore_dw.suvitas_external_hospital_staff_view;
CREATE VIEW healthscore_dw.suvitas_external_hospital_staff_view AS
select external_hospital_staff_key,ehs.hospital_key,external_hospital_nm,external_doctor_nm, concat(external_doctor_nm,' - ',external_hospital_nm) as external_doctor_hospital_names
, external_doctor_dept_nm, ehs.active_flg
from healthscore_dw.dim_external_hospital_staff ehs
join healthscore_dw.suvitas_hospital_master_view  hm
on ehs.hospital_key = hm.hospital_key;

-- we need latest available note for each patient visit 
DROP VIEW IF EXISTS healthscore_dw.suvitas_patient_visit_timeline_notes_view;
CREATE VIEW healthscore_dw.suvitas_patient_visit_timeline_notes_view AS
select 
ptl.patient_key,ptl.patient_visit_key,sm.hospital_key, sm.hospital_staff_dept_nm,
fnStripTags(group_concat(case when (timeline_info_hashtag_category  like '%#Baseline%' or timeline_info_hashtag_category like '%#InitialAssessment%') 
then  replace(concat(ptl.timeline_info_created_ts,': ',timeline_info_desc),'#Baseline','') end ORDER BY ptl.timeline_info_created_ts DESC SEPARATOR '\n'))  as baseline_note,
fnStripTags(group_concat(case when timeline_info_hashtag_category  like '%#ReviewNote%'  
then  replace(concat(ptl.timeline_info_created_ts,': ',timeline_info_desc),'#ReviewNote','') end ORDER BY ptl.timeline_info_created_ts DESC SEPARATOR '\n'))  as review_note,
fnStripTags(group_concat(case when timeline_info_hashtag_category  like '%#MedicalStatus%'  and ptl.timeline_info_created_ts = latest_note_ts.medical_status_latest_ts
then replace(concat(ptl.timeline_info_created_ts,': ',timeline_info_desc),'#MedicalStatus','') end ORDER BY ptl.timeline_info_created_ts DESC SEPARATOR '\n'))  as latest_medical_status,
fnStripTags(group_concat(case when timeline_info_hashtag_category  like '%#MedicalStatus%'  
then replace(concat(ptl.timeline_info_created_ts,': ',timeline_info_desc),'#MedicalStatus','') end ORDER BY ptl.timeline_info_created_ts DESC SEPARATOR '\n')) as medical_status,
fnStripTags(group_concat(case when timeline_info_hashtag_category  like '%#DoctorUpdate%' 
then replace(concat(ptl.timeline_info_created_ts,': ',timeline_info_desc),'#DoctorUpdate','') end ORDER BY ptl.timeline_info_created_ts DESC SEPARATOR '\n')) as doctorupdate_note,
fnStripTags(group_concat(case when timeline_info_hashtag_category  like '%#ResidentRemarks%'  
then replace(concat(ptl.timeline_info_created_ts,': ',timeline_info_desc),'#ResidentRemarks','') end ORDER BY ptl.timeline_info_created_ts DESC SEPARATOR '\n')) as resident_remarks,
fnStripTags(group_concat(case when timeline_info_hashtag_category  like '%#OpsNote%' 
then replace(concat(ptl.timeline_info_created_ts,': ',timeline_info_desc),'#OpsNote','') end ORDER BY ptl.timeline_info_created_ts DESC SEPARATOR '\n')) as ops_note,
fnStripTags(group_concat(case when timeline_info_hashtag_category  like '%#TentativeDOD(dd.mm.yy)%'  
then replace(concat(ptl.timeline_info_created_ts,': ',timeline_info_desc),'#TentativeDOD(dd.mm.yy)','') end ORDER BY ptl.timeline_info_created_ts DESC SEPARATOR '\n')) as tentative_dod,
fnStripTags(group_concat(case when timeline_info_hashtag_category  = 'Milestone Achieved'
then replace(concat(ptl.timeline_info_created_ts,': ',timeline_info_desc),'Milestone Achieved','') end ORDER BY ptl.timeline_info_created_ts DESC SEPARATOR '\n')) as milestone_achieved
from  healthscore_dw.fact_patient_timeline_info ptl
join healthscore_dw.suvitas_hospital_staff_master_view sm
on ptl.created_staff_key = sm.staff_key
join healthscore_dw.suvitas_hospital_master_view  hm
on sm.hospital_key = hm.hospital_key
left join
(
select patient_key,patient_visit_key, sm.hospital_key, sm.hospital_staff_dept_nm,
max(case when  timeline_info_hashtag_category like   '%#MedicalStatus%'  then timeline_info_created_ts else null end) as medical_status_latest_ts
 from  healthscore_dw.fact_patient_timeline_info ptl
 join healthscore_dw.suvitas_hospital_staff_master_view sm
on ptl.created_staff_key = sm.staff_key
join healthscore_dw.suvitas_hospital_master_view  hm
on sm.hospital_key = hm.hospital_key
 where timeline_info_type_cd = 'note'  
 and ptl.active_flg=1
group by patient_key,patient_visit_key, sm.hospital_key, sm.hospital_staff_dept_nm
) latest_note_ts
on ptl.patient_visit_key = latest_note_ts.patient_visit_key
and sm.hospital_staff_dept_nm = latest_note_ts.hospital_staff_dept_nm
where  
(timeline_info_hashtag_category like '%#Baseline%' or timeline_info_hashtag_category like '%#InitialAssessment%' or 
timeline_info_hashtag_category like '%#ReviewNote%' or timeline_info_hashtag_category like '%#MedicalStatus%' or 
timeline_info_hashtag_category like '%#ResidentRemarks%' or timeline_info_hashtag_category like '%#OpsNote%' or 
timeline_info_hashtag_category like   '%#DoctorUpdate%' or  timeline_info_hashtag_category like  '%#TentativeDOD(dd.mm.yy)%'
or timeline_info_hashtag_category  = 'Milestone Achieved')
and ptl.active_flg=1  
group by ptl.patient_key,ptl.patient_visit_key,sm.hospital_key, sm.hospital_staff_dept_nm
 ;


DROP VIEW IF EXISTS healthscore_dw.suvitas_patient_careplan_instructions_summary_view;
CREATE VIEW healthscore_dw.suvitas_patient_careplan_instructions_summary_view AS
SELECT fcpi.patient_careplan_key,fcp.patient_key,
fcp.visit_hospital_key hospital_key,created_visit_key as patient_visit_key,
careplan_status_nm,careplan_summary, careplan_instruction_dept_nm,
group_concat(ins_created_ts,": ",careplan_instruction_desc SEPARATOR '\n')  as careplan_instructions
,ptl.milestone_achieved, ptl.medical_status
FROM healthscore_dw.fact_patient_careplan_instructions fcpi
JOIN healthscore_dw.fact_patient_careplans fcp 
ON fcp.patient_careplan_key = fcpi.patient_careplan_key
JOIN healthscore_dw.dim_careplan_instruction_master fcim 
ON fcim.careplan_instruction_master_key = fcpi.careplan_instruction_master_key
JOIN healthscore_dw.suvitas_hospital_master_view hm ON fcp.visit_hospital_key = hm.hospital_key
LEFT JOIN healthscore_dw.suvitas_patient_visit_timeline_notes_view ptl
ON created_visit_key = ptl.patient_visit_key
and careplan_instruction_dept_nm=ptl.hospital_staff_dept_nm
where fcpi.active_flg=1 and fcp.active_flg=1
group by  fcpi.patient_careplan_key,fcp.patient_key,
fcp.visit_hospital_key ,created_visit_key ,
careplan_status_nm,careplan_summary, careplan_instruction_dept_nm;


DROP VIEW IF EXISTS healthscore_dw.suvitas_product_master_view;
CREATE VIEW healthscore_dw.suvitas_product_master_view
as select dbi.hospital_key, product_key, product_id, product_cd, product_nm, product_generic_nm, 
product_hsn_cd, product_schedule_type_cd, product_brand_nm, product_category_nm, tax_type_nm, tax_value_in_per
 from healthscore_dw.dim_product dbi
join healthscore_dw.suvitas_hospital_master_view dh
on dbi.hospital_key = dh.hospital_key 
;

DROP VIEW IF EXISTS healthscore_dw.suvitas_product_batch_master_view;
CREATE VIEW healthscore_dw.suvitas_product_batch_master_view
as  
SELECT product_batch_key, dbi.hospital_key, product_key, stock_batch_no, mrp, selling_price, expiry_date_key, 
created_date_key from healthscore_dw.dim_product_batch dbi
join healthscore_dw.suvitas_hospital_master_view dh
on dbi.hospital_key = dh.hospital_key 
;

DROP VIEW IF EXISTS healthscore_dw.suvitas_store_master_view;
CREATE VIEW healthscore_dw.suvitas_store_master_view
as  
SELECT  
store_key, dbi.hospital_key, store_id, store_cd, store_nm, main_store_flg, active_flg, allow_direct_billing_flg
FROM `healthscore_dw`.`dim_store` dbi
join healthscore_dw.suvitas_hospital_master_view dh
on dbi.hospital_key = dh.hospital_key 
;

DROP VIEW IF EXISTS healthscore_dw.suvitas_fact_stock_transactions_view;
CREATE VIEW healthscore_dw.suvitas_fact_stock_transactions_view
as  
SELECT 
stock_transaction_key, transaction_date_key, dbi.hospital_key, product_batch_key, store_key, stock_transaction_id, transaction_type_cd,
transaction_type_nm, adjustment_status_cd, transaction_qty , stock_transactions_comment
FROM `healthscore_dw`.`fact_daily_stock_transactions` dbi
join healthscore_dw.suvitas_hospital_master_view dh
on dbi.hospital_key = dh.hospital_key 
;


-- CREATE USER suvitas_db_viewer@localhost IDENTIFIED BY <PWD>;
GRANT SELECT ON healthscore_dw.suvitas_bill_items_master_view TO 'suvitas_db_viewer'@'localhost' ; 
GRANT SELECT ON healthscore_dw.suvitas_hospital_master_view TO 'suvitas_db_viewer'@'localhost' ; 
GRANT SELECT ON healthscore_dw.suvitas_patient_master_view TO 'suvitas_db_viewer'@'localhost' ; 
GRANT SELECT ON healthscore_dw.suvitas_patient_medications_view TO 'suvitas_db_viewer'@'localhost' ; 
GRANT SELECT ON healthscore_dw.suvitas_patient_assessments_view TO 'suvitas_db_viewer'@'localhost' ; 
GRANT SELECT ON healthscore_dw.suvitas_hospital_staff_master_view TO 'suvitas_db_viewer'@'localhost' ; 
GRANT SELECT ON healthscore_dw.suvitas_patient_visit_view TO 'suvitas_db_viewer'@'localhost' ; 
GRANT SELECT ON healthscore_dw.suvitas_hospital_daily_statistics_view TO 'suvitas_db_viewer'@'localhost' ; 
GRANT SELECT ON healthscore_dw.suvitas_active_visits_view TO 'suvitas_db_viewer'@'localhost' ; 
GRANT SELECT ON healthscore_dw.suvitas_patient_diagnosis_view TO 'suvitas_db_viewer'@'localhost' ; 
GRANT SELECT ON healthscore_dw.suvitas_patient_careplan_instructions_view TO 'suvitas_db_viewer'@'localhost' ; 
GRANT SELECT ON healthscore_dw.suvitas_vist_bill_items_view TO 'suvitas_db_viewer'@'localhost' ;
grant select on  healthscore_dw.suvitas_patient_diagnosis_view to suvitas_db_viewer@localhost;
grant select on  healthscore_dw.suvitas_external_hospital_staff_view to suvitas_db_viewer@localhost;
grant select on  healthscore_dw.suvitas_patient_visit_timeline_notes_view to suvitas_db_viewer@localhost;
grant select on healthscore_dw.suvitas_patient_careplan_instructions_summary_view to suvitas_db_viewer@localhost;
grant select on healthscore_dw.suvitas_patient_admission_evaluations_view to suvitas_db_viewer@localhost;
grant select on healthscore_dw.suvitas_patient_discharge_evaluations_view to suvitas_db_viewer@localhost;

grant select on healthscore_dw.suvitas_product_master_view to suvitas_db_viewer@localhost;
grant select on healthscore_dw.suvitas_product_batch_master_view to suvitas_db_viewer@localhost;
grant select on healthscore_dw.suvitas_store_master_view to suvitas_db_viewer@localhost;
grant select on healthscore_dw.suvitas_fact_stock_transactions_view to suvitas_db_viewer@localhost;