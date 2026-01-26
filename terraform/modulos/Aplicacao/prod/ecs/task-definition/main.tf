resource "aws_ecs_task_definition" "this" {
  family                   = var.family
  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode(var.container_definitions)

  dynamic "volume" {
    for_each = var.volumes
    content {
      name      = volume.value.name
      host_path = lookup(volume.value, "host_path", null)

      dynamic "efs_volume_configuration" {
        for_each = lookup(volume.value, "efs_volume_configuration", null) != null ? [volume.value.efs_volume_configuration] : []
        content {
          file_system_id     = efs_volume_configuration.value.file_system_id
          root_directory     = lookup(efs_volume_configuration.value, "root_directory", "/")
          transit_encryption  = lookup(efs_volume_configuration.value, "transit_encryption", "ENABLED")
          transit_encryption_port = lookup(efs_volume_configuration.value, "transit_encryption_port", 2049)
          authorization_config {
            access_point_id = lookup(efs_volume_configuration.value.authorization_config, "access_point_id", null)
            iam             = lookup(efs_volume_configuration.value.authorization_config, "iam", "DISABLED")
          }
        }
      }
    }
  }

  tags = var.tags
}

