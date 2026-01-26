########################
# Security Group - ECS #
########################

name_sg_ecs        = "RODRIGO-SG-ECS"
description_sg_ecs = "Security Group para o ECS"

tags_sg_ecs = {
  Name        = "RODRIGO-SG-ECS"
  Owner       = "Rodrigo Gomes"
  Project     = "Desafio EZOps"
  Environment = "Test"
  ManagedBy   = "Terraform"
}

########################
# Security Group - RDS #
########################

name_sg_rds_ecs     = "RODRIGO-SG-RDS"
description_rds_ecs = "Security Group para o RDS"

tags_rds_ecs = {
  Name        = "RODRIGO-SG-RDS"
  Owner       = "Rodrigo Gomes"
  Project     = "Desafio EZOps"
  Environment = "Test"
  ManagedBy   = "Terraform"
}

########################
# Security Group - ALB #
########################

name_sg_alb        = "RODRIGO-SG-ALB"
description_sg_alb = "Security Group para o ALB"

tags_sg_alb = {
  Name        = "RODRIGO-SG-ALB"
  Owner       = "Rodrigo Gomes"
  Project     = "Desafio EZOps"
  Environment = "Test"
  ManagedBy   = "Terraform"
}