resource "aws_lb_target_group" "this" {
  name             = var.tg_name
  port             = var.target_group_port
  target_type      = var.target_type
  protocol         = var.target_group_protocol
  vpc_id           = var.vpc_id
  protocol_version = var.target_group_protocol_version

  health_check {
    protocol            = var.health_check_protocol
    path                = var.health_check_path
    port                = var.health_check_port
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.health_check_timeout
    interval            = var.health_check_interval
    matcher             = var.health_check_matcher
  }

  tags = var.tags
}
