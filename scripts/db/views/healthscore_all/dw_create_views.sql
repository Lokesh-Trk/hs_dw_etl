DROP VIEW IF EXISTS healthscore_dw.all_patient_master_view;
CREATE VIEW healthscore_dw.all_patient_master_view as
SELECT mph.hospital_key,dp.patient_key,patient_unique_id,patient_gender,patient_birth_dt,patient_death_ts,blood_group,contact_addr_city_nm,contact_addr_state_nm,contact_addr_country_nm,contact_addr_zipcode, date(mph.hospital_registration_ts) as first_visit_date, mph.color_category_nm as patient_category, patient_socio_economic_status,patient_occupation_status,patient_marital_status,patient_religion,patient_spouse_occupation
 FROM healthscore_dw.dim_patient dp
 join healthscore_dw.map_patient_hospital mph
on mph.patient_key = dp.patient_key;


DROP VIEW IF EXISTS healthscore_dw.all_hospital_staff_master_view;
CREATE VIEW healthscore_dw.all_hospital_staff_master_view as
select ds.staff_key, ds.hospital_key, dh.hospital_cd, ds.hospital_staff_cd, ds.hospital_staff_full_nm,hospital_staff_user_nm,hospital_staff_gender,hospital_staff_type_nm,hospital_staff_kmc_reg_no,hospital_staff_dept_nm,ds.active_flg
from  healthscore_dw.dim_staff ds
 join healthscore_dw.dim_hospital dh
  on ds.hospital_key = dh.hospital_key;