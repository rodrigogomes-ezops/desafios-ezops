resource "aws_lb_listener_rule" "this" {
  listener_arn = var.listener_arn
  priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }

  # Só cria condição de path se houver path_values
  dynamic "condition" {
    for_each = length(var.path_values) > 0 ? [1] : []
    content {
      path_pattern {
        values = var.path_values
      }
    }
  }

  # Só cria condição de host_header se houver host_header_values
  dynamic "condition" {
    for_each = length(var.host_header_values) > 0 ? [1] : []
    content {
      host_header {
        values = var.host_header_values
      }
    }
  }
}
