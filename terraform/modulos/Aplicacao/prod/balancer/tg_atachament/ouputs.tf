output "target_group_attachment_ids" {
  description = "IDs das associações com o Target Group"
  value       = { for k, att in aws_lb_target_group_attachment.this : k => att.id }
}
