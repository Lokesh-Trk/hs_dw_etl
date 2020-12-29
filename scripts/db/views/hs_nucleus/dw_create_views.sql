DROP VIEW IF EXISTS healthscore_dw.nucleus_hospital_master_view;
CREATE VIEW healthscore_dw.nucleus_hospital_master_view
as   SELECT hospital_key, hospital_cd, hospital_nm, hospital_addr_line1, hospital_addr_line2, hospital_addr_city_nm, hospital_addr_state_nm, hospital_addr_country_nm, hospital_addr_zipcode, hospital_phone_num, hospital_email_addr, hospital_logo 
FROM healthscore_dw.dim_hospital dh 
where dh.source_cd ='hs_nucleus'
;

DROP VIEW IF EXISTS healthscore_dw.nucleus_patient_master_view;
CREATE VIEW healthscore_dw.nucleus_patient_master_view as
SELECT mph.hospital_key,dp.patient_key,patient_unique_id,patient_nm,patient_first_nm,patient_middle_nm,patient_last_nm,patient_gender,patient_birth_dt,patient_death_ts,patient_mother_nm
,patient_father_nm,blood_group,contact_addr_city_nm,contact_addr_state_nm,contact_addr_country_nm,contact_addr_zipcode, date(mph.hospital_registration_ts) as first_visit_date, mph.color_category_nm as patient_category
 FROM healthscore_dw.dim_patient dp
join healthscore_dw.map_patient_hospital mph
on mph.patient_key = dp.patient_key
join healthscore_dw.nucleus_hospital_master_view  hm
on mph.hospital_key = hm.hospital_key;

DROP VIEW IF EXISTS healthscore_dw.nucleus_patient_medications_view;
CREATE VIEW healthscore_dw.nucleus_patient_medications_view as
SELECT patient_medication_key, pm.patient_key, pharma_product_ref_id, pharma_product_ref_display_txt, pharma_brand_nm, dosage, drug_form_ref_id, drug_form_ref_display_txt, frequency, comments, start_dt, end_dt, active_flg, prescribed_doctor_staff_key, prescribed_hospital_key, prescribed_ts, prescribed_patient_visit_key,  prescribed_date_key, prescribed_time_key
FROM healthscore_dw.fact_patient_medications fpm
join  healthscore_dw.nucleus_patient_master_view pm
on fpm.patient_key = pm.patient_key
join healthscore_dw.nucleus_hospital_master_view hm
on fpm.prescribed_hospital_key = hm.hospital_key;

DROP VIEW IF EXISTS healthscore_dw.nucleus_patient_assessments_view;
CREATE VIEW healthscore_dw.nucleus_patient_assessments_view as
SELECT patient_assmt_key,fpa.patient_key,visit_hospital_key as hospital_key,patient_visit_key,health_assessment_scale_desc,hospital_dept_nm,assessment_result_item_seq_no,assessment_result_item_ref_range_txt,assessment_result_item_display_txt,assessment_result_item_value,assessed_date_key,assessed_time_key,assessed_ts
FROM healthscore_dw.fact_patient_assessments fpa
join healthscore_dw.nucleus_patient_master_view pm
on fpa.patient_key = pm.patient_key
join healthscore_dw.nucleus_hospital_master_view hm
on fpa.visit_hospital_key = hm.hospital_key
;

DROP VIEW IF EXISTS healthscore_dw.nucleus_hospital_staff_master_view;
CREATE VIEW healthscore_dw.nucleus_hospital_staff_master_view as
select ds.staff_key, ds.hospital_key, ds.hospital_staff_cd, ds.hospital_staff_full_nm,hospital_staff_user_nm,hospital_staff_gender,hospital_staff_type_nm,hospital_staff_kmc_reg_no,hospital_staff_dept_nm
from 
  healthscore_dw.dim_staff ds
  join healthscore_dw.nucleus_hospital_master_view hm
on ds.hospital_key = hm.hospital_key;

DROP VIEW IF EXISTS healthscore_dw.nucleus_patient_visit_view;
CREATE VIEW healthscore_dw.nucleus_patient_visit_view as
select fpv.patient_visit_key,fpv.patient_key,fpv.visit_hospital_key as hospital_key,visit_date_key,visit_time_key,patient_visit_cd,visit_doctor_staff_key,primary_doctor_staff_key,reference_doctor_staff_key,checkin_ts,checkout_ts,checkout_type, delivery_ts, outcome_type, condition_at_discharge, discharge_ts,case when visit_type = 1 then 'IN' else 'OUT' end as visit_type,visit_reason, visit_rate_category_nm, visit_ip_nbr,admission_method, cancel_reason, ward_nm, referral_source
,(case when pm.first_visit_date = date(fpv.checkin_ts) then 1 else 0 end) as first_visit_flg
, datediff(fpv.checkin_ts,pm.patient_birth_dt) age_at_visit
, fpva.visit_diagnosis, fpva.prev_hospital_duration_of_stay,fpva.spl_req 
from healthscore_dw.fact_patient_visits fpv
join healthscore_dw.nucleus_patient_master_view pm
on fpv.patient_key = pm.patient_key
join healthscore_dw.nucleus_hospital_master_view hm
on fpv.visit_hospital_key = hm.hospital_key
left join healthscore_dw.fact_patient_visit_admission fpva 
on fpv.patient_visit_key = fpva.patient_visit_key  ;

