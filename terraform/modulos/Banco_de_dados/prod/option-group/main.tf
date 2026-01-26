resource "aws_db_option_group" "this" {
  engine_name              = var.engine_name
  major_engine_version     = var.major_engine_version
  name                     = var.name
  option_group_description = var.option_name
  tags                     = var.tags

  option {
    db_security_group_memberships  = []
    option_name                    = var.option_name
    port                           = 0
    vpc_security_group_memberships = []
  }

  timeouts {}
}
