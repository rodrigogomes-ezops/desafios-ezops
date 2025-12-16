########### Alvo de AutoScaling para o armazenamento do MSK #############
resource "aws_appautoscaling_target" "this" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = var.resource_id
  scalable_dimension = "kafka:broker-storage:VolumeSize"
  service_namespace  = "kafka"
}
