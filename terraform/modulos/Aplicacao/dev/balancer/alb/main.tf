resource "aws_lb" "this" {
  name               = var.lb_name
  internal           = var.internal
  load_balancer_type = var.type
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids
  ip_address_type    = "ipv4"
  enable_http2       = true
  enable_deletion_protection = var.enable_deletion_protection

  access_logs {
    bucket  = var.access_logs_bucket
    prefix  = var.access_logs_prefix
    enabled = var.access_logs_enabled
  }

  tags = var.tags
}
