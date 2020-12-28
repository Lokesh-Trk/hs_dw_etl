# Example View : 
use  healthscore_dw;
CREATE ALGORITHM = UNDEFINED DEFINER = `dw_user` @ `localhost` SQL
SECURITY DEFINER VIEW `az_bill_items_master_view` AS
SELECT
	`dbi`.`hospital_key` AS `hospital_key`,
	`dbi`.`bill_item_type` AS `bill_item_type`,
	`dbi`.`bill_item_category_cd` AS `bill_item_category_cd`,
	`dbi`.`bill_item_category_nm` AS `bill_item_category_nm`,
	`dbi`.`bill_item_category_desc` AS `bill_item_category_desc`,
	`dbi`.`bill_item_cd` AS `bill_item_cd`,
	`dbi`.`bill_item_nm` AS `bill_item_nm`,
	`dbi`.`bill_item_amt` AS `bill_item_amt`,
	`dbi`.`transaction_type_cd` AS `transaction_type_cd`,
	`dbi`.`pkg_effective_from_ts` AS `pkg_effective_from_ts`,
	`dbi`.`pkg_effective_to_ts` AS `pkg_effective_to_ts`,
	`dbi`.`renewal_item_flg` AS `renewal_item_flg`,
	`dbi`.`effective_from_ts` AS `effective_from_ts`,
	`dbi`.`effective_to_ts` AS `effective_to_ts`,
	`dbi`.`rate_category_nm` AS `rate_category_nm`,
	`dbi`.`active_flg` AS `active_flg`
FROM (
	`dim_bill_items` `dbi`
	JOIN `dim_hospital` `dh` ON ((`dbi`.`hospital_key` = `dh`.`hospital_key`)))
WHERE (
	`dh`.`hospital_cd` in('CHWDH', 'SDHARV'))


# create User 
CREATE USER suvitas_db_viewer@localhost IDENTIFIED BY <PWD>;

# list all table/views specific to customer
show tables like ‘suvitas%’ ;

#grant permission for all view / table specific to customer 
GRANT SELECT ON `healthscore_dw`.`suvitas_active_visits_view` TO 'suvitas_db_viewer'@'localhost' ;     
  
# validate the permission check the permission for user
show Grants for suvitas_db_viewer@localhost;
