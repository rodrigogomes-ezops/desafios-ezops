resource "aws_lb_listener" "this" {
  load_balancer_arn = var.lb_arn
  port              = 80
  protocol          = "TCP"
  
   default_action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }

  tags = var.tags
}



