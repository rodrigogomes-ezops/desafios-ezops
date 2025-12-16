resource "aws_subnet" "dev_management" {
  for_each          = var.management_subnet_names
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr_blocks_management[each.key]
  availability_zone = var.availability_zones[each.key]

  tags = {
    Name = each.value
  }
}
