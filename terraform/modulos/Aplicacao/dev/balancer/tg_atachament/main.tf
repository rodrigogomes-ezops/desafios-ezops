resource "aws_lb_target_group_attachment" "this" {
  for_each         = var.target_id
  target_group_arn = var.target_group_arn
  target_id        = each.value
  port             = lookup(var.target_port, each.key, null)
  availability_zone = lookup(var.target_az,   each.key, null) # exige AZ quando IP está fora da VPC
}