module "security_group_ecs" {
  source        = "./modulos/Conectividade/prod/security-group"
  name          = var.name_sg_ecs
  description   = var.description_sg_ecs
  vpc_id        = module.vpc_app.vpc_id
  ingress_rules = jsondecode(file("${path.module}/security_rules/rules-sg-ecs.json")).ingress
  egress_rules  = jsondecode(file("${path.module}/security_rules/rules-sg-ecs.json")).egress
  tags          = var.tags_sg_ecs
}

module "security_group_alb" {
  source        = "./modulos/Conectividade/prod/security-group"
  name          = var.name_sg_alb
  description   = var.description_sg_alb
  vpc_id        = module.vpc_app.vpc_id
  ingress_rules = jsondecode(file("${path.module}/security_rules/rules-sg-alb.json")).ingress
  egress_rules  = jsondecode(file("${path.module}/security_rules/rules-sg-alb.json")).egress
  tags          = var.tags_sg_alb
}

module "security_group_rds" {
  source      = "./modulos/Conectividade/prod/security-group"
  name        = var.name_sg_rds_ecs
  description = var.description_rds_ecs
  vpc_id      = module.vpc_app.vpc_id
  ingress_rules = [
    {
      description     = "Acesso do ECS"
      from_port       = 5432
      to_port         = 5432
      protocol        = "tcp"
      security_groups = [module.security_group_ecs.security_group_id]
    }
  ]
  egress_rules = [
    {
      description      = "Saida para internet"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  ]
  tags = var.tags_rds_ecs
}
