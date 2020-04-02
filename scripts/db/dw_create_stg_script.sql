-- drop database IF EXISTS healthscore_stg;
-- create database healthscore_stg;
use healthscore_stg;
DROP TABLE IF EXISTS hs_bill_category_master; 
CREATE TABLE hs_bill_category_master (
  bill_item_category_id bigint(50) NOT NULL,
  hospital_id int(11) NOT NULL DEFAULT '1',
  bill_item_category_cd varchar(10) DEFAULT NULL,
  bill_item_category_nm varchar(100) DEFAULT NULL,
  bill_item_category_desc varchar(1000) DEFAULT NULL,
  category_group_nm varchar(100) DEFAULT NULL,
  bill_admin_role_cd varchar(10) DEFAULT NULL,
  active_flg tinyint(4) NOT NULL DEFAULT '1',
  created_ts timestamp NOT NULL,
  created_by varchar(45) NOT NULL,
  modified_by varchar(45) DEFAULT NULL,
  modified_ts timestamp NULL DEFAULT NULL,
  default_sac_cd varchar(45) DEFAULT NULL,
  PRIMARY KEY (bill_item_category_id),
  UNIQUE KEY hospital_id_UNIQUE (hospital_id,bill_item_category_cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Bill Categories specific to the hospital';


DROP TABLE IF EXISTS hs_bill_items_master; 
CREATE TABLE hs_bill_items_master (
  bill_item_id bigint(50) NOT NULL ,
  hospital_id int(11) NOT NULL DEFAULT '1',
  bill_category_id bigint(50) NOT NULL,
  citizenship_type_id int(11) DEFAULT NULL,
  lab_category_cd varchar(45) DEFAULT NULL,
  bill_item_cd varchar(45) NOT NULL,
  bill_item_nm varchar(400) NOT NULL,
  bill_item_amt decimal(10,2) NOT NULL,
  active_flg tinyint(4) NOT NULL DEFAULT '1',
  editable_flg tinyint(4) NOT NULL DEFAULT '0',
  transaction_type_cd varchar(10) NOT NULL DEFAULT 'DR',
  effective_from_ts timestamp NULL DEFAULT NULL,
  effective_to_ts timestamp NULL DEFAULT NULL,
  tax_type_id int(11) DEFAULT NULL,
  inventory_flg tinyint(4) DEFAULT '0',
  hsn_code varchar(45) DEFAULT NULL,
  sac_code varchar(45) DEFAULT NULL,
  rate_category_id int(11) NOT NULL,
  default_flg tinyint(1) DEFAULT NULL,
  package_flg tinyint(1) DEFAULT '0',
  created_ts datetime NOT NULL,
  created_by varchar(45) NOT NULL,
  modified_by varchar(45) DEFAULT NULL,
  modified_ts timestamp NULL DEFAULT NULL,
  concession_flg tinyint(1) DEFAULT '0',
  concession_pct decimal(10,2) DEFAULT NULL,
  inv_package_flg tinyint(1) DEFAULT '0',
  display_seq_no int(11) DEFAULT NULL,
  PRIMARY KEY (bill_item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Standard Bill items specific to the hospital';

DROP TABLE IF EXISTS hs_bill_items_package_map_master; 
CREATE TABLE hs_bill_items_package_map_master (
  bill_items_package_master_id bigint(15) NOT NULL,
  package_bill_item_code varchar(45) NOT NULL,
  sub_bill_item_code varchar(45) DEFAULT NULL,
  effective_from_ts timestamp NOT NULL,
  created_ts datetime NOT NULL,
  created_by varchar(45) NOT NULL,
  modified_ts timestamp NULL DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  item_seq_nbr int(15) DEFAULT NULL,
  effective_to_ts timestamp NULL DEFAULT NULL,
  PRIMARY KEY (bill_items_package_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS hs_consultant_charges_master;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE hs_consultant_charges_master (
  con_charge_id bigint(50) NOT NULL,
  hospital_id int(11) NOT NULL DEFAULT '1',
  hospital_staff_id bigint(50) NOT NULL,
  citizenship_type_id int(11) DEFAULT NULL,
  consultation_type_id int(11) DEFAULT NULL,
  default_price decimal(10,2) DEFAULT NULL,
  active_flg tinyint(4) NOT NULL DEFAULT '1',
  editable_flg tinyint(4) NOT NULL DEFAULT '0',
  effective_from_ts timestamp NULL DEFAULT NULL,
  effective_to_ts timestamp NULL DEFAULT NULL,
  tax_type_id int(11) DEFAULT NULL,
  sac_code varchar(45) DEFAULT NULL,
  rate_category_id int(11) NOT NULL,
  created_ts timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by varchar(45) NOT NULL,
  modified_by varchar(45) DEFAULT NULL,
  modified_ts timestamp NULL DEFAULT NULL,
  concession_flg tinyint(1) DEFAULT '0',
  concession_pct decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (con_charge_id),
  UNIQUE KEY uk_consultant_charges (hospital_id,hospital_staff_id,citizenship_type_id,consultation_type_id,effective_from_ts)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Consultants charges specific to the hospital';

DROP TABLE IF EXISTS hs_consultation_type_master;
CREATE TABLE hs_consultation_type_master (
  consultation_type_id int(11) NOT NULL,
  hospital_id int(11) NOT NULL DEFAULT '1',
  consultation_type_nm varchar(400) DEFAULT NULL,
  start_day int(11) DEFAULT NULL,
  end_day int(11) DEFAULT NULL,
  bill_item_category_id int(11) DEFAULT NULL,
  active_flg tinyint(4) NOT NULL DEFAULT '1',
  created_ts timestamp NULL DEFAULT NULL,
  created_by varchar(45) NOT NULL,
  modified_by varchar(45) DEFAULT NULL,
  modified_ts timestamp NULL DEFAULT NULL,
  default_sac_cd varchar(45) DEFAULT NULL,
  default_flg tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (consultation_type_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Consultation types specific to the hospital';


DROP TABLE IF EXISTS hs_health_assessment_scale_master; 
CREATE TABLE hs_health_assessment_scale_master (
  health_assessment_scale_id int(11) NOT NULL ,
  health_assessment_scale_desc varchar(45) DEFAULT NULL,
  dept_id int(11) NOT NULL,
  report_type varchar(45) DEFAULT NULL,
  active_flg tinyint(1) DEFAULT '1',
  created_by varchar(45) DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  created_ts datetime DEFAULT NULL,
  modified_ts datetime DEFAULT NULL,
  assessment_scale_type_id int(11) DEFAULT NULL,
  display_seq_no int(11) DEFAULT NULL,
  hospital_id int(11) DEFAULT NULL,
  PRIMARY KEY (health_assessment_scale_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 

DROP TABLE IF EXISTS hs_health_assessment_scale_result_items_master; 
CREATE TABLE hs_health_assessment_scale_result_items_master (
  assessment_scale_result_item_id bigint(11) NOT NULL,
  ref_component_id bigint(11) DEFAULT NULL,
  ref_display_txt varchar(100) DEFAULT NULL,
  component_reference_range_txt varchar(1000) DEFAULT NULL,
  result_type_id int(11) DEFAULT NULL,
  health_assessment_scale_id int(11) NOT NULL,
  default_value_txt varchar(1000) DEFAULT NULL,
  sequence_no int(11) DEFAULT NULL,
  sub_items varchar(500) DEFAULT NULL,
  active_flg tinyint(1) DEFAULT '1',
  created_by varchar(45) DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  created_ts datetime DEFAULT NULL,
  modified_ts datetime DEFAULT NULL,
  PRIMARY KEY (assessment_scale_result_item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 


DROP TABLE IF EXISTS hs_hospital_master; 
CREATE TABLE hs_hospital_master (
  hospital_id int(11) NOT NULL,
  hospital_nm varchar(400) DEFAULT NULL,
  hs_hospital_cd_guid varchar(45) DEFAULT NULL,
  hospital_addr_line1 varchar(45) DEFAULT NULL,
  hospital_addr_line2 varchar(45) DEFAULT NULL,
  hospital_location_id int(11) DEFAULT NULL,
  hospital_phone_num varchar(45) DEFAULT NULL,
  hospital_email_addr varchar(100) DEFAULT NULL,
  hospital_sub_title varchar(150) DEFAULT NULL,
  hospital_logo varchar(400) DEFAULT NULL,
  hospital_lab_nm varchar(400) DEFAULT NULL,
  hospital_lab_sub_title varchar(150) DEFAULT NULL,
  hospital_lab_phone_num varchar(45) DEFAULT NULL,
  active_flg tinyint(1) NOT NULL DEFAULT '1',
  main_branch_id int(11) DEFAULT '0',
  setting_flg tinyint(1) NOT NULL DEFAULT '0',
  is_default_color_category_flg tinyint(1) DEFAULT '1',
  hospital_tax_id varchar(100) DEFAULT NULL,
  created_ts datetime DEFAULT NULL,
  created_by varchar(45) DEFAULT NULL,
  modified_ts datetime DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  hospital_pharmacy_nm varchar(400) DEFAULT NULL,
  hospital_pharmacy_license varchar(200) DEFAULT NULL,
  hospital_pharmacy_gst varchar(200) DEFAULT NULL,
  hospital_pharmacy_return_period_end_date date DEFAULT NULL,
  default_checkin_type_id int(11) NOT NULL,
  tally_account_nm varchar(250) DEFAULT NULL,
  convenience_fee decimal(10,2) DEFAULT NULL,
  convenience_pct_flg tinyint(1) DEFAULT '0',
  razorpay_account_id varchar(100),
  patient_app_flg tinyint(1),
  PRIMARY KEY (hospital_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS hs_hospital_package_master;
CREATE TABLE hs_hospital_package_master (
  package_master_id int(11) NOT NULL,
  hospital_id int(11) DEFAULT NULL,
  bill_item_cd varchar(45) DEFAULT NULL,
  start_fromday_package_take_flg tinyint(1) DEFAULT NULL,
  no_of_days int(11) DEFAULT NULL,
  multi_visit_flg tinyint(1) DEFAULT NULL,
  effective_from_ts timestamp NULL DEFAULT NULL,
  effective_to_ts timestamp NULL DEFAULT NULL,
  active_flg tinyint(1) DEFAULT NULL,
  created_by varchar(45) DEFAULT NULL,
  created_ts datetime DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  modified_ts datetime DEFAULT NULL,
  inventory_flg int(11) DEFAULT '0',
  patient_app_subscription_flg TINYINT(1),
  PRIMARY KEY (package_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS hs_hospital_package_mapped_items_master;
CREATE TABLE hs_hospital_package_mapped_items_master (
  package_mapped_item_id int(11) NOT NULL,
  package_master_id int(11) DEFAULT NULL,
  bill_item_cd varchar(45) DEFAULT NULL,
  total_count int(11) DEFAULT NULL,
  active_flg tinyint(1) DEFAULT NULL,
  created_by varchar(45) DEFAULT NULL,
  created_ts datetime DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  modified_ts datetime DEFAULT NULL,
  consultation_type_id int(11) DEFAULT NULL,
  hospital_staff_id int(11) DEFAULT NULL,
  product_master_id int(11) DEFAULT '0',
  PRIMARY KEY (package_mapped_item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS hs_hospital_patient_color_category_master; 
CREATE TABLE hs_hospital_patient_color_category_master (
  color_category_id bigint(20) NOT NULL ,
  color_category_code varchar(10) DEFAULT NULL,
  is_default_flg tinyint(1) NOT NULL,
  is_default_color_category_flg tinyint(1) NOT NULL,
  color_category_nm varchar(50) NOT NULL,
  color_hex_code_desc varchar(10) NOT NULL,
  hospital_id int(11) NOT NULL,
  active_flg tinyint(1) DEFAULT '1',
  created_ts timestamp NOT NULL,
  created_by varchar(45) NOT NULL,
  modified_by varchar(45) DEFAULT NULL,
  modified_ts timestamp NULL DEFAULT NULL,
  PRIMARY KEY (color_category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Maps color category for a patient';

DROP TABLE IF EXISTS hs_ref_action_category_master; 
CREATE TABLE hs_ref_action_category_master (
  action_category_id int(11) NOT NULL,
  action_category_ref_component_id bigint(50) NOT NULL,
  action_category_ref_display_txt varchar(45) NOT NULL,
  created_ts timestamp NULL DEFAULT NULL,
  modified_ts timestamp NULL DEFAULT NULL,
  created_by varchar(45) DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  active_flg tinyint(4) DEFAULT '1',
  PRIMARY KEY (action_category_ref_component_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 

DROP TABLE IF EXISTS hs_ref_lab_category_master; 
CREATE TABLE hs_ref_lab_category_master (
  lab_category_id int(11) NOT NULL,
  lab_category_cd varchar(3) DEFAULT NULL,
  lab_category_desc varchar(45) DEFAULT NULL,
  category_seq_no int(11) DEFAULT NULL,
  active_flg tinyint(1) DEFAULT '1',
  created_by varchar(45) DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  created_ts datetime DEFAULT NULL,
  modified_ts datetime DEFAULT NULL,
  lab_category_signature varchar(50) DEFAULT NULL,
  technician_flg tinyint(1) DEFAULT NULL,
  PRIMARY KEY (lab_category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 

DROP TABLE IF EXISTS hs_ref_lab_result_items_master; 
CREATE TABLE hs_ref_lab_result_items_master (
  lab_result_item_id bigint(11) NOT NULL ,
  ref_component_id bigint(11) DEFAULT NULL,
  ref_display_txt varchar(100) DEFAULT NULL,
  component_reference_range_txt varchar(1000) DEFAULT NULL,
  result_type_id int(11) DEFAULT NULL,
  default_value_txt varchar(1000) DEFAULT NULL,
  active_flg tinyint(1) DEFAULT '1',
  created_by varchar(45) DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  created_ts datetime DEFAULT NULL,
  modified_ts datetime DEFAULT NULL,
  hospital_id int(11) NOT NULL,
  PRIMARY KEY (lab_result_item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 

DROP TABLE IF EXISTS hs_ref_order_category_master;
CREATE TABLE hs_ref_order_category_master (
  order_category_ref_component_id bigint(50) NOT NULL,
  order_category_ref_display_txt varchar(45) NOT NULL,
  module_cd varchar(6) DEFAULT NULL,
  created_ts timestamp NULL DEFAULT NULL,
  modified_ts timestamp NULL DEFAULT NULL,
  created_by varchar(45) DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  active_flg tinyint(4) DEFAULT '1',
  PRIMARY KEY (order_category_ref_component_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 

DROP TABLE IF EXISTS hs_ref_order_result_items_master; 
CREATE TABLE hs_ref_order_result_items_master (
  order_result_item_id int(11) NOT NULL ,
  order_category_ref_component_id bigint(11) NOT NULL,
  order_result_item_nm varchar(45) NOT NULL,
  bill_item_cd varchar(45) NOT NULL,
  order_result_item_type_id int(11) NOT NULL,
  order_result_item_default_txt varchar(4000) DEFAULT NULL,
  hospital_id int(11) NOT NULL,
  active_flg tinyint(1) NOT NULL DEFAULT '1',
  created_ts datetime DEFAULT NULL,
  created_by varchar(45) DEFAULT NULL,
  modified_ts datetime DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  PRIMARY KEY (order_result_item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 


DROP TABLE IF EXISTS hs_ref_vitals_master; 
CREATE TABLE hs_ref_vitals_master (
  vital_ref_component_id bigint(50) NOT NULL,
  vital_ref_display_txt varchar(255) DEFAULT NULL,
  measurementunit_ref_component_id bigint(50) NOT NULL,
  measurementunit_ref_display_txt varchar(255) DEFAULT NULL,
  active_flg tinyint(1) DEFAULT '1',
  default_flg tinyint(1) DEFAULT '1',
  created_by varchar(45) DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  created_ts datetime DEFAULT CURRENT_TIMESTAMP,
  modified_ts datetime DEFAULT NULL,
  hex_color_cd varchar(10) DEFAULT NULL,
  y_axis_start_value int(11) DEFAULT NULL,
  y_axis_end_value int(11) DEFAULT NULL,
  y_axis_no_ticks int(11) DEFAULT NULL,
  normal_value decimal(10,2) DEFAULT NULL,
  sequence_nbr int(11) DEFAULT NULL,
  min_threshold int(10) DEFAULT NULL,
  max_threshold int(10) DEFAULT NULL,
  vitals_category_id int(11) DEFAULT NULL,
  PRIMARY KEY (vital_ref_component_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS hs_tax_type_master; 
CREATE TABLE hs_tax_type_master (
  tax_type_id int(11) NOT NULL ,
  hospital_id bigint(50) DEFAULT NULL,
  tax_type_nm varchar(45) DEFAULT NULL,
  tax_value_in_per decimal(6,3) DEFAULT NULL,
  active_flg tinyint(4) NOT NULL DEFAULT '1',
  created_ts timestamp NOT NULL,
  created_by varchar(45) DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  modified_ts timestamp NULL DEFAULT NULL,
  is_tax_group_flg tinyint(1) DEFAULT '0',
  is_default_tax tinyint(1) DEFAULT '0',
  PRIMARY KEY (tax_type_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS hs_hospital_wards_master; 
CREATE TABLE hs_hospital_wards_master (
  ward_id int(11) NOT NULL,
  hospital_id int(11) NOT NULL,
  ward_cd varchar(45) NOT NULL,
  ward_nm varchar(45) NOT NULL,
  active_flg int(11) DEFAULT NULL,
  created_ts timestamp NULL DEFAULT NULL,
  created_by varchar(45) DEFAULT NULL,
  modified_ts timestamp NULL DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  floor_no int(11) DEFAULT NULL,
  bedcount_no int(11) DEFAULT NULL,
  PRIMARY KEY (ward_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS hs_hospital_staff_master;
CREATE TABLE hs_hospital_staff_master (
  hospital_staff_id int(11) NOT NULL,
  hospital_id int(11) DEFAULT NULL,
  hospital_staff_cd varchar(45) DEFAULT NULL,
  hospital_staff_full_nm varchar(100) DEFAULT NULL,
  hospital_staff_type_id int(11) DEFAULT NULL,
  hospital_staff_manager_id int(11) DEFAULT NULL COMMENT 'self join to hospital staff id ',
  hospital_staff_join_dt datetime DEFAULT NULL,
  hospital_staff_resignation_dt datetime DEFAULT NULL,
  created_by varchar(45) DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  created_ts datetime DEFAULT NULL,
  modified_ts datetime DEFAULT NULL,
  hospital_staff_gender varchar(45) DEFAULT NULL,
  hospital_staff_user_name varchar(45) DEFAULT NULL,
  hospital_staff_user_id bigint(50) DEFAULT NULL,
  hospital_staff_designation_id int(11) DEFAULT NULL,
  hospital_staff_dept_id int(11) DEFAULT NULL,
  hospital_staff_kmc_reg_no varchar(45) DEFAULT NULL,
  active_flg tinyint(1) DEFAULT NULL,
  email_id varchar(100) DEFAULT NULL,
  mobile_number varchar(45) DEFAULT NULL,
  country_code varchar(6) DEFAULT NULL,
  PRIMARY KEY (hospital_staff_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS hs_hospital_staff_type_master;
CREATE TABLE hs_hospital_staff_type_master (
  id int(11) NOT NULL,
  code varchar(45) NOT NULL,
  description varchar(100) NOT NULL,
  created_ts timestamp NOT NULL,
  created_by varchar(45) NOT NULL,
  modified_ts timestamp NULL DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY code_UNIQUE (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS hs_rate_category_master;
CREATE TABLE hs_rate_category_master (
  rate_category_master_id int(11) NOT NULL,
  rate_category_nm varchar(45) NOT NULL,
  active_flg tinyint(1),
  created_by varchar(45) NOT NULL,
  created_ts datetime NOT NULL,
  modified_by varchar(45) DEFAULT NULL,
  modified_ts datetime DEFAULT NULL,
  hospital_id int(11) NOT NULL,
  default_flg tinyint(1) NOT NULL,
  PRIMARY KEY (rate_category_master_id),
  UNIQUE KEY uk_rate_charges (hospital_id,rate_category_nm)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
DROP TABLE IF EXISTS hs_location_master; 
CREATE TABLE hs_location_master (
  location_master_id bigint(20) NOT NULL,
  zipcode varchar(20) NOT NULL,
  area varchar(100) DEFAULT NULL,
  taluk varchar(100) DEFAULT NULL,
  city varchar(100) DEFAULT NULL,
  state varchar(100) DEFAULT NULL,
  country varchar(50) DEFAULT 'India',
  country_code varchar(10) DEFAULT 'IND',
  latitude varchar(45) DEFAULT NULL,
  longitude varchar(45) DEFAULT NULL,
  PRIMARY KEY (location_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 

DROP TABLE IF EXISTS hs_patient_allergy_details; 
CREATE TABLE hs_patient_allergy_details (
  patient_id bigint(50) NOT NULL,
  allergy_ref_id bigint(50) NOT NULL DEFAULT '0',
  allergy_ref_display_txt varchar(4000) DEFAULT NULL,
  created_patient_visit_id bigint(50) DEFAULT NULL,
  active_flg tinyint(1) NOT NULL DEFAULT '1',
  created_by varchar(45) DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  created_ts datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modified_ts datetime DEFAULT NULL,
  PRIMARY KEY (patient_id,allergy_ref_id,active_flg,created_ts) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS hs_patient_assessment; 
CREATE TABLE hs_patient_assessment (
  hs_patient_assessment_id bigint(50) NOT NULL,
  health_assessment_scale_id bigint(50) NOT NULL,
  patient_visit_id bigint(50) NOT NULL,
  visit_note_id bigint(50) DEFAULT NULL,
  patient_id bigint(50) NOT NULL,
  hospital_id int(11) NOT NULL,
  hospital_staff_id int(11) NOT NULL,
  visit_assessment_status_flg tinyint(2) NOT NULL,
  deactivation_comment varchar(200) DEFAULT NULL,
  assessed_ts datetime DEFAULT NULL,
  created_ts timestamp NOT NULL,
  created_by varchar(45) NOT NULL,
  modified_by varchar(45) DEFAULT NULL,
  modified_ts timestamp NULL DEFAULT NULL,
  active_flg tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (hs_patient_assessment_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS hs_patient_assessment_scale_results; 
CREATE TABLE hs_patient_assessment_scale_results (
  hs_patient_assessment_scale_result_id bigint(50) NOT NULL,
  hs_patient_assessment_id bigint(50) NOT NULL,
  assessment_scale_result_item_id bigint(11) NOT NULL,
  assessment_scale_result_value varchar(2000) DEFAULT NULL,
  created_ts timestamp NOT NULL,
  created_by varchar(45) NOT NULL,
  modified_by varchar(45) DEFAULT NULL,
  modified_ts timestamp NULL DEFAULT NULL,
  active_flg tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (hs_patient_assessment_scale_result_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS hs_patient_contact_details; 
CREATE TABLE hs_patient_contact_details (
  patient_contact_id int(11) NOT NULL,
  patient_id bigint(50) NOT NULL,
  email_id varchar(100) DEFAULT NULL,
  patient_addr_line1 varchar(200) DEFAULT NULL,
  patient_addr_line2 varchar(200) DEFAULT NULL,
  patient_location_id int(11) DEFAULT '0',
  patient_home_phone_num varchar(45) DEFAULT NULL,
  patient_mobile_phone_num varchar(45) DEFAULT NULL,
  patient_alternate_phone_num varchar(45) DEFAULT NULL,
  patient_emerg_contact_name varchar(100) DEFAULT NULL,
  patient_emerg_contact_num varchar(45) DEFAULT NULL,
  patient_relation varchar(100) DEFAULT NULL,
  effective_from_dt datetime DEFAULT NULL,
  effective_to_dt datetime DEFAULT '9999-12-31 00:00:00',
  created_by varchar(45) DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  created_ts datetime DEFAULT NULL,
  modified_ts datetime DEFAULT NULL,
  PRIMARY KEY (patient_contact_id),
  UNIQUE KEY UK (patient_id,effective_to_dt)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS hs_patient_diagnosis_tags; 
CREATE TABLE hs_patient_diagnosis_tags (
  patient_diagnosis_tag_id int(11) NOT NULL ,
  diagnosis_tag_id int(11) NOT NULL,
  patient_id int(11) NOT NULL,
  assessment_note_id int(11) DEFAULT NULL,
  active_flg tinyint(1) DEFAULT '1',
  created_ts datetime NOT NULL,
  created_by varchar(45) NOT NULL,
  modified_by varchar(45) DEFAULT NULL,
  modified_ts timestamp NULL DEFAULT NULL,
  patient_visit_id bigint(50) DEFAULT NULL,
  PRIMARY KEY (patient_diagnosis_tag_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS hs_patient_document_master;
CREATE TABLE hs_patient_document_master (
  document_id bigint(11) NOT NULL,
  patient_id bigint(11) NOT NULL,
  upload_visit_id int(11) DEFAULT NULL,
  upload_url varchar(1000) DEFAULT NULL,
  document_nm varchar(200) DEFAULT NULL,
  document_desc varchar(1000) DEFAULT NULL,
  thumbnail_url varchar(200) DEFAULT NULL,
  version_id varchar(145) DEFAULT NULL,
  thumbnail_version_id varchar(145) DEFAULT NULL,
  active_flg tinyint(1) NOT NULL DEFAULT '1',
  created_by varchar(45) DEFAULT NULL,
  created_ts datetime DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  modified_ts datetime DEFAULT NULL,
  PRIMARY KEY (document_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS hs_patient_demographics; 
CREATE TABLE hs_patient_demographics (
  patient_demographics_id int(11) NOT NULL,
  old_patient_id bigint(50) DEFAULT NULL,
  patient_id bigint(50) DEFAULT NULL,
  patient_nm varchar(120) NOT NULL,
  patient_first_nm varchar(120) NOT NULL,
  patient_middle_nm varchar(120) DEFAULT '',
  patient_last_nm varchar(120) NOT NULL,
  birth_dt datetime NOT NULL,
  death_dt date DEFAULT NULL,
  gender varchar(12) NOT NULL,
  patient_mother_nm varchar(100) NOT NULL,
  patient_father_nm varchar(100) DEFAULT NULL,
  patient_spouse_nm varchar(100) DEFAULT NULL,
  marital_status varchar(45) DEFAULT NULL COMMENT 'Married, Single, Divorced, Widowed, Separated, Live-in relationship',
  color_category_id varchar(10) DEFAULT NULL,
  default_rate_category_id int(11) NOT NULL,
  blood_group_display_nm varchar(45) DEFAULT NULL,
  created_by varchar(45) DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  created_ts datetime DEFAULT NULL,
  modified_ts datetime DEFAULT NULL,
  gestational_age_in_days int(11) DEFAULT NULL,
  birth_weight double DEFAULT NULL,
  PRIMARY KEY (patient_demographics_id),
  UNIQUE KEY mothers_nm_comb_UNIQUE_KEY (patient_nm,birth_dt,patient_mother_nm),
  UNIQUE KEY patient_id_UNIQUE (patient_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS hs_patient_family_history_details;
CREATE TABLE hs_patient_family_history_details (
  patient_id bigint(50) NOT NULL,
  family_relative_ref_id bigint(50) NOT NULL DEFAULT '0',
  family_relative_ref_display_txt varchar(4000) DEFAULT NULL,
  family_history_ref_id bigint(50) NOT NULL,
  family_history_ref_display_txt varchar(1000) NOT NULL,
  history_since_dt datetime DEFAULT NULL,
  created_patient_visit_id bigint(50) DEFAULT NULL,
  active_flg tinyint(1) DEFAULT '1',
  created_by varchar(45) DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  created_ts datetime DEFAULT CURRENT_TIMESTAMP,
  modified_ts datetime DEFAULT NULL,
  PRIMARY KEY (patient_id,family_relative_ref_id,family_history_ref_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS hs_patient_master;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE hs_patient_master (
  patient_id bigint(50) NOT NULL ,
  patient_cd varchar(45) DEFAULT NULL,
  primary_hospital_id int(11) DEFAULT NULL,
  patient_login_id bigint(50) DEFAULT NULL,
  created_ts datetime DEFAULT NULL,
  modified_ts datetime DEFAULT NULL,
  created_by varchar(45) DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  referred_by varchar(45) DEFAULT NULL,
  registration_ts datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (patient_id),
  UNIQUE KEY patient_primary_hosp_id_UNIQUE (patient_cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS hs_patient_medical_summary_details;
CREATE TABLE hs_patient_medical_summary_details (
  summary_id int(11) NOT NULL,
  hospital_staff_id int(11) NOT NULL,
  patient_id int(11) NOT NULL,
  notes_desc text NOT NULL,
  visit_note_title varchar(100) NOT NULL,
  visit_note_ts datetime NOT NULL,
  hospital_id int(11) NOT NULL,
  active_flg tinyint(1) NOT NULL DEFAULT '1',
  created_ts datetime NOT NULL,
  PRIMARY KEY (summary_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS hs_patient_medication_details;
CREATE TABLE hs_patient_medication_details (
  medication_details_id int(11) NOT NULL ,
  patient_id bigint(50) NOT NULL,
  pharma_product_ref_id bigint(50) DEFAULT NULL,
  pharma_product_ref_display_txt varchar(238) DEFAULT NULL,
  pharma_brand_name varchar(500) DEFAULT NULL,
  dosage varchar(100) DEFAULT NULL,
  drug_form_ref_id bigint(50) DEFAULT NULL,
  drug_form_ref_display_txt varchar(4000) DEFAULT NULL,
  frequency varchar(45) DEFAULT NULL,
  comments varchar(500) DEFAULT NULL,
  start_dt datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  end_dt datetime DEFAULT NULL,
  created_patient_visit_doctor_id bigint(50) NOT NULL,
  prescription_flg tinyint(1) DEFAULT '1',
  active_flg tinyint(1) DEFAULT '1',
  created_by varchar(45) DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  created_ts datetime DEFAULT NULL,
  modified_ts datetime DEFAULT NULL,
  patient_visit_note_id bigint(11) DEFAULT NULL,
  dose double DEFAULT NULL,
  measurementunit_ref_component_id bigint(50) DEFAULT NULL,
  measurementunit_ref_display_txt varchar(255) DEFAULT NULL,
  infusion_rate double DEFAULT NULL,
  infusion_rate_measurementunit_ref_component_id bigint(50) DEFAULT NULL,
  infusion_rate_measurementunit_ref_display_txt varchar(255) DEFAULT NULL,
  max_infusion_rate varchar(45) DEFAULT NULL,
  drug_route_id int(11) DEFAULT NULL,
  frequency_no varchar(45) DEFAULT NULL,
  freq_mode_id int(11) DEFAULT NULL,
  prescription_type_id int(11) DEFAULT NULL,
  drug_form_id int(11) DEFAULT NULL,
  concentration double DEFAULT NULL,
  PRIMARY KEY (medication_details_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS hs_patient_occupational_history_details;
CREATE TABLE hs_patient_occupational_history_details (
  occupational_history_id int(11) NOT NULL,
  patient_id int(11) DEFAULT NULL,
  occupation_status varchar(45) DEFAULT NULL,
  comments varchar(45) DEFAULT NULL,
  active_flg tinyint(1) DEFAULT NULL,
  created_by varchar(45) DEFAULT NULL,
  created_ts datetime DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  modified_ts datetime DEFAULT NULL,
  PRIMARY KEY (occupational_history_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS hs_patient_package_mapped_item_details;
CREATE TABLE hs_patient_package_mapped_item_details (
  patient_mapped_item_id int(11) NOT NULL,
  patient_package_master_id int(11) DEFAULT NULL,
  bill_item_cd varchar(45) DEFAULT NULL,
  total_count int(11) DEFAULT NULL,
  used_count int(11) DEFAULT NULL,
  available_count int(11) DEFAULT NULL,
  active_flg tinyint(1) DEFAULT NULL,
  created_by varchar(45) DEFAULT NULL,
  created_ts datetime DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  modified_ts datetime DEFAULT NULL,
  consultation_type_id int(11) DEFAULT NULL,
  hospital_staff_id int(11) DEFAULT NULL,
  product_master_id bigint(20) DEFAULT '0',
  stock_batch_number varchar(45) DEFAULT NULL,
  PRIMARY KEY (patient_mapped_item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS hs_hospital_package_master;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE hs_hospital_package_master (
  hospital_package_master_id int(11) NOT NULL,
  patient_id int(11) DEFAULT NULL,
  visit_bill_item_id int(11) DEFAULT NULL,
  start_dt date DEFAULT NULL,
  end_dt date DEFAULT NULL,
  duration int(11) DEFAULT NULL,
  active_flg tinyint(1) DEFAULT NULL,
  created_by varchar(45) DEFAULT NULL,
  created_ts datetime DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  modified_ts datetime DEFAULT NULL,
  store_id bigint(20) DEFAULT '0',
  indent_id bigint(20) DEFAULT '0',
  PRIMARY KEY (hospital_package_master)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS hs_patient_past_history_details;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE hs_patient_past_history_details (
  patient_id bigint(50) NOT NULL,
  past_history_ref_id bigint(50) NOT NULL,
  past_history_ref_display_txt varchar(4000) NOT NULL,
  history_since_dt datetime DEFAULT NULL,
  created_patient_visit_id bigint(50) DEFAULT NULL,
  hospital_id int(11) DEFAULT NULL,
  hospital_nm varchar(45) DEFAULT NULL,
  doctor_cd varchar(45) DEFAULT NULL,
  location_id int(11) DEFAULT NULL,
  location_nm varchar(45) DEFAULT NULL,
  active_flg tinyint(1) DEFAULT '1',
  created_by varchar(45) DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  created_ts datetime DEFAULT CURRENT_TIMESTAMP,
  modified_ts datetime DEFAULT NULL,
  comments varchar(2000) DEFAULT NULL,
  PRIMARY KEY (patient_id,past_history_ref_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS hs_patient_secondary_attribute_master;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE hs_patient_secondary_attribute_master (
  patient_secondary_attribute_id int(11) NOT NULL,
  attribute_name varchar(100) DEFAULT NULL,
  attribute_mandatory varchar(45) DEFAULT NULL,
  attribute_regular_expression varchar(45) DEFAULT NULL,
  error_message varchar(100) DEFAULT NULL,
  created_ts datetime DEFAULT NULL,
  modified_ts datetime DEFAULT NULL,
  active tinyint(1) DEFAULT NULL,
  created_by varchar(45) DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  result_type_id int(11) DEFAULT NULL,
  seq_nbr int(11) DEFAULT NULL,
  hospital_id int(11) NOT NULL,
  PRIMARY KEY (patient_secondary_attribute_id) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS hs_patient_secondary_attribute_relation;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE hs_patient_secondary_attribute_relation (
  patient_secondary_attribute_relation_id int(11) NOT NULL ,
  patient_id bigint(50) DEFAULT NULL,
  secondry_attribute_master_id int(11) DEFAULT NULL,
  description text,
  created_ts datetime DEFAULT NULL,
  created_by varchar(45) DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  modified_ts datetime DEFAULT NULL,
  PRIMARY KEY (patient_secondary_attribute_relation_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE healthscore_stg.hs_patient_secondary_attribute_relation 
ADD INDEX idx (secondry_attribute_master_id);


DROP TABLE IF EXISTS hs_patient_schedule_master;
CREATE TABLE hs_patient_schedule_master (
  patient_schedule_id bigint(50) NOT NULL ,
  hospital_id int(11) NOT NULL,
  patient_id int(11) NOT NULL,
  visit_id int(50) NOT NULL,
  schedule_dt date NOT NULL,
  schedule_hour_id int(11) NOT NULL,
  schedule_minute_id int(11) NOT NULL,
  schedule_end_hour_id int(11) DEFAULT NULL,
  duration int(11) DEFAULT NULL,
  schedule_end_minute_id int(11) DEFAULT NULL,
  active_flg tinyint(1) DEFAULT '1',
  created_by varchar(45) DEFAULT NULL,
  created_ts datetime DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  modified_ts datetime DEFAULT NULL,
  PRIMARY KEY (patient_schedule_id),
  KEY idx_schedule_dt (schedule_dt)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS hs_patient_visit_bill;
CREATE TABLE hs_patient_visit_bill (
  visit_bill_id bigint(50) NOT NULL ,
  visit_bill_cd varchar(45) NOT NULL,
  patient_visit_id bigint(50) NOT NULL,
  bill_total_amt decimal(10,2) DEFAULT NULL,
  bill_concession_amt decimal(10,2) DEFAULT NULL,
  bill_paid_amt decimal(10,2) DEFAULT NULL,
  bill_refund_amt decimal(10,2) DEFAULT '0.00',
  bill_balance_amt decimal(10,2) DEFAULT NULL,
  bill_amt_collected_by varchar(45) DEFAULT NULL,
  bill_comments varchar(1000) DEFAULT NULL,
  adjusted_flg tinyint(1) NOT NULL DEFAULT '0',
  bill_from_ts datetime DEFAULT NULL,
  bill_to_ts datetime DEFAULT NULL,
  created_ts timestamp NULL DEFAULT NULL,
  created_by varchar(45) NOT NULL,
  modified_by varchar(45) DEFAULT NULL,
  modified_ts timestamp NULL DEFAULT NULL,
  waived_amt decimal(10,2) DEFAULT NULL,
  print_flg tinyint(1) NOT NULL DEFAULT '0',
  billed_by varchar(45) DEFAULT NULL,
  billed_ts timestamp NULL DEFAULT NULL,
  PRIMARY KEY (visit_bill_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Generate bill and payment info for a patient visit';

DROP TABLE IF EXISTS hs_patient_visit_bill_items;
CREATE TABLE hs_patient_visit_bill_items (
  visit_bill_item_id bigint(50) NOT NULL ,
  visit_bill_id bigint(50) NOT NULL,
  bill_item_id bigint(50) DEFAULT NULL,
  bill_item_cd varchar(45) DEFAULT NULL,
  con_charge_id bigint(50) DEFAULT NULL,
  bill_item_qty int(11) NOT NULL DEFAULT '1',
  bill_item_unit_amt decimal(10,2) NOT NULL,
  bill_item_total_concession_amt decimal(10,2) DEFAULT NULL,
  bill_item_final_amt decimal(10,2) NOT NULL,
  bill_item_receipt_cd varchar(45) DEFAULT NULL,
  active_flg tinyint(1) NOT NULL DEFAULT '1',
  pharmacy_item tinyint(1) NOT NULL DEFAULT '0',
  created_ts timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by varchar(45) NOT NULL,
  modified_by varchar(45) DEFAULT NULL,
  modified_ts timestamp NULL DEFAULT NULL,
  payment_method_id int(11) DEFAULT NULL,
  payment_comments varchar(105) DEFAULT NULL,
  adj_comments varchar(105) DEFAULT NULL,
  prior_visit_bill_id bigint(50) DEFAULT NULL,
  approved_by_user_id int(11) DEFAULT NULL,
  tax_type_id int(11) DEFAULT NULL,
  bill_item_total_tax decimal(10,2) DEFAULT NULL,
  stock_batch_id int(11) DEFAULT NULL,
  care_plan_instruction_id bigint(20) DEFAULT NULL,
  non_editable_comments varchar(150) DEFAULT NULL,
  patient_mapped_item_id int(11) DEFAULT NULL,
  returned_qty int(11) DEFAULT NULL,
  PRIMARY KEY (visit_bill_item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Bill items price for a patient visit';


DROP TABLE IF EXISTS hs_patient_visit_details;
CREATE TABLE hs_patient_visit_details (
  patient_visit_id bigint(50) NOT NULL,
  patient_visit_cd varchar(45) NOT NULL,
  patient_id bigint(50) NOT NULL,
  hospital_id int(11) NOT NULL,
  checkin_ts timestamp NULL DEFAULT NULL,
  checkout_ts timestamp NULL DEFAULT NULL,
  delivery_ts datetime DEFAULT NULL,
  discharge_ts datetime DEFAULT NULL,
  visit_type varchar(45) NOT NULL,
  visit_type_changed_flg tinyint(1) DEFAULT NULL,
  appointment_id int(11) DEFAULT NULL,
  doctor_id bigint(50) NOT NULL,
  visit_reason varchar(200) DEFAULT NULL,
  created_by varchar(45) DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  created_ts datetime DEFAULT NULL,
  modified_ts datetime DEFAULT NULL,
  total_bill_amount decimal(10,2) DEFAULT NULL,
  paid_bill_amount decimal(10,2) DEFAULT NULL,
  refund_bill_amount decimal(10,2) DEFAULT NULL,
  cancel_reason varchar(200) DEFAULT NULL,
  checkout_type varchar(45) DEFAULT NULL,
  ward_id int(11) DEFAULT NULL,
  outcome_type varchar(45) DEFAULT NULL,
  condition_at_discharge varchar(45) DEFAULT NULL,
  transferred_by varchar(45) DEFAULT NULL,
  ip_nbr varchar(45) DEFAULT NULL,
  visit_rate_category_id int(11) NOT NULL,
  admission_method varchar(45) DEFAULT NULL,
  referral_source varchar(45) DEFAULT NULL,
  daily_rate decimal(10,2) DEFAULT NULL,
  daily_rate_modified_by varchar(45) DEFAULT NULL,
  daily_rate_modified_ts datetime DEFAULT NULL,
  reference_doctor_id int(11) DEFAULT NULL,
  primary_doctor_id int(11) DEFAULT NULL,
  pharmacy_checkin_flg tinyint(1) DEFAULT NULL,
  billied_days int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (patient_visit_id),
  KEY VISIT_CHKIN_INDX (checkin_ts),
  KEY VISIT_PTNT_INDX (patient_id),
  KEY VISIT_DCTR_INDX (doctor_id),
  KEY VISIT_TYPE_INDEX (visit_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS hs_patient_visit_diagnosis;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE hs_patient_visit_diagnosis (
  visit_diagnosis_id bigint(50) NOT NULL,
  visit_note_id bigint(11) DEFAULT NULL,
  visit_doctor_id bigint(50) DEFAULT NULL,
  visit_diagnosis_desc varchar(4000) DEFAULT NULL,
  visit_diagnosis_ref_id_json JSON DEFAULT NULL,
  visit_diagnosis_type_ref_id bigint(50),
  active_flg tinyint(1) DEFAULT '1',
  deactivation_comment varchar(255) DEFAULT NULL,
  created_ts datetime DEFAULT CURRENT_TIMESTAMP,
  modified_ts datetime DEFAULT NULL,
  created_by varchar(4000) DEFAULT NULL,
  modified_by varchar(4000) DEFAULT NULL,
  generated_visit_diagnosis varchar(4000) DEFAULT NULL,
  processed_ts datetime,
  PRIMARY KEY (visit_diagnosis_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS hs_patient_visit_doctors;
CREATE TABLE hs_patient_visit_doctors (
  visit_doctor_id bigint(50) NOT NULL,
  patient_visit_id bigint(50) NOT NULL,
  hospital_staff_id bigint(50) NOT NULL,
  created_ts timestamp NOT NULL,
  created_by varchar(45) NOT NULL,
  modified_by varchar(45) DEFAULT NULL,
  modified_ts timestamp NULL DEFAULT NULL,
  event_id int(11) DEFAULT NULL,
  auto_updated_flg tinyint(1) DEFAULT '1',
  PRIMARY KEY (visit_doctor_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Map visit doctors for a patient visit';

DROP TABLE IF EXISTS hs_patient_visit_findings;
CREATE TABLE hs_patient_visit_findings (
  visit_findings_id bigint(50) NOT NULL,
  visit_note_id bigint(11) DEFAULT NULL,
  visit_doctor_id bigint(50) DEFAULT NULL,
  visit_findings_desc varchar(4000) DEFAULT NULL,
  visit_findings_ref_id_json varchar(4000) DEFAULT NULL,
  active_flg tinyint(1) DEFAULT '1',
  deactivation_comment varchar(255) DEFAULT NULL,
  created_ts datetime DEFAULT CURRENT_TIMESTAMP,
  modified_ts datetime DEFAULT NULL,
  created_by varchar(45) DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  generated_visit_findings varchar(4000) DEFAULT NULL,
  processed_ts datetime,
  PRIMARY KEY (visit_findings_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS hs_patient_visit_lab_results;
CREATE TABLE hs_patient_visit_lab_results (
  visit_lab_results_id bigint(11) NOT NULL,
  visit_order_id bigint(11) NOT NULL,
  lab_order_results_id bigint(11) NOT NULL,
  lab_order_result_value varchar(2000) DEFAULT NULL,
  lab_result_processed_by varchar(45) DEFAULT NULL,
  active_flg tinyint(1) NOT NULL DEFAULT '1',
  created_by varchar(45) NOT NULL,
  modified_by varchar(45) DEFAULT NULL,
  created_ts datetime NOT NULL,
  modified_ts datetime DEFAULT NULL,
  PRIMARY KEY (visit_lab_results_id),
  KEY IDX_visit_order (visit_order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS hs_patient_visit_order_results; 
CREATE TABLE hs_patient_visit_order_results (
  order_result_id bigint(11) NOT NULL ,
  visit_order_id int(11) NOT NULL,
  order_result_value varchar(4000) DEFAULT NULL,
  active_flg tinyint(1) DEFAULT NULL,
  created_by varchar(45) DEFAULT NULL,
  created_ts datetime DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  modified_ts datetime DEFAULT NULL,
  processed_by varchar(45) DEFAULT NULL,
  PRIMARY KEY (order_result_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS hs_patient_visit_orders; 
CREATE TABLE hs_patient_visit_orders (
  visit_order_id bigint(50) NOT NULL ,
  visit_note_id bigint(11) DEFAULT NULL,
  order_visit_id bigint(50) DEFAULT NULL,
  order_category_ref_component_id bigint(50) NOT NULL,
  visit_order_desc varchar(4000) DEFAULT NULL,
  bill_item_cd varchar(45) DEFAULT NULL,
  visit_bill_item_id bigint(11) DEFAULT NULL,
  bill_visit_id bigint(11) DEFAULT NULL,
  visit_order_status_id int(11) DEFAULT NULL,
  ref_dr_nm varchar(45) DEFAULT NULL,
  ref_dr_hospital_staff_id bigint(11) DEFAULT NULL,
  notify_flg tinyint(1) NOT NULL DEFAULT '0',
  active_flg tinyint(1) DEFAULT '1',
  deactivation_comment varchar(255) DEFAULT NULL,
  created_ts datetime DEFAULT CURRENT_TIMESTAMP,
  modified_ts datetime DEFAULT NULL,
  created_by varchar(4000) DEFAULT NULL,
  modified_by varchar(4000) DEFAULT NULL,
  pending_order_discarded_flg tinyint(1) NOT NULL DEFAULT '0',
  package_order_id int(11) DEFAULT NULL,
  package_flg tinyint(1) DEFAULT NULL,
  urgent_flg tinyint(1) DEFAULT '0',
  collected_ts datetime DEFAULT NULL,
  accession_no varchar(60) DEFAULT NULL,
  PRIMARY KEY (visit_order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS hs_patient_visit_symptoms; 
CREATE TABLE hs_patient_visit_symptoms (
  visit_symptoms_id bigint(50) NOT NULL,
  visit_note_id bigint(11) DEFAULT NULL,
  visit_doctor_id bigint(50) DEFAULT NULL,
  visit_symptoms_desc varchar(4000) DEFAULT NULL,
  visit_symptoms_ref_id_json varchar(4000) DEFAULT NULL,
  active_flg tinyint(1) DEFAULT '1',
  deactivation_comment varchar(255) DEFAULT NULL,
  created_ts datetime DEFAULT CURRENT_TIMESTAMP,
  modified_ts datetime DEFAULT NULL,
  created_by varchar(45) DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  generated_visit_symptoms varchar(4000) DEFAULT NULL,
  processed_ts datetime,
  PRIMARY KEY (visit_symptoms_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS hs_patient_visit_vitals;
CREATE TABLE hs_patient_visit_vitals (
  patient_visit_vitals_id bigint(50) NOT NULL ,
  patient_id bigint(50) NOT NULL,
  vital_ref_id bigint(50) NOT NULL,
  measurementunit_ref_id bigint(50) NOT NULL,
  biomedicaldevice_ref_id bigint(50) DEFAULT NULL,
  patient_vital_value decimal(10,2) NOT NULL,
  created_patient_visit_id bigint(50) NOT NULL,
  visit_note_id int(11) DEFAULT NULL,
  created_by varchar(45) DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  created_ts datetime DEFAULT CURRENT_TIMESTAMP,
  modified_ts datetime DEFAULT NULL,
  vital_recorded_ts datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS hs_product_master;
CREATE TABLE hs_product_master (
  product_master_id bigint(20) NOT NULL,
  product_cd varchar(45),
  product_desc varchar(1000),
  product_nm varchar(1000),
  generic_nm varchar(1000),
  hospital_master_id bigint(20) NOT NULL,
  product_brand_master_id bigint(20),
  product_category_master_id bigint(20),
  active_flg tinyint(1),
  created_by varchar(45),
  created_ts datetime,
  modified_by varchar(45),
  modified_ts datetime,
  billable_flg tinyint(1) NOT NULL,
  hsn_code varchar(45),
  tax_type_id int(11),
  schedule_type_cd varchar(10),
  PRIMARY KEY (product_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS hs_ext_hospital_doctors_master;
CREATE TABLE hs_ext_hospital_doctors_master (
  doctor_id int(11) NOT NULL ,
  external_hospital_nm varchar(200) DEFAULT NULL,
  external_doctor_nm varchar(100) NOT NULL,
  effective_from_ts datetime DEFAULT NULL,
  effective_to_ts datetime DEFAULT NULL,
  active_flg tinyint(1) NOT NULL DEFAULT '1',
  created_by varchar(45) DEFAULT NULL,
  created_ts datetime DEFAULT NULL,
  modified_by varchar(45) DEFAULT NULL,
  modified_ts datetime DEFAULT NULL,
  department_nm varchar(200) DEFAULT NULL,
  mobile_no varchar(45) DEFAULT NULL,
  email_addr varchar(100) DEFAULT NULL,
  hospital_id int(11) NOT NULL,
  hospital_location_id bigint(20) DEFAULT NULL,
  PRIMARY KEY (doctor_id)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

SET SESSION group_concat_max_len = 1000000;