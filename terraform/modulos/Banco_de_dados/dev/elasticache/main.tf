resource "aws_elasticache_replication_group" "this" {
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  automatic_failover_enabled = var.automatic_failover_enabled
  engine                     = var.engine
  engine_version             = var.engine_version
  maintenance_window         = var.maintenance_window
  multi_az_enabled           = var.multi_az_enabled
  node_type                  = var.node_type
  parameter_group_name       = var.parameter_group_name
  port                       = var.port
  description                = "Elasticache - ${var.engine}"
  replication_group_id       = var.replication_group_id
  security_group_ids         = var.security_groups_ids
  snapshot_retention_limit   = var.snapshot_retention_limit
  snapshot_window            = var.snapshot_window
  subnet_group_name          = var.subnet_group_name
  transit_encryption_enabled = var.transit_encryption_enabled
  num_node_groups            = var.num_node_groups
  replicas_per_node_group    = var.replicas_per_node_group

  timeouts {}

  tags = var.tags
}

