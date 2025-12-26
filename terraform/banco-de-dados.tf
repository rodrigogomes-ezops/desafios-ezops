###################################################################################################################
################################################## Banco de Dados #################################################
###################################################################################################################

######################################################## RDS ######################################################

#######################
#### RDS - Postgre ####
#######################

module "db_parameter_postgre" {
  source               = "./modulos/Banco_de_dados/prod/parameter-group"
  parameter_group_name = var.parameter_group_name_postgre
  family               = var.family_postgre
  tags                 = var.tags_parameter_group_postgre
}

module "rds_postgre" {
  source                = "./modulos/Banco_de_dados/prod/rds"
  identifier            = var.identifier_postgre
  db_name               = var.db_name_postgre
  instance_class        = var.instance_class_postgre
  engine                = var.engine_postgre
  engine_version        = var.engine_version_postgre
  license_model         = var.license_model_postgre
  username              = var.username_postgre
  password              = var.password_postgre
  port                  = var.port_postgre
  allocated_storage     = var.allocated_storage_postgre
  max_allocated_storage = var.max_allocated_storage_postgre
  storage_type          = var.storage_type_postgre
  #skip_final_snapshot                   = var.final_snapshot
  character_set_name        = var.character_set_name_postgre
  final_snapshot_identifier = "rds-final" //${md5(timestamp())}"
  final_snapshot            = var.final_snapshot_postgre
  storage_encrypted         = var.storage_encrypted_postgre
  publicly_accessible       = var.publicly_accessible_postgre
  apply_immediately         = var.apply_immediately_postgre
  backup_retention_period   = var.backup_retention_period_postgre
  backup_window             = var.backup_window_postgre
  cloudwatch_logs_exports   = var.cloudwatch_logs_exports_postgre
  multi_az                  = var.multi_az_postgre
  db_subnet_group_name      = module.subnet_group_rds.db_subnet_group_name
  security_groups_ids = [
    module.security_group_rds.security_group_id
  ]
  parameter_group_name                  = module.db_parameter_postgre.parameter_group_name
  option_group_name                     = var.option_group_postgre
  copy_tags_to_snapshot                 = var.copy_tags_to_snapshot_postgre
  performance_insights                  = var.performance_insights_postgre
  performance_insights_retention_period = var.performance_insights_retention_period_postgre
  allow_major_version_upgrade           = var.allow_major_version_upgrade_postgre
  auto_minor_version_upgrade            = var.auto_minor_version_upgrade_postgre
  monitoring_interval                   = var.monitoring_interval_postgre
  maintenance_window                    = var.maintenance_window_postgre
  deletion_protection                   = var.deletion_protection_postgre
  delete_automated_backups              = var.delete_automated_backups_postgre
  monitoring_role_arn                   = var.monitoring_role_arn_postgre
  iam_database_authentication           = var.iam_database_authentication_postgre
  customer_owned_ip                     = var.customer_owned_ip_postgre
  ca_cert_identifier                    = var.ca_cert_identifier_postgre

  tags = var.tags_rds_postgre
}

############ Subnet Group - RDS #############

module "subnet_group_rds" {
  source = "./modulos/Banco_de_dados/prod/db-subnet-group"
  name   = var.name_subnet_group_rds
  subnet_ids = [
    module.subnet_public.public_subnet_ids_by_name["Public-Subnet-AZ-2a"],
    module.subnet_public.public_subnet_ids_by_name["Public-Subnet-AZ-2b"]
  ]
  tags = var.tags_subnet_group_rds
}
