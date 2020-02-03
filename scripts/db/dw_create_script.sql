-- drop database healthscore_dw;
create database if not exists healthscore_dw;

drop TABLE if exists healthscore_dw.dim_date;
use healthscore_dw;
 CREATE TABLE healthscore_dw.dim_date (
  date_key date NOT NULL,
  yr_mth varchar(7) NOT NULL,
  day_id int(11) NOT NULL,
  day_of_week_id int(11) NOT NULL,
  day_of_month_id int(11) NOT NULL,
  day_nm varchar(20) NOT NULL,
  week_id int(11) NOT NULL,
  month_id int(11) NOT NULL,
  month_nm varchar(10) NOT NULL,
  month_full_nm varchar(20) NOT NULL,
  quarter_id int(11) NOT NULL,
  year_id int(11) NOT NULL,
  lastday_mth date NOT NULL,
  lastday_qtr date NOT NULL,
  lastday_yr date NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
 PRIMARY KEY (date_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

drop TABLE if exists healthscore_dw.dim_time;
 CREATE TABLE healthscore_dw.dim_time (
  time_key time NOT NULL,
  hour int(11) DEFAULT NULL,
  minute int(11) DEFAULT NULL,
  second int(11) DEFAULT NULL,
  ampm varchar(20) DEFAULT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
 PRIMARY KEY (time_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
 drop TABLE if exists healthscore_dw.dim_location;
CREATE TABLE healthscore_dw.dim_location (
  location_key bigint(20) NOT NULL AUTO_INCREMENT,
  zipcode varchar(20) NOT NULL,
  area_nm varchar(100) DEFAULT NULL, 
  city_nm varchar(100) DEFAULT NULL,
  state_nm varchar(100) DEFAULT NULL,
  country_nm varchar(50) DEFAULT 'India',
  country_cd varchar(10) DEFAULT 'IND',
  latitude varchar(45) DEFAULT NULL,
  longitude varchar(45) DEFAULT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (location_key),
  UNIQUE KEY uk_dim_location(zipcode,area_nm,city_nm,state_nm)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS healthscore_dw.dim_hospital;
CREATE TABLE healthscore_dw.dim_hospital(
  hospital_key int(11) NOT NULL AUTO_INCREMENT,  
  hospital_cd varchar(45) NOT NULL, 
  hospital_nm varchar(400) DEFAULT NULL, 
  hospital_addr_line1 varchar(45) DEFAULT NULL,
  hospital_addr_line2 varchar(45) DEFAULT NULL,
  hospital_addr_city_nm varchar(100) DEFAULT NULL,
  hospital_addr_state_nm varchar(100) DEFAULT NULL,
  hospital_addr_country_nm varchar(100) DEFAULT NULL,
  hospital_phone_num varchar(45) DEFAULT NULL,
  hospital_email_addr varchar(100) DEFAULT NULL,
  hospital_logo varchar(400) DEFAULT NULL,
  active_flg tinyint(1),
  convenience_fee decimal(10,2),
  convenience_pct_flg tinyint(1),
  razorpay_account_id varchar(100),
  patient_app_flg tinyint(1),
  created_by varchar(45),
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
 PRIMARY KEY (hospital_key),
 UNIQUE KEY uk_hospital_cd(hospital_cd)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;
  
DROP TABLE IF EXISTS healthscore_dw.map_patient_hospital; 
CREATE TABLE healthscore_dw.map_patient_hospital(
  map_patient_hospital_key int(11) NOT NULL AUTO_INCREMENT,
  patient_key int(11) NOT NULL , 
  hospital_key int(11) NOT NULL, 
  hospital_cd varchar(45) NOT NULL, 
  hospital_patient_cd varchar(200) NOT NULL,
  hospital_patient_id int(11) NOT NULL, 
  hospital_registration_ts datetime,
  payment_provider varchar(100) DEFAULT NULL,
  patient_referred_by varchar(100) DEFAULT NULL,
  default_rate_category_nm varchar(45) DEFAULT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
 PRIMARY KEY (map_patient_hospital_key),
 UNIQUE KEY uk_hospital_patient_cd(hospital_patient_cd),
 UNIQUE KEY uk_patient_hospital_key(patient_key,hospital_key)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;
  
DROP TABLE IF EXISTS healthscore_dw.dim_patient;
CREATE TABLE healthscore_dw.dim_patient (
  patient_key int(11) NOT NULL AUTO_INCREMENT, 
  patient_unique_id varchar(100) NOT NULL,
  patient_unique_id_type varchar(20) NOT NULL DEFAULT 'hospital_patient_cd',
  patient_nm varchar(120) NOT NULL,
  patient_first_nm varchar(120) NOT NULL,
  patient_middle_nm varchar(120) DEFAULT NULL,
  patient_last_nm varchar(120) DEFAULT NULL,
  patient_gender varchar(12) NOT NULL,
  patient_birth_dt date NOT NULL,
  patient_birth_ts datetime DEFAULT NULL,
  patient_death_ts datetime DEFAULT NULL,
  patient_mother_nm varchar(100) DEFAULT NULL,
  patient_father_nm varchar(100) DEFAULT NULL,
  blood_group varchar(45) DEFAULT NULL,
  gestational_age_in_days int(11) DEFAULT NULL,
  birth_weight_gms double DEFAULT NULL,
  contact_email_id varchar(100) DEFAULT NULL,
  contact_addr_line1 varchar(200) DEFAULT NULL,
  contact_addr_line2 varchar(200) DEFAULT NULL,
  contact_addr_city_nm varchar(100) DEFAULT NULL,
  contact_addr_state_nm varchar(100) DEFAULT NULL,
  contact_addr_country_nm varchar(100) DEFAULT NULL,
  contact_home_phone_num varchar(45) DEFAULT NULL,
  contact_mobile_phone_num varchar(45) DEFAULT NULL,
  patient_alternate_phone_num varchar(45) DEFAULT NULL,
  patient_emerg_contact_nm varchar(100) DEFAULT NULL,
  patient_emerg_contact_num varchar(45) DEFAULT NULL,
  patient_relation varchar(100) DEFAULT NULL,
  patient_occupation varchar(100) DEFAULT NULL,
  patient_marital_status varchar(100) DEFAULT NULL,
  patient_religion varchar(100) DEFAULT NULL,
  patient_spouse_occupation varchar(100) DEFAULT NULL,
  effective_from_ts datetime DEFAULT NULL,
  effective_to_ts datetime DEFAULT NULL,
  created_by_staff_key int(11) not null,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (patient_key),
  UNIQUE KEY uk_patient_unique_id(patient_unique_id,patient_unique_id_type)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS healthscore_dw.dim_patient_documents;
CREATE TABLE healthscore_dw.dim_patient_documents (
  patient_document_key  int(11) NOT NULL AUTO_INCREMENT,
  patient_key int(11) NOT NULL,
  hospital_key int(11) NOT NULL,
  document_created_date_key date NOT NULL,
  document_created_time_key time NOT NULL,
  document_created_ts datetime NOT NULL,
  hospital_document_id int(11) NOT NULL,
  upload_url  varchar(1000) NOT NULL, -- concatenate with hospital cd and then save
  document_nm  varchar(1000), 
  document_desc  varchar(1000) DEFAULT NULL, 
  document_tags_json JSON DEFAULT NULL,  
  thumbnail_url  varchar(1000) DEFAULT NULL, 
  user_uploaded_flg tinyint(1) DEFAULT 0,
  active_flg tinyint(1) default null,
  uploaded_patient_visit_key int(11) default null,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
 PRIMARY KEY (patient_document_key),
 UNIQUE KEY uk_patient_document(patient_key,hospital_key,hospital_document_id)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS healthscore_dw.fact_patient_clinical_info;
CREATE TABLE healthscore_dw.fact_patient_clinical_info (
  patient_clinical_info_key int(11) NOT NULL AUTO_INCREMENT,
  patient_key int(11) NOT NULL,
  patient_visit_key int(11),
  created_staff_key int(11),
  clinical_info_type_cd varchar(100) NOT NULL,   --  allergy, diagnosis, pasthistory, familyhistory , symptoms
  clinical_info_ref_id int(11) NOT NULL, -- snomed codes for 
  clinical_info_desc varchar(4000),  
  active_flg bit DEFAULT 1,
  effective_from_ts datetime, -- capturing past history/family history since date, diagnosis date, allergy date
  effective_to_ts datetime,
  recorded_date_key date NOT NULL,
  recorded_time_key time NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (patient_clinical_info_key),
  UNIQUE KEY uk_patient_clinical_info(patient_key,clinical_info_type_cd,clinical_info_ref_id,effective_from_ts)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;
 
 DROP TABLE IF EXISTS healthscore_dw.fact_patient_medications;
CREATE TABLE fact_patient_medications (
  patient_medication_key int(11) NOT NULL AUTO_INCREMENT,
  patient_key int(11) NOT NULL,
  pharma_product_ref_id bigint(50) DEFAULT NULL,
  pharma_product_ref_display_txt varchar(238) DEFAULT NULL,
  pharma_brand_nm varchar(500) DEFAULT NULL,
  dosage varchar(100) DEFAULT NULL,
  drug_form_ref_id bigint(50) DEFAULT NULL,
  drug_form_ref_display_txt varchar(4000) DEFAULT NULL,
  frequency varchar(45) DEFAULT NULL,
  comments varchar(500) DEFAULT NULL,
  start_dt datetime NOT NULL,
  end_dt datetime DEFAULT NULL,
  active_flg tinyint(1) NOT NULL,
  prescribed_by_doctor_nm varchar(100) NOT NULL,
  prescribed_hospital_key int(11) NOT NULL,
  prescribed_ts datetime DEFAULT NULL,
  prescribed_patient_visit_key int(11) NOT NULL,
  created_by_staff_key int(11) not null,
  prescribed_date_key date NOT NULL,
  prescribed_time_key time NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (patient_medication_key),
  UNIQUE KEY uk_patient_medication_key (patient_key,pharma_brand_nm,start_dt)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

Drop table if exists healthscore_dw.fact_patient_visits;
CREATE TABLE healthscore_dw.fact_patient_visits (
  patient_visit_key int(11) NOT NULL AUTO_INCREMENT,
  patient_key int(11) NOT NULL,
  visit_hospital_key int(11) NOT NULL,
  visit_date_key date NOT NULL,
  visit_time_key time NOT NULL,
  visit_doctor_staff_key int(11) NOT NULL,
  primary_doctor_staff_key int(11),
  reference_doctor_staff_key int(11) ,
  hospital_patient_visit_id bigint(50) NOT NULL,
  checkin_ts datetime ,
  checkout_ts datetime,
  checkout_type varchar(45) ,
  delivery_ts datetime ,
  outcome_type varchar(45) ,
  condition_at_discharge varchar(45) ,
  discharge_ts datetime ,
  visit_type varchar(10) ,
  visit_reason varchar(200) ,
  visit_rate_category_nm varchar(45) NOT NULL,
  visit_ip_nbr varchar(45) ,
  appointment_id int(11) ,
  admission_method varchar(45),
  cancel_reason varchar(200) ,
  ward_nm varchar(255) DEFAULT NULL,
  daily_rate decimal(10,2) ,
  daily_rate_modified_by_staff_key varchar(45) DEFAULT NULL,
  referral_source varchar(45),
  discharge_summary_pdf_url varchar(1000) DEFAULT NULL,
  doctor_notes_pdf_url varchar(1000) DEFAULT NULL,
  pharmacy_checkin_flg tinyint(1),
  source_cd varchar(45) NOT NULL,
  created_by_staff_key int(11) not null,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (patient_visit_key),
  UNIQUE KEY uk_patient_visit_key (patient_key,visit_hospital_key,visit_date_key,visit_time_key),
  UNIQUE KEY uk_hospital_patient_visit_id (hospital_patient_visit_id,source_cd)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS healthscore_dw.fact_patient_vitals;
 CREATE TABLE healthscore_dw.fact_patient_vitals
 (
  patient_vital_key int(11) NOT NULL AUTO_INCREMENT,
  patient_key int(11) NOT NULL,
  vital_ref_component_id bigint(50) NOT NULL,
  vital_ref_display_txt varchar(255) DEFAULT NULL,
  measurementunit_ref_component_id bigint(50) NOT NULL,
  measurementunit_ref_display_txt varchar(255) DEFAULT NULL,
  patient_vital_value  decimal(10,2) NOT NULL,
  vital_recorded_date_key date not null,
  vital_recorded_time_key time not null,
  vital_recorded_ts datetime not NULL,
  biomedicaldevice_ref_id bigint(50) DEFAULT NULL,  -- can we have the device id of the user entering this? or device id of the rasp pi? 
  recorded_hospital_key int(11) NOT NULL, 
  recorded_patient_visit_key int(11),
  user_uploaded_flg tinyint(1) default 0,
  vital_created_ts datetime not NULL,
  created_by_staff_key int(11),
  source_cd varchar(20) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (patient_vital_key),
  UNIQUE uk_patient_vitals_key(patient_key,vital_ref_component_id,patient_vital_value,vital_recorded_date_key,vital_recorded_time_key)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;
  
 DROP TABLE IF EXISTS healthscore_dw.fact_patient_appointments;
 CREATE TABLE healthscore_dw.fact_patient_appointments (
  patient_appt_key int(11) NOT NULL AUTO_INCREMENT,
  patient_key int(11) NOT NULL,
  schedule_status  varchar(255) NOT NULL, -- requested, confirmed, cancelled, no show, fulfilled
  hospital_key bigint(50) DEFAULT NULL,
  hospital_doctor_key int(11) NOT NULL,
  schedule_date_key DATE not null,
  schedule_created_ts datetime NOT NULL,
  schedule_start_time_key time NOT NULL,
  schedule_end_time_key time DEFAULT NULL,
  doctor_nm varchar(100) NOT NULL,
  duration int(11) DEFAULT NULL, 
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (patient_appt_key),
  UNIQUE uk_patient_appointments_key(patient_key,hospital_doctor_key,schedule_date_key,schedule_end_time_key)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;
 
 DROP TABLE IF EXISTS healthscore_dw.fact_patient_assessments;
 CREATE TABLE healthscore_dw.fact_patient_assessments(
  patient_assmt_key int(11) NOT NULL AUTO_INCREMENT,
  patient_key int(11) NOT NULL,
  visit_hospital_key int(11) DEFAULT NULL,
  patient_visit_key int(11) default null,
  health_assessment_scale_desc varchar(45) NOT NULL,
  assessment_results_json VARCHAR(1000) NOT NULL, -- seq_no, component_reference_range_txt, result_item_nm, assessment_scale_result_value
  assessed_date_key date not null,
  assessed_time_key time not null,
  assessed_ts datetime not null,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (patient_assmt_key),
  UNIQUE uk_patient_assessments_key(patient_key,health_assessment_scale_desc,assessed_date_key,assessed_time_key)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

 DROP TABLE IF EXISTS healthscore_dw.fact_patient_visitbills;
 CREATE TABLE healthscore_dw.fact_patient_visitbills(
 patient_visitbill_key int(11) NOT NULL AUTO_INCREMENT,
 patient_key int(11) NOT NULL,
 visit_hospital_key int(11) NOT NULL,
 patient_visit_key int(11) not null,
 visit_bill_id bigint(50) NOT NULL,
 visit_bill_cd varchar(45) NOT NULL, 
 visit_bill_total_amt  decimal(10,2) default 0,
 visit_bill_paid_amt decimal(10,2) default 0,
 visit_bill_concession_amt  decimal(10,2) default 0,
 visit_bill_waived_amt  decimal(10,2) default 0,
 visit_bill_refund_amt  decimal(10,2) default 0,
 visit_bill_from_ts datetime NOT NULL, 
 visit_bill_to_ts datetime , 
 visit_bill_comments varchar(100),
 visit_bill_adjusted_flg tinyint(1) default 0,
 visit_bill_created_ts datetime NOT NULL,
 visit_bill_date_key date not null,
 visit_bill_time_key time not null,
 visit_billed_ts timestamp,
 created_by_staff_key int(11) not null,
 modified_by_staff_key int(11),
 source_cd varchar(20) NOT NULL,
 inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
 updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
 PRIMARY KEY (patient_visitbill_key),
 UNIQUE uk_patient_visitbills_key(visit_hospital_key,patient_visit_key,visit_bill_cd),
 UNIQUE uk_patient_visitbills_id(visit_bill_id,source_cd)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS healthscore_dw.fact_patient_careplans;
CREATE TABLE healthscore_dw.fact_patient_careplans -- show to do list by date 
(
 patient_careplan_key int(11) NOT NULL AUTO_INCREMENT,
 patient_key int(11) NOT NULL,
 visit_hospital_key int(11) NOT NULL,
 patient_visit_key int(11) default null,
 careteam_desc varchar(1000) NOT NULL, -- list of all doctor names
 todo_date_key date not null,
 todo_time_key time not null,
 todo_ts datetime not null ,
 careplan_instruction_json JSON NOT NULL,  -- instruction with status - pending , missed,  completed
 inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
 updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,	
 PRIMARY KEY (patient_careplan_key),
 UNIQUE uk_patient_careplan_key(patient_key,todo_date_key,todo_time_key)
)ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS healthscore_dw.fact_patient_investigations;
CREATE TABLE healthscore_dw.fact_patient_investigations
(
 patient_investigation_key int(11) NOT NULL AUTO_INCREMENT,
 patient_key int(11) NOT NULL,
 hospital_key int(11) NOT NULL,
 patient_visit_key int(11) default null,
 investigation_type varchar(10)  NOT NULL, -- Lab, XRAY, MRI, USG
 investigation_date_key date NOT NULL,
 investigation_time_key time NOT NULL,
 investigation_ts datetime NOT NULL, 
 investigation_results_json JSON NULL,  
 investigation_results_pdf_url VARCHAR(1000) NULL,
 user_uploaded_flg tinyint(1) DEFAULT 0,  
 inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
 updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,	
 PRIMARY KEY (patient_investigation_key),
 UNIQUE uk_patient_investigation_key(patient_key,hospital_key,investigation_type,investigation_date_key,investigation_time_key)
)ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS healthscore_dw.etl_log; 
CREATE TABLE healthscore_dw.etl_log(
  etl_log_id bigint(50) NOT NULL auto_increment, 
  load_id int(11) NOT NULL,
  etl varchar(100) NOT NULL,
  source varchar(200) NOT NULL,
  target varchar(200) NOT NULL,
  status varchar(100) NOT NULL,
  message LONGTEXT,
  data_start_ts datetime ,
  data_end_ts datetime ,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,	
  PRIMARY KEY (etl_log_id),
  UNIQUE uk_etl_log_id(load_id,etl,source,target)
)ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS healthscore_dw.etl_load_details; 
CREATE TABLE healthscore_dw.etl_load_details(
  etl_load_id bigint(50) NOT NULL auto_increment, 
  source_cd varchar(20) NOT NULL, -- hospital_cd
  status varchar(100) NOT NULL,
  message LONGTEXT,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,	
  PRIMARY KEY (etl_load_id)
)ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS healthscore_dw.dim_staff;
CREATE TABLE healthscore_dw.dim_staff (
  staff_key int(11) NOT NULL AUTO_INCREMENT,
  hospital_key int(11) NOT NULL ,
  hospital_staff_id int(11) NOT NULL,
  hospital_staff_cd varchar(45) NOT NULL,
  hospital_staff_full_nm varchar(100) DEFAULT NULL,
  hospital_staff_user_nm varchar(45) NOT NULL,  
  hospital_staff_gender varchar(45) DEFAULT NULL,
  hospital_staff_type_cd varchar(45) NOT NULL,
  hospital_staff_type_nm varchar(100) NOT NULL,
  hospital_staff_kmc_reg_no varchar(45) DEFAULT NULL,
  email_id varchar(100) DEFAULT NULL,
  mobile_number varchar(45) DEFAULT NULL,
  country_cd varchar(6) DEFAULT NULL,
  active_flg tinyint(1) DEFAULT NULL,
  created_by_user_nm varchar(45),
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,	
  PRIMARY KEY (staff_key),
  UNIQUE uk_hospital_staff_user_nm(hospital_key,hospital_staff_user_nm),
  unique uk_hospital_staff_id(hospital_key,hospital_staff_id)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS healthscore_dw.dim_bill_items;
CREATE TABLE healthscore_dw.dim_bill_items (
  bill_item_key int(11) NOT NULL AUTO_INCREMENT,
  hospital_key int(11) NOT NULL ,
  bill_item_type varchar(45) NOT NULL, -- bill_item, bill_package, bill_package_app_subscription, consultation_item, inventory_item, lab_item
  bill_item_category_id bigint(50) NOT NULL, 
  bill_item_category_cd varchar(10) NOT NULL, -- bill category cd, bill package category cd, consultation type cd, product cd, lab category cd
  bill_item_category_nm varchar(100),
  bill_item_category_desc JSON,  -- json field with validity_no_days,multi_visit_flg,effective_from_ts,effective_to_ts
  bill_item_id bigint(50),
  bill_item_cd varchar(500) NOT NULL, 
  bill_item_nm varchar(1000) NOT NULL,
  bill_item_amt decimal(10,2) NOT NULL DEFAULT 0.0, -- bill item count for packages
  consulting_staff_key int(11) NULL,
  total_cnt int(11) NULL, 
  transaction_type_cd varchar(10),
  pkg_effective_from_ts timestamp NULL,
  pkg_effective_to_ts timestamp NULL, 
  renewal_item_flg TINYINT(1) ,
  effective_from_ts timestamp NULL,
  effective_to_ts timestamp NULL,
  rate_category_nm varchar(45) DEFAULT 'Default',
  active_flg tinyint(1),
  display_seq_no int(11) DEFAULT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,	
  PRIMARY KEY (bill_item_key),
  UNIQUE uk_bill_item_key(hospital_key,bill_item_category_cd,bill_item_type,bill_item_cd,effective_from_ts,pkg_effective_from_ts,pkg_effective_to_ts,rate_category_nm)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;
 
DROP TABLE IF EXISTS healthscore_dw.dim_hospital_wards;
CREATE TABLE healthscore_dw.dim_hospital_wards (
  hospital_ward_key int(11) NOT NULL AUTO_INCREMENT,
  hospital_key int(11) NOT NULL ,
  hospital_ward_id int(11) NOT NULL ,
  hospital_ward_cd varchar(45) NOT NULL,
  hospital_ward_nm varchar(100),
  hospital_ward_floor_no varchar(45),
  hospital_ward_bedcount_no varchar(45),
  active_flg tinyint(1),
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,	
  PRIMARY KEY (hospital_ward_key),
  UNIQUE uk_hospital_ward_id(hospital_key,hospital_ward_id)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS healthscore_dw.map_patient_visit_doctors;
CREATE TABLE healthscore_dw.map_patient_visit_doctors(
  map_patient_visit_doctor_key int(11) NOT NULL AUTO_INCREMENT,
  patient_key int(11) NOT NULL , 
  visit_hospital_key int(11) NOT NULL, 
  patient_visit_key int(11) NOT NULL, 
  visit_doctor_staff_key int(11) NOT NULL,
  hospital_visit_doctor_id int(11) NOT NULL,
  hospital_patient_visit_id int(11) NOT NULL,
  patient_visit_doctor_ts datetime not null,
  source_cd varchar(45) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (map_patient_visit_doctor_key),
  UNIQUE uk_map_patient_visit_doctor_key (patient_key,visit_hospital_key,patient_visit_key,visit_doctor_staff_key,hospital_visit_doctor_id),
  UNIQUE KEY uk_hospital_visit_doctor_id (hospital_visit_doctor_id,source_cd)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS healthscore_dw.fact_patient_visitbillitems;
CREATE TABLE healthscore_dw.fact_patient_visitbillitems(
patient_visitbillitem_key int(11) NOT NULL AUTO_INCREMENT,
patient_visitbill_key int(11) NOT NULL,
bill_item_key int(11) NOT NULL,
vbi_date_key date NOT NULL,
vbi_time_key time NOT NULL,
vbi_created_staff_key int(11) not null,
tax_type_key int(11) ,
stock_batch_key int(11) ,
patient_care_plan_instruction_key int(11) , 
vbi_modified_staff_key int(11),
bill_item_qty int(11) NOT NULL,
bill_item_returned_qty int(11),
bill_item_unit_amt decimal(10,2) NOT NULL,
bill_item_total_concession_amt decimal(10,2),
bill_item_final_amt decimal(10,2) NOT NULL,
bill_item_receipt_cd varchar(45),
bill_item_total_tax decimal(10,2),
active_flg tinyint(1),
pharmacy_item_flg tinyint(1) NOT NULL,
vbi_created_ts timestamp NOT NULL,
payment_method_id int(11) ,
inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
PRIMARY KEY (patient_visitbillitem_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

drop table healthscore_dw.fact_patient_dailyrate;
create table healthscore_dw.fact_patient_dailyrate(
patient_dailyrate_key int(11) NOT NULL auto_increment,
patient_visit_key int(11) NOT NULL, 
daily_rate int(11) NOT NULL, 
effective_from_ts datetime,
effective_to_ts datetime, 
source_cd varchar(45) not null,
primary key (patient_dailyrate_key),
unique key patient_visit_key(patient_visit_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS healthscore_dw.fact_patient_order_details;
CREATE TABLE healthscore_dw.fact_patient_order_details (
patient_order_details_key int(11) NOT NULL AUTO_INCREMENT,
patient_key int(11) not null,
bill_item_key	int(11) not null,
convenience_amt   double,
bill_item_qty   int(11),
total_amt   double,
app_bill_flg   tinyint(1) NOT NULL,
razorpay_transfer_flg   tinyint(1) NOT NULL,
payment_status_nm varchar(400) NOT NULL,
active_flg   tinyint(1) NOT NULL,
created_by   varchar(45),
modified_by   varchar(45),
order_created_ts   datetime,
order_date_key date NOT NULL,
order_time_key time NOT NULL,
order_modified_ts   datetime,
hsapp_patient_order_id bigint(50) NOT NULL,
inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
PRIMARY KEY (patient_order_details_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS healthscore_dw.fact_fhir_message;
CREATE TABLE healthscore_dw.fact_fhir_message (
fhir_message_key int(11) NOT NULL AUTO_INCREMENT,
hsapp_message_id varchar(1000) NOT NULL,
queue_nm varchar(100) DEFAULT NULL,
resource_type  varchar(255) DEFAULT NULL,
message_txt varchar(4000) DEFAULT NULL,
failed_flg tinyint(1) DEFAULT '0',  
error_msg varchar(4000) DEFAULT NULL,
retry_cnt int(11) DEFAULT '0',
created_by varchar(45) NOT NULL,
recorded_created_ts datetime NOT NULL,
recorded_date_key date NOT NULL,
recorded_time_key time NOT NULL,
modified_by varchar(45) DEFAULT NULL,
recorded_modified_ts datetime DEFAULT NULL,
fhir_message_id int(11) NOT NULL,
source varchar(45) DEFAULT NULL,
inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
PRIMARY KEY (fhir_message_key)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS healthscore_dw.fact_patient_visit_advice;
CREATE TABLE healthscore_dw.fact_patient_visit_advice (
patient_visit_advice_key int(11) NOT NULL AUTO_INCREMENT,
visit_note_type varchar(45) NOT NULL,
patient_key int(11) NOT NULL,
visit_doctor_staff_key int(11) NOT NULL,
visit_hospital_key int(11) NOT NULL,
advice_desc varchar(4000) DEFAULT NULL,
active_flg tinyint(1) DEFAULT '1',
note_created_ts datetime not null,
note_modified_ts datetime,
created_by_staff_key int(11) NOT NULL,
modified_by_staff_key int(11) ,
inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
updated_ts timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
PRIMARY KEY (patient_visit_advice_key)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
