resource "aws_subnet" "dev_appback" {
  for_each          = var.appback_subnet_names
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr_blocks_appback[each.key]
  availability_zone = var.availability_zones[each.key]

  tags = {
    Name = each.value
  }
}
