#######################################################################################################################
# RDS #########################################################################################
# ---------------------------------------------------------------------------------------------------------------------

#############################
#### RDS - Postgre  ####
#############################

#### RDS OPTION GROUP ####

engine_name_postgre          = "postgres"
major_engine_version_postgre = "15"
option_group_name_postgre    = "og-postgre"
option_description_postgre   = "Option Group para o RRDS (postgre)"

#### RDS PARAMETER GROUP ####

parameter_group_name_postgre = "pg-postgre"
family_postgre               = "postgres15"
tags_parameter_group_postgre = {
  Name        = "PARAMETER-GROUP-POSTGRE"
  Owner       = "Rodrigo Gomes"
  Project     = "Desafios EZOps"
  Environment = "test"
}

#### RDS INSTANCE ####

identifier_postgre                            = "rds-organizer"
db_name_postgre                               = "postgre"
instance_class_postgre                        = "db.t3.micro"
engine_postgre                                = "postgres"
engine_version_postgre                        = "15"
license_model_postgre                         = null
username_postgre                              = "master"
password_postgre                              = "0z1kvWWJi1gE"
port_postgre                                  = 5432
allocated_storage_postgre                     = 10
max_allocated_storage_postgre                 = null
storage_type_postgre                          = "gp2"
final_snapshot_postgre                        = false
storage_encrypted_postgre                     = false
character_set_name_postgre                    = null
publicly_accessible_postgre                   = false
apply_immediately_postgre                     = true
backup_retention_period_postgre               = 3
backup_window_postgre                         = "04:00-06:00"
cloudwatch_logs_exports_postgre               = ["postgresql", "upgrade"]
multi_az_postgre                              = false
copy_tags_to_snapshot_postgre                 = true
performance_insights_postgre                  = false
performance_insights_retention_period_postgre = 0
allow_major_version_upgrade_postgre           = false
auto_minor_version_upgrade_postgre            = true
monitoring_interval_postgre                   = 0
maintenance_window_postgre                    = "sun:06:05-sun:06:35"
deletion_protection_postgre                   = true
delete_automated_backups_postgre              = false
monitoring_role_arn_postgre                   = null
iam_database_authentication_postgre           = false
customer_owned_ip_postgre                     = false
ca_cert_identifier_postgre                    = "rds-ca-rsa2048-g1"
option_group_postgre                          = "default:postgres-15"

tags_rds_postgre = {
  Name        = "RDS-POSTGRE"
  Owner       = "Rodrigo Gomes"
  Project     = "Desafios EZOps"
  Environment = "test"
}

#### RDS SUBNET GROUP ####

name_subnet_group_rds = "subnet-group-rds"
tags_subnet_group_rds = {
  Name        = "SUBNET GROUP RDS"
  Owner       = "Rodrigo Gomes"
  Project     = "Desafios EZOps"
  Environment = "test"
}