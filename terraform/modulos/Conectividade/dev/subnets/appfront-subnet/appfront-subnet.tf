resource "aws_subnet" "dev_appfront" {
  for_each          = var.appfront_subnet_names
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr_blocks_appfront[each.key]
  availability_zone = var.availability_zones[each.key]

  tags = {
    Name = each.value
  }
}