DROP VIEW IF EXISTS healthscore_dw.nucleus_patient_careplan_instructions_view;
CREATE VIEW healthscore_dw.nucleus_patient_careplan_instructions_view AS
SELECT fcpi.patient_careplan_key,fcpi.patient_careplan_instruction_key,fcpi.careplan_instruction_master_key,fcp.patient_key,fcp.visit_hospital_key hospital_key,careplan_status_nm,careplan_summary,careplan_instruction_desc,careplan_instruction_type_nm,careplan_instruction_dept_nm,careplan_ins_status_nm,freq_num,freq_mode_nm,ins_started_ts,ins_ended_ts,comments,bill_item_key,patient_medication_key,stopped_flg,ins_created_date_key,ins_created_time_key,ins_created_ts,fcpi.active_flg
FROM healthscore_dw.fact_patient_careplan_instructions fcpi
JOIN healthscore_dw.fact_patient_careplans fcp 
ON fcp.patient_careplan_key = fcpi.patient_careplan_key
JOIN healthscore_dw.dim_careplan_instruction_master fcim 
ON fcim.careplan_instruction_master_key = fcpi.careplan_instruction_master_key
JOIN healthscore_dw.nucleus_hospital_master_view hm ON fcp.visit_hospital_key = hm.hospital_key
where fcpi.active_flg=1 and fcp.active_flg=1;


DROP view if exists healthscore_dw.nucleus_hospital_daily_statistics_view;
CREATE VIEW healthscore_dw.nucleus_hospital_daily_statistics_view AS
SELECT as_of_date as transaction_date_key,fhds.hospital_key,in_patient_cnt,out_patient_cnt,in_patient_admission_cnt,in_patient_checkout_cnt,out_patient_checkout_cnt,in_patient_avg_stay
FROM healthscore_dw.fact_hospital_daily_statistics fhds 
join healthscore_dw.nucleus_hospital_master_view hm ON fhds.hospital_key = hm.hospital_key;

DROP VIEW IF EXISTS healthscore_dw.nucleus_obstetric_history_view;
CREATE VIEW healthscore_dw.nucleus_obstetric_history_view AS
SELECT patient_mother_obstetric_key, patient_key, moh.hospital_key, anamoly_scan_ts, doppler_scan_ts, other_scan_ts, anamoly_scan_desc, doppler_scan_desc, other_scan_desc, mother_age, blood_group_display_nm, gravidity_ct, parity_ct, abortion_ct, died_ct, living_children_ct, ectopic_ct, neonatal_death_ct, still_birth_ct, previous_lscs, gestation_type_nm, hiv_flg, hbsag_flg, vdrl_flg, anaemia_flg, pih_flg, gdm_flg, hypothyroid_flg, normal_anomaly_scan_flg, mg_sulphate_flg, lmp_dt, edd_dt, last_steroid_dose_dt, gravidity_details, parity_details, abortion_details, ectopic_details, living_children_details, died_details, neonatal_death_details, still_birth_details, other_medical_conditions, anaemia_medications, pih_medications, gdm_medications, hypothyroid_medications, hiv_medications, hbsag_medications, vdrl_medications, an_steroid_details, steroid_type, birth_place 
FROM healthscore_dw.dim_patient_mother_obstetric_history moh
join healthscore_dw.nucleus_hospital_master_view hm ON moh.hospital_key = hm.hospital_key;

 
DROP VIEW IF EXISTS healthscore_dw.nucleus_birth_history_view;
CREATE VIEW healthscore_dw.nucleus_birth_history_view AS
SELECT patient_birth_history_key, patient_key, bh.hospital_key, ext_birth_doctor_staff_key, birth_doctor_staff_key, birth_pediatrician_staff_key, birth_ext_pediatrician_staff_key, labour_presentation_type_nm, membrane_rupture_duration_in_hrs, liquor_quality_type, liquor_quantity_type, pv_exam_count, sepsis_risk_factors_nm, anesthesia_category_nm, delivery_mode_nm, oxytocin_flg, labour_onset_ts, labour_indication_details 
FROM healthscore_dw.dim_patient_birth_history bh
join healthscore_dw.nucleus_hospital_master_view hm ON bh.hospital_key = hm.hospital_key
 ;

