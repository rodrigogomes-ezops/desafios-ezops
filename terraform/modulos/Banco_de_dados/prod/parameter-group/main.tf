resource "aws_db_parameter_group" "this" {
  description = var.parameter_group_name
  family      = var.family
  name        = var.parameter_group_name
  tags        = var.tags
}

