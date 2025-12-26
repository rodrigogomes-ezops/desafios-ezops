###################################################################################################################
################################################## CloudWatch Logs ###############################################
###################################################################################################################

# CloudWatch Log Group para o ECS
resource "aws_cloudwatch_log_group" "ecs_backend" {
  name              = "/ecs/rodrigo-backend"
  retention_in_days = 7

  tags = {
    Name        = "RODRIGO-ECS-LOGS"
    Owner       = "Rodrigo Gomes"
    Project     = "Desafios EZOps"
    Environment = "Test"
    ManagedBy   = "Terraform"
  }
}

