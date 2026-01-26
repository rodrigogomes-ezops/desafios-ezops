### Criaçao da VPC ###

module "vpc_app" {
  source         = "./modulos/Conectividade/prod/vpc"
  vpc_cidr_block = var.vpc_cidr_block
  tags           = var.tags_vpc
}

### Criaçao do Internet Gateway ###

module "internet_gateway" {
  source = "./modulos/Conectividade/prod/internet-gateway" # Supondo que você crie esta pasta
  vpc_id = module.vpc_app.vpc_id
  tags   = var.tags_igw
}

### Criaçao da Subnet Publica ###

module "subnet_public" {
  source                    = "./modulos/Conectividade/prod/subnets/public-subnet"
  vpc_id                    = module.vpc_app.vpc_id
  subnet_cidr_blocks_public = var.subnet_cidr_blocks_public
  public_subnet_names       = var.public_subnet_names
  availability_zones        = var.availability_zones_public
  tags                      = var.tags_public_subnet
}

### Criaçao da Route Table Publica (1 route table compartilhada para 2 subnets) ###

resource "aws_route_table" "public" {
  vpc_id = module.vpc_app.vpc_id
  tags   = merge(var.tags_route_table_public, {
    Name = "Public-Route-Table"
  })
}

# Criar rota para a route table pública apontando para o Internet Gateway
resource "aws_route" "public_igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.internet_gateway.internet_gateway_id
}

# Associar as subnets públicas à route table pública
resource "aws_route_table_association" "public" {
  for_each       = { for idx, subnet_id in module.subnet_public.public_subnet_id : idx => subnet_id }
  subnet_id      = each.value
  route_table_id = aws_route_table.public.id
}

### Criaçao da Subnet Privada ###

module "subnet_private" {
  source                     = "./modulos/Conectividade/prod/subnets/private-subnet"
  vpc_id                     = module.vpc_app.vpc_id
  subnet_cidr_blocks_private = var.subnet_cidr_blocks_private
  private_subnet_names       = var.private_subnet_names
  availability_zones         = var.availability_zones_private
  tags                       = var.tags_private_subnet
}

### Criaçao do NAT Gateway ###

module "nat_gateway" {
  source         = "./modulos/Conectividade/prod/nat-gateway"
  public_subnet_id = module.subnet_public.public_subnet_id[0] # Usa a primeira subnet pública
  tags           = var.tags_nat_gateway
}

### Criaçao da Route Table Privada (1 route table compartilhada para 2 subnets) ###

resource "aws_route_table" "private" {
  vpc_id = module.vpc_app.vpc_id
  tags   = merge(var.tags_route_table_private, {
    Name = "Private-Route-Table"
  })
}

# Criar rota para a route table privada apontando para o NAT Gateway
resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = module.nat_gateway.nat_gateway_id
}

# Associar as subnets privadas à route table privada
resource "aws_route_table_association" "private" {
  for_each       = { for idx, subnet_id in module.subnet_private.private_subnet_id : idx => subnet_id }
  subnet_id      = each.value
  route_table_id = aws_route_table.private.id
}