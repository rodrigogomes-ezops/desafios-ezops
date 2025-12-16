resource "aws_db_instance" "this" {
  identifier                            = var.identifier
  db_name                               = var.db_name
  instance_class                        = var.instance_class
  engine                                = var.engine
  engine_version                        = var.engine_version
  license_model                         = var.license_model
  username                              = var.username
  password                              = var.password
  port                                  = var.port
  allocated_storage                     = var.allocated_storage
  max_allocated_storage                 = var.max_allocated_storage
  storage_type                          = var.storage_type
  skip_final_snapshot                   = var.final_snapshot
  storage_encrypted                     = var.storage_encrypted
  publicly_accessible                   = var.publicly_accessible
  apply_immediately                     = var.apply_immediately
  backup_retention_period               = var.backup_retention_period
  backup_window                         = var.backup_window
  character_set_name                    = var.character_set_name
  final_snapshot_identifier             = var.final_snapshot_identifier
  enabled_cloudwatch_logs_exports       = var.cloudwatch_logs_exports
  multi_az                              = var.multi_az
  db_subnet_group_name                  = var.db_subnet_group_name
  vpc_security_group_ids                = var.security_groups_ids
  parameter_group_name                  = var.parameter_group_name
  option_group_name                     = var.option_group_name
  copy_tags_to_snapshot                 = var.copy_tags_to_snapshot
  performance_insights_enabled          = var.performance_insights
  performance_insights_retention_period = var.performance_insights_retention_period
  allow_major_version_upgrade           = var.allow_major_version_upgrade
  auto_minor_version_upgrade            = var.auto_minor_version_upgrade
  monitoring_interval                   = var.monitoring_interval
  maintenance_window                    = var.maintenance_window
  deletion_protection                   = var.deletion_protection
  delete_automated_backups              = var.delete_automated_backups
  monitoring_role_arn                   = var.monitoring_role_arn
  iam_database_authentication_enabled   = var.iam_database_authentication
  customer_owned_ip_enabled             = var.customer_owned_ip
  ca_cert_identifier                    = var.ca_cert_identifier

  timeouts {}

  tags = var.tags
}
















