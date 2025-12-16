resource "aws_lb" "nlb" {
  name                       = var.name
  internal                   = var.internal
  load_balancer_type         = var.type
  subnets                    = var.subnet_ids
  security_groups            = var.security_group_ids  
  enable_deletion_protection = var.enable_deletion_protection
  enable_cross_zone_load_balancing = null

  access_logs {
     bucket = var.access_logs_bucket
     prefix = var.access_logs_prefix
     enabled = var.access_logs_enabled
   }

  tags = var.tags
}


