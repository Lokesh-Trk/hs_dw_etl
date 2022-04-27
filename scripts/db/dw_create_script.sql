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
  hospital_addr_zipcode varchar(20) Default NULL,
  hospital_phone_num varchar(45) DEFAULT NULL,
  hospital_email_addr varchar(100) DEFAULT NULL,
  hospital_logo varchar(400) DEFAULT NULL,
  active_flg tinyint(1),
  convenience_fee decimal(10,2),
  convenience_pct_flg tinyint(1),
  razorpay_account_id varchar(100),
  patient_app_flg tinyint(1),
  created_by varchar(45),
  etl_load_id int(11) NOT NULL,
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
  etl_load_id int(11) NOT NULL,
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
  contact_addr_zipcode varchar(20) DEFAULT NULL,
  contact_home_phone_num varchar(45) DEFAULT NULL,
  contact_mobile_phone_num varchar(45) DEFAULT NULL,
  patient_alternate_phone_num varchar(45) DEFAULT NULL,
  patient_emerg_contact_nm varchar(100) DEFAULT NULL,
  patient_emerg_contact_num varchar(45) DEFAULT NULL,
  patient_relation varchar(100) DEFAULT NULL,
  patient_occupation_status varchar(100) DEFAULT NULL,
  patient_marital_status varchar(100) DEFAULT NULL,
  patient_religion varchar(100) DEFAULT NULL,
  patient_spouse_occupation varchar(100) DEFAULT NULL,
  patient_socio_economic_status varchar(100) DEFAULT NULL,
  effective_from_ts datetime DEFAULT NULL,
  effective_to_ts datetime DEFAULT NULL,
  created_by_staff_key int(11) not null,
  etl_load_id int(11) NOT NULL,
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
  etl_load_id int(11) NOT NULL,
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
  etl_load_id int(11) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (patient_clinical_info_key),
  UNIQUE KEY uk_patient_clinical_info(patient_key,clinical_info_type_cd,clinical_info_ref_id,effective_from_ts)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;
 

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
  referral_source varchar(45),
  discharge_summary_pdf_url varchar(1000) DEFAULT NULL,
  doctor_notes_pdf_url varchar(1000) DEFAULT NULL,
  pharmacy_checkin_flg tinyint(1),
  source_cd varchar(45) NOT NULL,
  created_by_staff_key int(11) not null,
  patient_visit_cd varchar(45) NOT NULL,
  etl_load_id int(11) NOT NULL,
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
  etl_load_id int(11) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (patient_vital_key),
  UNIQUE uk_patient_vitals_key(patient_key,vital_ref_component_id,vital_created_ts)
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
  etl_load_id int(11) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (patient_appt_key),
  UNIQUE uk_patient_appointments_key(patient_key,hospital_doctor_key,schedule_date_key,schedule_end_time_key)
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
 visit_bill_balance_amt  decimal(10,2) default 0,
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
 previous_bill_balance_amt decimal(10,2) default NULL,
 previous_visit_bill_key int(11) default NULL,
 etl_load_id int(11) NOT NULL,
 inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
 updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
 PRIMARY KEY (patient_visitbill_key),
 UNIQUE uk_patient_visitbills_key(visit_hospital_key,patient_visit_key,visit_bill_cd),
 UNIQUE uk_patient_visitbills_id(visit_bill_id,source_cd)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

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
 etl_load_id int(11) NOT NULL,
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
  etl_load_id int(11) NOT NULL,
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
  etl_load_id int(11) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,	
  PRIMARY KEY (bill_item_key),
  UNIQUE uk_bill_item_key(hospital_key,bill_item_category_cd,bill_item_type,bill_item_cd,effective_from_ts,pkg_effective_from_ts,rate_category_nm)
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
  etl_load_id int(11) NOT NULL,
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
  etl_load_id int(11) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (map_patient_visit_doctor_key),
  UNIQUE uk_map_patient_visit_doctor_key (patient_key,visit_hospital_key,patient_visit_key,visit_doctor_staff_key,hospital_visit_doctor_id,source_cd)
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
etl_load_id int(11) NOT NULL,
inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
PRIMARY KEY (patient_visitbillitem_key)
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
etl_load_id int(11) NOT NULL,
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
etl_load_id int(11) NOT NULL,
inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
PRIMARY KEY (fhir_message_key)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS healthscore_dw.fact_patient_visit_advice;
CREATE TABLE healthscore_dw.fact_patient_visit_advice (
patient_visit_advice_key int(11) NOT NULL AUTO_INCREMENT,
patient_key int(11) NOT NULL,
visit_doctor_staff_key int(11) NOT NULL,
visit_hospital_key int(11) NOT NULL,
advice_desc varchar(4000) DEFAULT NULL,
active_flg tinyint(1) DEFAULT '1',
note_created_ts datetime not null,
note_modified_ts datetime,
created_by_staff_key int(11) NOT NULL,
modified_by_staff_key int(11) ,
etl_load_id int(11) default 0,
inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
updated_ts timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
PRIMARY KEY (patient_visit_advice_key),
UNIQUE KEY uk_visit_advice_key(patient_key, visit_hospital_key,visit_doctor_staff_key,note_created_ts)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

 DROP TABLE IF EXISTS healthscore_dw.fact_patient_assessments;
 CREATE TABLE healthscore_dw.fact_patient_assessments(
  patient_assmt_key int(11) NOT NULL AUTO_INCREMENT,
  patient_key int(11) NOT NULL,
  visit_hospital_key int(11) DEFAULT NULL,
  patient_visit_key int(11) default null,
  health_assessment_scale_desc varchar(60) NOT NULL,
  hospital_dept_nm varchar(45) NOT NULL,
  assessment_result_item_seq_no int(11),
  assessment_result_item_ref_range_txt varchar(1000),
  assessment_result_item_display_txt varchar(100),
  assessment_result_item_value varchar(1000),
  assessed_date_key date not null,
  assessed_time_key time not null,
  assessed_ts datetime not null,
  etl_load_id int(11) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (patient_assmt_key),
  UNIQUE uk_patient_assessments_key(patient_key,health_assessment_scale_desc,assessment_result_item_display_txt,assessed_date_key,assessed_time_key)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

ALTER TABLE  healthscore_dw.dim_staff ADD COLUMN hospital_staff_dept_nm varchar(45) DEFAULT NULL;

ALTER TABLE healthscore_dw.dim_hospital ADD COLUMN source_cd varchar(45) DEFAULT NULL;

-- to be executed as of 30-09-2020-- from below

ALTER TABLE healthscore_dw.fact_patient_assessments MODIFY health_assessment_scale_desc varchar(100);

DROP TABLE IF EXISTS healthscore_dw.fact_patient_medications;
CREATE TABLE healthscore_dw.fact_patient_medications (
  patient_medication_key int(11) NOT NULL AUTO_INCREMENT,
  patient_key int(11) NOT NULL,
  medication_details_id int(11) NOT NULL,
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
  prescribed_doctor_staff_key int(11) not null,
  prescribed_hospital_key int(11) NOT NULL,
  prescribed_ts datetime DEFAULT NULL,
  prescribed_patient_visit_key int(11) NOT NULL,
  created_by_staff_key int(11) not null,
  prescribed_date_key date NOT NULL,
  prescribed_time_key time NOT NULL,
  etl_load_id int(11) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (patient_medication_key),
  UNIQUE KEY uk_patient_medication_key (medication_details_id,prescribed_hospital_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS healthscore_dw.dim_careplan_instruction_master;
CREATE TABLE healthscore_dw.dim_careplan_instruction_master 
(
 careplan_instruction_master_key int(11) NOT NULL AUTO_INCREMENT,
 hospital_key int(11) NOT NULL,
 instruction_id int(11) NOT NULL,
 careplan_instruction_desc varchar(2000) ,
 careplan_instruction_type_cd varchar(10) ,
 careplan_instruction_type_nm varchar(255) ,
 careplan_instruction_dept_cd varchar(10) ,
 careplan_instruction_dept_nm varchar(45) ,
 active_flg tinyint(1) DEFAULT NULL,
 created_by_staff_key int(11) NOT NULL,
 created_ts datetime not null,
 etl_load_id int(11) NOT NULL,
 inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
 updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP, 
 PRIMARY KEY (careplan_instruction_master_key),
 UNIQUE uk_careplan_Instruction_masterkey(hospital_key,instruction_id)
)ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS healthscore_dw.fact_patient_careplans;
CREATE TABLE healthscore_dw.fact_patient_careplans  
(
 patient_careplan_key int(11) NOT NULL AUTO_INCREMENT,
 patient_key int(11) NOT NULL,
 careplan_id int(11) NOT NULL,
 visit_hospital_key int(11) NOT NULL,
 created_visit_key int(11) NOT NULL,
 careplan_status_cd varchar(45) ,
 careplan_status_nm varchar(45) ,
 careplan_summary varchar(500),
 active_flg tinyint(1) not null default 1,
 created_by_staff_key int(11) NOT NULL,
 modified_by_staff_key int(11)  ,
 careplan_created_date_key date not null,
 careplan_created_time_key time not null,
 careplan_created_ts datetime not null,
 careplan_modified_date_key date ,
 careplan_modified_time_key time ,
 careplan_modified_ts datetime ,
 source_cd varchar(50) NOT NULL,
 etl_load_id int(11) NOT NULL,
 inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
 updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP, 
 PRIMARY KEY (patient_careplan_key),
 UNIQUE uk_patient_careplan_key(careplan_id,visit_hospital_key)
)ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS healthscore_dw.fact_patient_careplan_instructions;
CREATE TABLE healthscore_dw.fact_patient_careplan_instructions 
(
 patient_careplan_instruction_key bigint(20) NOT NULL AUTO_INCREMENT,
 patient_careplan_key int(11) not null,
 care_plan_instruction_id bigint(20) NOT NULL,
 careplan_instruction_master_key int(11) NOT NULL ,
 freq_mode_cd varchar(10) ,
 freq_mode_nm varchar(255) ,
 careplan_ins_status_cd varchar(45) ,
 careplan_ins_status_nm varchar(45) ,
 freq_num int(11) ,
 ins_started_ts datetime ,
 ins_ended_ts datetime ,
 comments varchar(545) ,
 created_by_staff_key int(11) NOT NULL,
 modified_by_staff_key int(11) ,
 bill_item_key int(11), 
 feed_qty double,
 total_feed double,
 interval_no int(11),
 feed_increase_qty decimal(10,2),
 feed_increase_freq_in_hrs decimal(10,2),
 first_feed_ins_start_ts datetime,
 stopped_flg tinyint(1),
 active_flg tinyint(1),
 ventilation_ins_detail JSON, 
 patient_medication_key int(11), 
 ins_created_date_key date not null,
 ins_created_time_key time not null,
 ins_created_ts datetime not null,
 etl_load_id int(11) NOT NULL,
 inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
 updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP, 
 PRIMARY KEY (patient_careplan_instruction_key),
 UNIQUE uk_patient_careplan_instruction(patient_careplan_key,care_plan_instruction_id)
)ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

-- to be executed as of 13-10-2020-- from below

DROP TABLE IF EXISTS healthscore_dw.fact_hospital_daily_statistics;
CREATE TABLE healthscore_dw.fact_hospital_daily_statistics 
(
  hospital_daily_statistics_key bigint(50) NOT NULL AUTO_INCREMENT,
 hospital_key int(11) NOT NULL,
 in_patient_cnt int(11) ,
 out_patient_cnt int(11),
 in_patient_admission_cnt int(11),
 in_patient_checkout_cnt int(11),
 out_patient_checkout_cnt int(11),
 in_patient_avg_stay decimal(10,2),
 as_of_date date,
 etl_load_id int(11) NOT NULL,
 inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
 updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP, 
 PRIMARY KEY (hospital_daily_statistics_key)
 )ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;
 
 -- to be executed after 21/10/2020
  ALTER TABLE  healthscore_dw.dim_staff ADD COLUMN (hospital_staff_join_dt datetime,hospital_staff_resignation_dt datetime);
  
  ALTER TABLE healthscore_dw.map_patient_hospital ADD COLUMN color_category_code varchar(10) DEFAULT NULL,Add column color_category_nm varchar(50) DEFAULT NULL, Add column color_hex_code_desc varchar(10) DEFAULT NULL;
  ALTER TABLE  healthscore_dw.dim_bill_items DROP INDEX uk_bill_item_key;
  ALTER TABLE  healthscore_dw.dim_bill_items ADD CONSTRAINT uk_bill_item_key UNIQUE (hospital_key,bill_item_type,bill_item_id,effective_from_ts,pkg_effective_from_ts);
  ALTER TABLE  healthscore_dw.fact_patient_vitals DROP INDEX uk_patient_vitals_key;
  ALTER TABLE  healthscore_dw.fact_patient_vitals ADD CONSTRAINT uk_patient_vitals_key UNIQUE (patient_key,vital_ref_component_id,vital_created_ts);
  ALTER TABLE  healthscore_dw.fact_patient_visitbills DROP INDEX uk_patient_visitbills_key;
  ALTER TABLE  healthscore_dw.fact_patient_medications ADD COLUMN source_cd varchar(50) DEFAULT NULL;
  ALTER TABLE  healthscore_dw.fact_patient_medications DROP INDEX uk_patient_medication_key;
  ALTER TABLE  healthscore_dw.fact_patient_medications ADD CONSTRAINT uk_patient_medication_key UNIQUE (patient_key,medication_details_id,source_cd);
  ALTER TABLE  healthscore_dw.fact_patient_clinical_info DROP COLUMN active_flg;
  ALTER TABLE  healthscore_dw.fact_patient_clinical_info ADD COLUMN active_flg tinyint(1);
  ALTER TABLE  healthscore_dw.fact_patient_clinical_info ADD COLUMN source_cd varchar(50) DEFAULT NULL;
  ALTER TABLE  healthscore_dw.fact_patient_careplan_instructions ADD COLUMN source_cd varchar(50) DEFAULT NULL;
  ALTER TABLE  healthscore_dw.fact_patient_visitbillitems ADD COLUMN (source_cd varchar(50) DEFAULT NULL,prior_visit_bill_id BIGINT(50),payment_comments varchar(105),non_editable_comments varchar(105), payment_method_desc VARCHAR(100),tax_type_nm varchar(45),tax_value_in_per decimal(6,3),src_visit_bill_item_id BIGINT(50));
  ALTER TABLE  healthscore_dw.fact_patient_visitbillitems ADD CONSTRAINT uk_vbi_key UNIQUE (src_visit_bill_item_id,source_cd);
  ALTER TABLE  healthscore_dw.fact_patient_visitbillitems DROP COLUMN tax_type_key;
  ALTER TABLE  healthscore_dw.fact_patient_visitbillitems DROP COLUMN payment_method_id;
  ALTER TABLE  healthscore_dw.fact_patient_visit_advice ADD COLUMN source_cd varchar(50) DEFAULT NULL;
  ALTER TABLE  healthscore_dw.fact_patient_assessments ADD COLUMN source_cd varchar(50) DEFAULT NULL;
  ALTER TABLE  healthscore_dw.fact_hospital_daily_statistics ADD COLUMN source_cd varchar(50) DEFAULT NULL;
  ALTER TABLE  healthscore_dw.fact_hospital_daily_statistics ADD CONSTRAINT uk_daily_statistics UNIQUE (as_of_date,hospital_key);

DROP TABLE IF EXISTS healthscore_dw.fact_active_visits;
CREATE TABLE healthscore_dw.fact_active_visits (
  active_visits_key int(11) NOT NULL AUTO_INCREMENT,
  as_of_date_key datetime NOT NULL, 
  patient_visit_key int(11) NOT NULL, 
  patient_key int(11) NOT NULL, 
  hospital_key int(11) NOT NULL, 
  daily_rate decimal(10,2) default 0.0, 
  billed_days int(11) DEFAULT NULL, 
  ward_nm varchar(255) DEFAULT NULL,
  admitted_days int(11) DEFAULT NULL, 
  total_paid_amt decimal(10,2) default 0, 
  total_refund_amt decimal(10,2) default 0, 
  total_waived_amt decimal(10,2) default 0, 
  total_billed_amt decimal(12,2) default 0.0, 
  unbilled_consumables_amt decimal(10,2) default 0.0, 
  unbilled_canteen_amt decimal(10,2) default 0.0, 
  previous_bill_balance_amt decimal(10,2) default 0.0,
  current_balance_amt decimal(10,2) default 0.0,
  source_cd varchar(50) NOT NULL,
  etl_load_id int(11) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,	
  PRIMARY KEY (active_visits_key),
  UNIQUE KEY uk_active_visits_key(as_of_date_key,patient_visit_key)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;


Drop table if exists healthscore_dw.fact_patient_visit_admission;
CREATE TABLE healthscore_dw.fact_patient_visit_admission (
  patient_visit_admission_key int(11) NOT NULL AUTO_INCREMENT,
  patient_visit_key int(11) NOT NULL,
  patient_key int(11) NOT NULL,
  visit_hospital_key int(11) NOT NULL,
  visit_diagnosis varchar(1000) DEFAULT NULL,  
  prev_hospital_duration_of_stay int(11) , 
  spl_req varchar(1000) DEFAULT NULL, 
  admission_note LONGTEXT DEFAULT NULL,
  source_cd varchar(45) NOT NULL,
  etl_load_id int(11) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (patient_visit_admission_key),
  UNIQUE KEY uk_patient_visit_admission_key (patient_visit_key)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS healthscore_dw.dim_patient_mother_obstetric_history;
CREATE TABLE healthscore_dw.dim_patient_mother_obstetric_history (
  patient_mother_obstetric_key  int(11) NOT NULL AUTO_INCREMENT,
  patient_key int(11) NOT NULL,
  hospital_key int(11) NOT NULL,
  anamoly_scan_ts varchar(1000) NULL,
  doppler_scan_ts varchar(1000) NULL,
  other_scan_ts varchar(1000) NULL, 
  anamoly_scan_desc TEXT  NULL,  
  doppler_scan_desc  TEXT, 
  other_scan_desc  TEXT DEFAULT NULL, 
  mother_age int(11) DEFAULT NULL,
  blood_group_display_nm varchar(20) DEFAULT NULL,
  gravidity_ct int(11) DEFAULT NULL,
  parity_ct int(11) DEFAULT NULL,
  abortion_ct int(11) DEFAULT NULL,
  died_ct int(11) DEFAULT NULL,
  living_children_ct int(11) DEFAULT NULL,
  ectopic_ct int(11) DEFAULT NULL,
  neonatal_death_ct int(11) DEFAULT NULL,
  still_birth_ct int(11) DEFAULT NULL,
  previous_lscs tinyint(1) DEFAULT NULL,
  gestation_type_nm varchar(20) DEFAULT NULL,
  hiv_flg tinyint(1) DEFAULT NULL,
  hbsag_flg tinyint(1) DEFAULT NULL,
  vdrl_flg tinyint(1) DEFAULT NULL,
  anaemia_flg tinyint(1) DEFAULT NULL,
  pih_flg tinyint(1) DEFAULT NULL,
  gdm_flg tinyint(1) DEFAULT NULL,
  hypothyroid_flg tinyint(1) DEFAULT NULL,
  normal_anomaly_scan_flg tinyint(1) DEFAULT NULL,
  mg_sulphate_flg tinyint(1) DEFAULT NULL,
  lmp_dt datetime DEFAULT NULL,
  edd_dt datetime DEFAULT NULL,
  last_steroid_dose_dt datetime DEFAULT NULL,
  gravidity_details TEXT DEFAULT NULL,
  parity_details TEXT DEFAULT NULL,
  abortion_details TEXT DEFAULT NULL,
  ectopic_details TEXT DEFAULT NULL,
  living_children_details TEXT DEFAULT NULL,
  died_details TEXT DEFAULT NULL,
  neonatal_death_details TEXT DEFAULT NULL,
  still_birth_details TEXT DEFAULT NULL,
  other_medical_conditions TEXT DEFAULT NULL,
  anaemia_medications TEXT DEFAULT NULL,
  pih_medications TEXT DEFAULT NULL,
  gdm_medications TEXT DEFAULT NULL,
  hypothyroid_medications TEXT DEFAULT NULL,
  hiv_medications TEXT DEFAULT NULL,
  hbsag_medications TEXT DEFAULT NULL,
  vdrl_medications TEXT DEFAULT NULL,
  an_steroid_details varchar(50) DEFAULT NULL,
  steroid_type varchar(50) DEFAULT NULL, 
  birth_place TEXT DEFAULT NULL,
  source_cd varchar(50) NOT NULL,
  etl_load_id int(11) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
 PRIMARY KEY (patient_mother_obstetric_key),
 UNIQUE KEY uk_patient_mother_obs(patient_key,hospital_key)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS healthscore_dw.dim_patient_birth_history;
CREATE TABLE healthscore_dw.dim_patient_birth_history (
  patient_birth_history_key  int(11) NOT NULL AUTO_INCREMENT,
  patient_key int(11) NOT NULL,
  hospital_key int(11) NOT NULL,
  ext_birth_doctor_staff_key int(11) DEFAULT NULL, 
  birth_doctor_staff_key int(11) DEFAULT NULL, 
  birth_pediatrician_staff_key int(11) DEFAULT NULL, 
  birth_ext_pediatrician_staff_key int(11) DEFAULT NULL, 
  labour_presentation_type_nm  varchar(1000) NULL,  
  membrane_rupture_duration_in_hrs  decimal(10,2) default null, 
  liquor_quality_type  varchar(1000) DEFAULT NULL,  
  liquor_quantity_type varchar(20) DEFAULT NULL,
  pv_exam_count int(11) DEFAULT NULL, 
  sepsis_risk_factors_nm varchar(1000) DEFAULT NULL,
  anesthesia_category_nm varchar(1000) DEFAULT NULL,
  delivery_mode_nm varchar(1000) DEFAULT NULL,
  oxytocin_flg tinyint(1) ,
  labour_onset_ts datetime,
  labour_indication_details varchar(1000) DEFAULT NULL,
  source_cd varchar(50) NOT NULL,
  etl_load_id int(11) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
 PRIMARY KEY (patient_birth_history_key),
 UNIQUE KEY uk_patient_birth_history(patient_key,hospital_key)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS healthscore_dw.dim_patient_birth_exam_history;
CREATE TABLE healthscore_dw.dim_patient_birth_exam_history (
  patient_birth_exam_key  int(11) NOT NULL AUTO_INCREMENT,
  patient_key int(11) NOT NULL,
  hospital_key int(11) NOT NULL,
  time_of_cord_clamping varchar(50) DEFAULT NULL,
  blood_gas_sample_type varchar(50) DEFAULT NULL,
  hips_anomaly varchar(50) DEFAULT NULL,
  cord_vessels_anomaly varchar(50) DEFAULT NULL,
  femoral_pulses_anomaly varchar(50) DEFAULT NULL,
  genitilia_anomaly varchar(50) DEFAULT NULL,
  red_reflex_anomaly varchar(50) DEFAULT NULL,
  back_spine_anomaly varchar(50) DEFAULT NULL,
  extremities_anomaly varchar(50) DEFAULT NULL,
  resusitation_desc varchar(5000) DEFAULT NULL,
  rs_desc varchar(1000) DEFAULT NULL,
  pa_desc varchar(1000) DEFAULT NULL,
  cvs_desc varchar(1000) DEFAULT NULL,
  cns_desc varchar(1000) DEFAULT NULL,
  congenital_anomalies_desc varchar(1000) DEFAULT NULL,
  comments varchar(1000) DEFAULT NULL,
  birth_diagnosis_nm varchar(1000) DEFAULT NULL,
  resusitation_type_nm varchar(1000) DEFAULT NULL,
  resusitation_duration_min int(11) DEFAULT NULL,
  regular_hr_by_min int(11) DEFAULT NULL,
  regular_resp_by_min int(11) DEFAULT NULL,
  regular_hr_by_sec int(11) DEFAULT NULL,
  regular_resp_by_sec int(11) DEFAULT NULL,
  apgar_1_min tinyint(1) DEFAULT NULL,
  apgar_5_min tinyint(1) DEFAULT NULL,
  apgar_10_min tinyint(1) DEFAULT NULL,
  hr_1_min tinyint(1) DEFAULT NULL,
  hr_5_min tinyint(1) DEFAULT NULL,
  hr_10_min tinyint(1) DEFAULT NULL,
  resp_1_min tinyint(1) DEFAULT NULL,
  resp_5_min tinyint(1) DEFAULT NULL,
  resp_10_min tinyint(1) DEFAULT NULL,
  muscle_1_min tinyint(1) DEFAULT NULL,
  muscle_5_min tinyint(1) DEFAULT NULL,
  muscle_10_min tinyint(1) DEFAULT NULL,
  reflex_1_min tinyint(1) DEFAULT NULL,
  reflex_5_min tinyint(1) DEFAULT NULL,
  reflex_10_min tinyint(1) DEFAULT NULL,
  color_1_min tinyint(1) DEFAULT NULL,
  color_5_min tinyint(1) DEFAULT NULL,
  color_10_min tinyint(1) DEFAULT NULL,
  dysmorphic_features_flg tinyint(1) DEFAULT NULL,
  anal_patency_flg tinyint(1) DEFAULT NULL,
  ng_tube_flg tinyint(1) DEFAULT NULL,
  cleft_lip_flg tinyint(1) DEFAULT NULL,
  parent_consent_flg tinyint(1) DEFAULT NULL,
  baby_shown_to_parents_flg tinyint(1) DEFAULT NULL,
  cord_abg_ph decimal(8,2) DEFAULT NULL,
  cord_abg_po2 decimal(8,2) DEFAULT NULL,
  cord_abg_pc02 decimal(8,2) DEFAULT NULL,
  cord_abg_hc03 decimal(8,2) DEFAULT NULL,
  cord_abg_be decimal(8,2) DEFAULT NULL,
  hr int(11) DEFAULT NULL,
  hc decimal(8,2) DEFAULT NULL,
  length int(11) DEFAULT NULL,
  spo2 decimal(8,2) DEFAULT NULL,
  temp decimal(8,2) DEFAULT NULL,
  source_cd varchar(50) NOT NULL,
  etl_load_id int(11) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
 PRIMARY KEY (patient_birth_exam_key),
 UNIQUE KEY uk_patient_birth_exam(patient_key,hospital_key)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

alter table healthscore_dw.fact_patient_visits modify COLUMN outcome_type MEDIUMTEXT;
alter table healthscore_dw.fact_patient_visits modify COLUMN  condition_at_discharge MEDIUMTEXT;

alter table  healthscore_dw.fact_patient_assessment_results modify column result_item_value varchar(2000);

DROP TABLE IF EXISTS healthscore_dw.fact_patient_careplan_execution_details;
CREATE TABLE healthscore_dw.fact_patient_careplan_execution_details (
  patient_careplan_execution_key bigint(20) NOT NULL AUTO_INCREMENT,
  patient_careplan_instruction_key bigint(20) NOT NULL ,
  patient_careplan_key int(11) not null,
  careplan_instruction_details_id bigint(20) NOT NULL,
  care_plan_instruction_id bigint(20) NOT NULL,
  careplan_instruction_master_key int(11) NOT NULL ,
  recorded_ts datetime,
  infusion_rate double DEFAULT NULL,
  input_output_volume double DEFAULT NULL,
  feed_route_nm varchar(100), 
  input_output_type_nm varchar(100), 
  input_output_type_measurement_ref_text varchar(45) ,
  input_output_type_category varchar(45),
  ventilator_mode_nm varchar(100),  
  ventilator_settings_nm varchar(100), 
  ventilator_uom_nm varchar(45), 
  ventilator_allowed_lower_limit decimal(10,2), 
  ventilator_allowed_upper_limit decimal(10,2), 
  ventilator_settings_value varchar(50), 
  source_cd varchar(50) NOT NULL,
  etl_load_id int(11) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
 PRIMARY KEY (patient_careplan_execution_key),
 UNIQUE KEY uk_patient_careplan_execution(careplan_instruction_details_id)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

 -- To be executed as of 19/04/2021 HS5-556 Online Consultation amounts not showing in reports chnages --
 ALTER TABLE healthscore_dw.dim_bill_items ADD COLUMN item_pseudo_unit_amt DECIMAL(10,2)  NULL DEFAULT 0 ;
 ALTER TABLE healthscore_dw.fact_patient_visitbillitems ADD COLUMN item_pseudo_unit_amt DECIMAL(10,2)  NULL DEFAULT 0 ;

-- To be executed as of 03/06/2021 HS5-478 changes
DROP TABLE IF EXISTS healthscore_dw.fact_patient_timeline_info;
CREATE TABLE healthscore_dw.fact_patient_timeline_info (
  patient_timeline_info_key int(11) NOT NULL AUTO_INCREMENT,
  patient_key int(11) NOT NULL,
  patient_visit_key int(11) NOT NULL,
  created_staff_key int(11) ,
  progress_timeline_id bigint(11) not null,
  timeline_info_type_cd varchar(100) NOT NULL,   --  note, event
  timeline_info_hashtag_category varchar(100) NULL,  
  timeline_info_desc varchar(4000), 
  patient_careplan_instruction_key bigint(20)  NULL ,
  patient_careplan_key int(11) null,
  careplan_instruction_master_key int(11)  NULL , 
  careplan_activity_milestone_flg tinyint(1) NULL,
  careplan_activity_status varchar(45),
  timeline_info_created_ts datetime,
  timeline_info_modified_ts datetime,
  active_flg tinyint(1) DEFAULT NULL,
  source_cd varchar(50) NOT NULL,
  etl_load_id int(11) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (patient_timeline_info_key),
  UNIQUE KEY uk_patient_timeline_info(patient_key,timeline_info_type_cd,progress_timeline_id)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

 DROP TABLE IF EXISTS healthscore_dw.dim_external_hospital_staff;
CREATE TABLE healthscore_dw.dim_external_hospital_staff (
  external_hospital_staff_key int(11) NOT NULL AUTO_INCREMENT,
  hospital_key int(11) NOT NULL ,
  ext_doctor_id int(11) NOT NULL,
  external_hospital_nm varchar(200) NOT NULL,
  external_doctor_nm varchar(100) DEFAULT NULL,  
  external_doctor_dept_nm  varchar(45) DEFAULT NULL, 
  email_id varchar(100) DEFAULT NULL,
  mobile_no varchar(45) DEFAULT NULL,
  country_cd varchar(6) DEFAULT NULL,
  active_flg tinyint(1) DEFAULT NULL,
  source_cd varchar(50) NOT NULL,
  etl_load_id int(11) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,	
  PRIMARY KEY (external_hospital_staff_key),
  UNIQUE KEY `udx_external_hospital` (`ext_doctor_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

ALTER TABLE healthscore_dw.fact_active_visits
ADD COLUMN critical_flg TINYINT(1) NULL DEFAULT 0;

ALTER TABLE `healthscore_dw`.`fact_patient_visits` 
CHANGE COLUMN `primary_doctor_staff_key` `primary_ext_doctor_staff_key` INT(11) NULL DEFAULT NULL , 
CHANGE COLUMN `reference_doctor_staff_key` `reference_ext_doctor_staff_key` INT(11) NULL DEFAULT NULL ;


-- to be executed as of 14-07-2021-- from below

ALTER TABLE healthscore_dw.fact_patient_assessments MODIFY health_assessment_scale_desc varchar(255);

-- Function to remove HTML Tags from text
 SET GLOBAL log_bin_trust_function_creators=1;
 use healthscore_dw;
 
DROP FUNCTION IF EXISTS fnStripTags;
DELIMITER |
CREATE FUNCTION healthscore_dw.fnStripTags( htmlRichText LONGTEXT )
RETURNS LONGTEXT
DETERMINISTIC 
BEGIN
  DECLARE iStart, iEnd, iLength int;
    WHILE Locate( '<', htmlRichText ) > 0 And Locate( '>', htmlRichText, Locate( '<', htmlRichText )) > 0 DO
      BEGIN
        SET iStart = Locate( '<', htmlRichText ), iEnd = Locate( '>', htmlRichText, Locate('<', htmlRichText ));
        SET iLength = ( iEnd - iStart) + 1;
        IF iLength > 0 THEN
          BEGIN
            SET htmlRichText = Insert( htmlRichText, iStart, iLength, ' ');
          END;
        END IF;
      END;
    END WHILE;
    RETURN htmlRichText;
END;
|
DELIMITER ;


-- 21/Aug/21


DROP TABLE IF EXISTS healthscore_dw.fact_patient_app_payment_details;
CREATE TABLE healthscore_dw.fact_patient_app_payment_details (
  patient_app_payment_key int(11) NOT NULL AUTO_INCREMENT,
  hospital_key int(11) NOT NULL ,
  patient_key int(11) NOT NULL,
  payment_method_cd varchar(100) NOT NULL,
  razorpay_payment_id varchar(100) NOT NULL, 
  payment_created_ts datetime, 
  payment_modified_ts datetime, 
  hospital_bill_amt DECIMAL(10,2), 
  convenience_amt DECIMAL(10,2), 
  razorpay_fee_including_tax_amt DECIMAL(10,2), 
  razorpay_fee_tax_amt DECIMAL(10,2),
  source_cd varchar(50) NOT NULL,
  etl_load_id int(11) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,	
  PRIMARY KEY (patient_app_payment_key),
  UNIQUE KEY `uk_fact_patient_app_payment` (`razorpay_payment_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS healthscore_dw.fact_patient_app_statistics;
CREATE TABLE healthscore_dw.fact_patient_app_statistics (
  patient_app_statistics_key int(11) NOT NULL AUTO_INCREMENT,
  hospital_key int(11) NOT NULL ,
  preferred_language varchar(100), 
  registered_date datetime,
  total_patient_count int(11),
  subscribed_patient_count int(11),
  registered_patient_count int(11),
  source_cd varchar(50) NOT NULL,
  etl_load_id int(11) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,	
  PRIMARY KEY (patient_app_statistics_key),
  UNIQUE KEY `uk_fact_patient_app_statistics` (hospital_key,preferred_language,registered_date)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

-- to be executed as of 17-09-2021 from below

ALTER TABLE healthscore_dw.fact_patient_assessments
ADD COLUMN assessment_scale_master_id bigint(50) not null default 0,
ADD COLUMN assessment_scale_item_master_id bigint(50) NOT NULL default 0;


-- to be executed as of 20-09-2021 from below

 DROP TABLE IF EXISTS healthscore_dw.fact_patient_assessments;
 CREATE TABLE healthscore_dw.fact_patient_assessments(
  patient_assmt_key int(11) NOT NULL AUTO_INCREMENT,
  patient_key int(11) NOT NULL,
  visit_hospital_key int(11) DEFAULT NULL,
  patient_visit_key int(11) default null,
  patient_assessment_id bigint(50) not null default 0, 
  assessment_scale_master_id bigint(50) not null default 0, 
  assessment_scale_desc varchar(255) NOT NULL,
  hospital_dept_nm varchar(255) NOT NULL, 
  assessed_date_key date not null,
  assessed_time_key time not null,
  assessed_ts datetime not null,
  visit_assessment_status_flg TINYINT(1) default null,
  deactivation_comment varchar(255) null,
  active_flg TINYINT(1) default null,
  source_cd varchar(50) NOT NULL,
  etl_load_id int(11) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (patient_assmt_key),
  UNIQUE uk_patient_assessments_key(source_cd,patient_assessment_id)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;


 DROP TABLE IF EXISTS healthscore_dw.fact_patient_assessment_results;
 CREATE TABLE healthscore_dw.fact_patient_assessment_results(
  patient_assmt_result_key int(11) NOT NULL AUTO_INCREMENT,
  patient_assmt_key int(11) NOT NULL,  
  patient_assessment_result_id bigint(50) NOT NULL default 0, 
  assessment_result_item_master_id bigint(50) NOT NULL default 0, 
  result_item_display_txt varchar(100),
  result_item_value varchar(2000),  
  result_item_ref_range_txt varchar(1000),
  result_item_row_no int(11),
  result_item_column_no int(11),
  result_item_min_value decimal(10,2) DEFAULT NULL,
  result_item_max_value decimal(10,2) DEFAULT NULL, 
  active_flg TINYINT(1) default null,
  source_cd varchar(50) NOT NULL,
  etl_load_id int(11) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (patient_assmt_result_key),
  UNIQUE uk_patient_assmt_result_key(source_cd,patient_assessment_result_id)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;
 
 
ALTER TABLE  healthscore_dw.fact_patient_visit_advice CHANGE COLUMN advice_desc advice_desc MEDIUMTEXT NULL DEFAULT NULL;


-- to be executed as of 10-01-2022 from below 
ALTER TABLE  healthscore_dw.dim_patient 
DROP COLUMN contact_email_id,
DROP COLUMN contact_addr_line1,
DROP COLUMN contact_addr_line2,
DROP COLUMN contact_home_phone_num,
DROP COLUMN contact_mobile_phone_num,
DROP COLUMN patient_alternate_phone_num,
DROP COLUMN patient_emerg_contact_nm,
DROP COLUMN patient_emerg_contact_num;


DROP TABLE IF EXISTS healthscore_dw.fact_consultant_appointment_schedule;
 CREATE TABLE healthscore_dw.fact_consultant_appointment_schedule (
  consultant_schedule_key int(11) NOT NULL AUTO_INCREMENT, 
  hospital_key bigint(50) DEFAULT NULL,
  consulting_staff_key int(11) NOT NULL,
  schedule_date_key DATE not null,
  schedule_start_time_key time NOT NULL,
  schedule_end_time_key time DEFAULT NULL,
  consultant_schedule_id int(11) NOT NULL,
  duration int(11) DEFAULT NULL, 
  active_flg TINYINT(1) null,
  timeslot_usage_limit int(11),
  timeslot_used_cnt   int(11),
  schedule_created_ts datetime NOT NULL,
  schedule_modified_ts datetime NULL,
  source_cd varchar(50) NOT NULL,
  etl_load_id int(11) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (consultant_schedule_key),
  UNIQUE uk_consultant_schedule_key(hospital_key,consultant_schedule_id)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS healthscore_dw.fact_patient_appointments;
 CREATE TABLE healthscore_dw.fact_patient_appointments (
  patient_appt_key int(11) NOT NULL AUTO_INCREMENT,
  patient_key int(11) NOT NULL,
  consultant_schedule_key int(11) NOT NULL,
  hospital_key bigint(50) DEFAULT NULL,
  patient_appointment_id bigint(50) NOT NULL,
  schedule_status  varchar(255) NOT NULL, -- requested, confirmed, cancelled
  visit_type varchar(255) ,
  contact_type varchar(255) ,
  appointment_status varchar(255), -- no show, fulfilled, cancelled
  appointment_created_ts datetime NOT NULL,
  appointment_modified_ts datetime,
  patient_visit_key int(11) , 
  bill_item_key int(11) , 
  source_cd varchar(50) NOT NULL,
  etl_load_id int(11) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (patient_appt_key),
  UNIQUE uk_patient_appointments_key(hospital_key,patient_appointment_id)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

 
-- 22 mar 22
ALTER TABLE healthscore_dw.dim_patient_documents ADD COLUMN source_cd varchar(45) DEFAULT NULL;
ALTER TABLE healthscore_dw.dim_patient_documents ADD COLUMN updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE healthscore_dw.dim_patient_documents ADD COLUMN published_ts datetime DEFAULT null;
ALTER TABLE healthscore_dw.dim_patient_documents ADD COLUMN published_staff_key int(11) DEFAULT NULL;

drop TABLE if exists healthscore_dw.dim_content;
 CREATE TABLE healthscore_dw.dim_content (
  content_key int(11) NOT NULL AUTO_INCREMENT,
  hospital_key int(11) NOT NULL,
  shared_content_id int(11) NOT NULL,
  content_url varchar(1000) NOT NULL,
  source_cd varchar(45) NOT NULL,
  etl_load_id int(11) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (content_key),
  UNIQUE KEY uk_content_key(hospital_key, shared_content_id)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS healthscore_dw.fact_content_info;
CREATE TABLE healthscore_dw.fact_content_info
(
  content_info_key int(11) NOT NULL AUTO_INCREMENT,
  patient_key int(11) NOT NULL,
  hospital_key int(11) NOT NULL,
  content_key int(11) NOT NULL,
  viewed_ts datetime,
  viewed_date_key date NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  etl_load_id int(11) NOT NULL,
  source_cd varchar(20) NOT NULL,
  PRIMARY KEY (content_info_key),
  unique key uk_content_info_key(patient_key,hospital_key,content_key)
)ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;


ALTER TABLE  healthscore_dw.fact_patient_visitbillitems ADD COLUMN (payment_last_cd varchar(45),payment_approval_cd varchar(45));

-- apr 18 2022

DROP TABLE if exists healthscore_dw.dim_product;
 CREATE TABLE healthscore_dw.dim_product (
  product_key int(11) NOT NULL AUTO_INCREMENT,
  hospital_key int(11) NOT NULL,
  product_id int(11) NOT NULL,
  product_cd varchar(45) NOT NULL,
  product_nm varchar(1000) ,
  product_generic_nm varchar(1000) ,
  product_hsn_cd varchar(45),
  product_schedule_type_cd  varchar(45),
  product_brand_nm varchar(255),
  product_category_nm varchar(255),
  tax_type_nm varchar(45),
  tax_value_in_per decimal(6,3),
  source_cd varchar(45) NOT NULL,
  etl_load_id int(11) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (product_key),
  UNIQUE KEY uk_product_key(hospital_key, product_id)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

DROP TABLE if exists healthscore_dw.dim_vendor;
 CREATE TABLE healthscore_dw.dim_vendor (
  vendor_key int(11) NOT NULL AUTO_INCREMENT,
  hospital_key int(11) NOT NULL,
  vendor_id int(11) NOT NULL,
  vendor_nm varchar(1000) ,
  vendor_desc  varchar(1000),
  source_cd varchar(45) NOT NULL,
  active_flg tinyint(1) NOT NULL DEFAULT 1,
  etl_load_id int(11) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (vendor_key),
  UNIQUE KEY (hospital_key, vendor_id)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

DROP TABLE if exists healthscore_dw.dim_store;
 CREATE TABLE healthscore_dw.dim_store (
  store_key int(11) NOT NULL AUTO_INCREMENT,
  hospital_key int(11) NOT NULL,
  store_id int(11) NOT NULL,
  store_cd varchar(45),
  store_nm varchar(1000) ,
  main_store_flg tinyint(1),
  active_flg tinyint(1) NOT NULL DEFAULT 1,
  allow_direct_billing_flg tinyint(1) NOT NULL DEFAULT 0,
  source_cd varchar(45) NOT NULL,
  etl_load_id int(11) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (store_key),
  UNIQUE KEY uk_store_key(hospital_key, store_id)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

DROP TABLE if exists healthscore_dw.dim_product_batch;
 CREATE TABLE healthscore_dw.dim_product_batch (
  product_batch_key int(11) NOT NULL AUTO_INCREMENT,
  hospital_key int(11) NOT NULL,
  product_key int(11) NOT NULL,  
  stock_batch_no varchar(45) NOT NULL,
  mrp decimal(10,2),
  selling_price decimal(10,2),
  expiry_date_key date,
  created_date_key date,
  source_cd varchar(45) NOT NULL,
  etl_load_id int(11) NOT NULL,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (product_batch_key), 
  UNIQUE KEY uk_product_batch_no_key(product_key, stock_batch_no)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS healthscore_dw.fact_daily_stock_transactions;
CREATE TABLE healthscore_dw.fact_daily_stock_transactions
(
  stock_transaction_key bigint(11) NOT NULL AUTO_INCREMENT,
  transaction_date_key datetime NOT NULL,
  hospital_key int(11) NOT NULL,
  product_batch_key int(11) NOT NULL,
  store_key int(11) NOT NULL,
  stock_transaction_id int(11) NOT NULL,
  transaction_type_cd varchar(10) NOT NULL ,
  transaction_type_nm varchar(45) ,
  adjustment_status_cd varchar(45) ,
  transaction_qty int(11) NOT NULL DEFAULT 0, 
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  source_cd varchar(45) NOT NULL,
  etl_load_id int(11) NOT NULL,
  PRIMARY KEY (stock_transaction_key),
  unique key uk_stock_transaction_key(hospital_key,stock_transaction_id)
)ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS healthscore_dw.fact_daily_stock_snapshot;
CREATE TABLE healthscore_dw.fact_daily_stock_snapshot
(
  daily_stock_snapshot_key int(11) NOT NULL AUTO_INCREMENT,
  as_of_date_key datetime NOT NULL,
  hospital_key int(11) NOT NULL,
  product_batch_key int(11) NOT NULL,
  store_key int(11) NOT NULL,
  opening_stock_qty int(11) NOT NULL DEFAULT 0, -- previous day closing stock qty
  new_qty int(11) NOT NULL DEFAULT 0, -- or purchased, indented, or added
  sold_qty int(11) NOT NULL DEFAULT 0,  -- sold -- negative number
  return_qty int(11) NOT NULL DEFAULT 0, -- returned from the store to mainstore/vendor -- negative number
  used_qty int(11) NOT NULL DEFAULT 0,  --  used -- negative number
  expired_qty int(11) NOT NULL DEFAULT 0, -- expired  -- negative number
  lost_qty int(11) NOT NULL DEFAULT 0,  --  lost  -- negative number
  closing_stock_qty int(11) NOT NULL DEFAULT 0,  -- current available qty
  opening_stock_cost_amt decimal(10,2) NOT NULL DEFAULT 0.0, -- previous day closing stock amt
  new_cost_amt decimal(10,2) NOT NULL DEFAULT 0.0, -- or purchased, indented, or added
  sold_cost_amt decimal(10,2) NOT NULL DEFAULT 0.0,  -- sold -- negative number
  return_cost_amt decimal(10,2) NOT NULL DEFAULT 0.0, -- returned from the store to mainstore/vendor -- negative number
  used_cost_amt decimal(10,2) NOT NULL DEFAULT 0.0,  --  used -- negative number
  expired_cost_amt decimal(10,2) NOT NULL DEFAULT 0.0, -- expired  -- negative number
  lost_cost_amt decimal(10,2) NOT NULL DEFAULT 0.0,  --  lost  -- negative number
  closing_stock_cost_amt decimal(10,2) NOT NULL DEFAULT 0.0,  -- current available stock in amount
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  source_cd varchar(45) NOT NULL,
  etl_load_id int(11) NOT NULL,
  PRIMARY KEY (daily_stock_snapshot_key),
  unique key uk_daily_stock_snapshot (as_of_date_key,hospital_key,product_batch_key,store_key)
)ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS healthscore_dw.fact_purchase_orders;
CREATE TABLE healthscore_dw.fact_purchase_orders
(
  purchase_order_key bigint(20) NOT NULL AUTO_INCREMENT,
  purchase_order_date_key date NOT NULL,
  hospital_key int(11) NOT NULL,
  vendor_key int(11) NOT NULL,
  store_key int(11) NOT NULL,
  purchase_order_id bigint(20) NOT NULL ,
  purchase_order_cd varchar(255) DEFAULT NULL,
  purchase_order_amt double DEFAULT NULL,
  purchase_order_status_id int(11) DEFAULT NULL,
  active_flg tinyint(1) DEFAULT '1',
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  source_cd varchar(45) NOT NULL,
  etl_load_id int(11) NOT NULL,
  PRIMARY KEY (purchase_order_key),
  unique key uk_fact_purchase_order (hospital_key,purchase_order_id)
  )ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

  DROP TABLE IF EXISTS healthscore_dw.fact_purchase_order_invoices;
CREATE TABLE healthscore_dw.fact_purchase_order_invoices
(
  purchase_order_invoice_key bigint(20) NOT NULL AUTO_INCREMENT,
  purchase_order_key bigint(20) NOT NULL,
  invoice_date_key date NOT NULL,
  hospital_key int(11) NOT NULL,
  product_batch_key int(11) NOT NULL,
  invoice_item_id bigint(20) NOT NULL,
  purchase_order_invoice_id bigint(20) NOT NULL,
  purchase_order_invoice_no varchar(255) DEFAULT NULL,
  invoice_item_qty double DEFAULT NULL, 
  invoice_item_batch_no varchar(255) DEFAULT NULL,
  invoice_item_expiry_ts datetime DEFAULT NULL,
  invoice_item_mrp_amt double DEFAULT NULL,
  invoice_item_tax_amt double DEFAULT NULL,
  invoice_item_unit_cost_amt double DEFAULT NULL,
  invoice_item_amt double DEFAULT NULL, 
  discount_amount double DEFAULT NULL,
  invoice_item_return_qty double NOT NULL DEFAULT '0',
  invoice_item_return_dt date DEFAULT NULL, 
  active_flg tinyint(1) DEFAULT '1', 
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  source_cd varchar(45) NOT NULL,
  etl_load_id int(11) NOT NULL,
  PRIMARY KEY (purchase_order_invoice_key),
  unique key uk_fact_purchase_order_invoices (hospital_key,invoice_item_id)
)ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS healthscore_dw.dim_participant;
CREATE TABLE healthscore_dw.dim_participant
(
  participant_key bigint(20) NOT NULL AUTO_INCREMENT,
  participant_id bigint(20) NOT NULL,
  hospital_key int(11) NOT NULL,
  participant_type_id int(11) NOT NULL,
  participant_type_cd varchar(255) NOT NULL,
  participant_type_nm varchar(400) DEFAULT NULL,
  participant_uuid varchar(255) NOT NULL,
  participant_unique_cd varchar(255) not null,
  active_flg tinyint(1), 
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  source_cd varchar(45) NOT NULL,
  etl_load_id int(11) NOT NULL,
  PRIMARY KEY (participant_key),
  unique key uk_dim_participant_id (participant_id, hospital_key),
  unique key uk_dim_participant_unique_cd (participant_unique_cd)
)ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS healthscore_dw.dim_meeting;
CREATE TABLE healthscore_dw.dim_meeting
(
  meeting_key bigint(20) NOT NULL AUTO_INCREMENT,
  hospital_key int(11) NOT NULL,
  meeting_id bigint(20) NOT NULL,
  meeting_uuid varchar(100),
  meeting_nm varchar(400),
  appointment_id bigint(20) NOT NULL,
  meeting_status_id bigint(11),
  meeting_status_cd varchar(255),
  meeting_status_nm varchar(400),
  meeting_scheduled_ts datetime,
  meeting_created_ts datetime,
  bbb_meeting_id varchar(255),
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  active_flg tinyint(1), 
  source_cd varchar(45) NOT NULL,
  etl_load_id int(11) NOT NULL,
  PRIMARY KEY (meeting_key),
  unique key uk_dim_meeting (hospital_key, meeting_id)
)ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS healthscore_dw.fact_meeting_participant_details;
CREATE TABLE healthscore_dw.fact_meeting_participant_details
(
  meeting_participant_key bigint(20) NOT NULL AUTO_INCREMENT,
  meeting_key int(11) NOT NULL,
  hospital_key int(11) NOT NULL,
  participant_key int(11) NOT NULL,
  meeting_start_ts datetime , 
  meeting_end_ts datetime ,
  first_joined_ts datetime ,
  last_left_ts datetime,
  joined_flg tinyint(1),
  meeting_record_flg tinyint(1),
  recording_notification_sent_flg tinyint(1),
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  active_flg tinyint(1), 
  source_cd varchar(45) NOT NULL,
  etl_load_id int(11) NOT NULL,
  PRIMARY KEY (meeting_participant_key),
  unique key uk_fact_meeting_participant (meeting_key, hospital_key, participant_key)
)ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS healthscore_dw.fact_meeting_feedback;
CREATE TABLE healthscore_dw.fact_meeting_feedback
(
  meeting_feedback_key bigint(20) NOT NULL AUTO_INCREMENT,
  meeting_participant_key int(11) NOT NULL,
  feedback_id bigint(20) NOT NULL,
  rating TINYINT UNSIGNED NOT NULL,
  issue_type varchar(400),
  comments varchar(2000),
  created_by varchar(45),
  modified_by varchar(45),
  created_ts datetime,
  modified_ts datetime,
  inserted_ts datetime DEFAULT CURRENT_TIMESTAMP,
  updated_ts TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  active_flg tinyint(1), 
  source_cd varchar(45) NOT NULL,
  etl_load_id int(11) NOT NULL,
  PRIMARY KEY (meeting_feedback_key),
  unique key uk_meeting_feedback (meeting_participant_key, feedback_id)
)ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;
