output "autoscalling_target_id" {
  description = "Id Alvo do AutoScalling"
  value       = aws_appautoscaling_target.this.id
}

output "autoscalling_target_dimension" {
  description = "scalable_dimension do AutoScalling"
  value       = aws_appautoscaling_target.this.scalable_dimension
}

output "autoscalling_target_service_namespace" {
  description = "scalable_dimension do AutoScalling"
  value       = aws_appautoscaling_target.this.service_namespace
}
    