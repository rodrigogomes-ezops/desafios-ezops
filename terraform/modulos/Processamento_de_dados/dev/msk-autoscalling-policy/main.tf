################### Política de AutoScaling para o armazenamento do MSK#######################

resource "aws_appautoscaling_policy" "this" {
  name               = var.name
  policy_type        = var.policy_type
  resource_id        = var.resource_id
  scalable_dimension = var.scalable_dimension
  service_namespace  = var.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.metrics_type
    }

    target_value = var.target_value
  }
}