DROP VIEW IF EXISTS healthscore_dw.nucleus_birth_exam_history_view;
CREATE VIEW healthscore_dw.nucleus_birth_exam_history_view AS
SELECT patient_birth_exam_key, patient_key, bh.hospital_key, time_of_cord_clamping, blood_gas_sample_type, hips_anomaly, cord_vessels_anomaly, femoral_pulses_anomaly, genitilia_anomaly, red_reflex_anomaly, back_spine_anomaly, extremities_anomaly, resusitation_desc, rs_desc, pa_desc, cvs_desc, cns_desc, congenital_anomalies_desc, comments, birth_diagnosis_nm, resusitation_type_nm, resusitation_duration_min, regular_hr_by_min, regular_resp_by_min, regular_hr_by_sec, regular_resp_by_sec, coalesce(apgar_1_min,0) as apgar_1_min, coalesce(apgar_5_min,0) as apgar_5_min,coalesce(apgar_10_min,0) as apgar_10_min, coalesce(hr_1_min,0) as hr_1_min,coalesce(hr_5_min,0) as hr_5_min,coalesce(hr_10_min,0) as hr_10_min, coalesce(resp_1_min,0) as resp_1_min, coalesce(resp_5_min,0) as resp_5_min, coalesce(resp_10_min,0) as resp_10_min, coalesce(muscle_1_min,0) as muscle_1_min, coalesce(muscle_5_min,0) as muscle_5_min, coalesce(muscle_10_min,0) as muscle_10_min, coalesce(reflex_1_min,0) as reflex_1_min, coalesce(reflex_5_min,0) as reflex_5_min, coalesce(reflex_10_min,0) as reflex_10_min, coalesce(color_1_min,0) as color_1_min, coalesce(color_5_min,0) as color_5_min, coalesce(color_10_min,0) as color_10_min, dysmorphic_features_flg, anal_patency_flg, ng_tube_flg, cleft_lip_flg, parent_consent_flg, baby_shown_to_parents_flg, cord_abg_ph, cord_abg_po2, cord_abg_pc02, cord_abg_hc03, cord_abg_be, hr, hc, length, spo2, temp 
FROM healthscore_dw.dim_patient_birth_exam_history bh
join healthscore_dw.nucleus_hospital_master_view hm ON bh.hospital_key = hm.hospital_key
 ;
 
DROP VIEW IF EXISTS healthscore_dw.nucleus_careplan_execution_view;
CREATE VIEW healthscore_dw.nucleus_careplan_execution_view AS
SELECT patient_careplan_execution_key, patient_careplan_instruction_key, ced.patient_careplan_key, careplan_instruction_master_key, hm.hospital_key, cp.patient_key, recorded_ts, infusion_rate, input_output_volume, feed_route_nm, input_output_type_nm, input_output_type_measurement_ref_text, input_output_type_category, ventilator_mode_nm, ventilator_settings_nm, ventilator_uom_nm, ventilator_allowed_lower_limit, ventilator_allowed_upper_limit, ventilator_settings_value 
FROM healthscore_dw.fact_patient_careplan_execution_details ced
join healthscore_dw.fact_patient_careplans cp 
on ced.patient_careplan_key = cp.patient_careplan_key
join healthscore_dw.nucleus_hospital_master_view hm ON cp.visit_hospital_key = hm.hospital_key
 ;

DROP VIEW IF EXISTS healthscore_dw.nucleus_calendar_view;
CREATE VIEW healthscore_dw.nucleus_calendar_view AS
SELECT * FROM healthscore_dw.dim_date;

DROP VIEW IF EXISTS healthscore_dw.nucleus_patient_diagnosis_view;
CREATE VIEW healthscore_dw.nucleus_patient_diagnosis_view AS
SELECT fci.patient_key,patient_visit_key,clinical_info_desc as diagnosis_nm,effective_from_ts,effective_to_ts
FROM healthscore_dw.fact_patient_clinical_info fci
join healthscore_dw.map_patient_hospital mph
on mph.patient_key = fci.patient_key
join healthscore_dw.nucleus_hospital_master_view  hm
on mph.hospital_key = hm.hospital_key
WHERE clinical_info_type_cd='diagnosis';

grant select on  healthscore_dw.nucleus_hospital_master_view to nucleus_db_viewer@localhost;
grant select on  healthscore_dw.nucleus_patient_master_view to nucleus_db_viewer@localhost;
grant select on  healthscore_dw.nucleus_patient_medications_view to nucleus_db_viewer@localhost;
grant select on  healthscore_dw.nucleus_patient_assessments_view to nucleus_db_viewer@localhost;
grant select on  healthscore_dw.nucleus_hospital_staff_master_view to nucleus_db_viewer@localhost;
grant select on  healthscore_dw.nucleus_patient_visit_view to nucleus_db_viewer@localhost;
grant select on  healthscore_dw.nucleus_patient_careplan_instructions_view to nucleus_db_viewer@localhost;
grant select on  healthscore_dw.nucleus_hospital_daily_statistics_view to nucleus_db_viewer@localhost;
grant select on  healthscore_dw.nucleus_obstetric_history_view to nucleus_db_viewer@localhost;
grant select on  healthscore_dw.nucleus_birth_history_view to nucleus_db_viewer@localhost;
grant select on  healthscore_dw.nucleus_birth_exam_history_view to nucleus_db_viewer@localhost;
grant select on  healthscore_dw.nucleus_careplan_execution_view to nucleus_db_viewer@localhost;
grant select on  healthscore_dw.nucleus_calendar_view to nucleus_db_viewer@localhost;
grant select on  healthscore_dw.nucleus_patient_diagnosis_view to nucleus_db_viewer@localhost;
