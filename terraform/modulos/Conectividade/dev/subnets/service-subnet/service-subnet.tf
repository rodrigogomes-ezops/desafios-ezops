resource "aws_subnet" "dev_service" {
  for_each          = var.service_subnet_names
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr_blocks_service[each.key]
  availability_zone = var.availability_zones[each.key]

  tags = {
    Name = each.value
  }
}
