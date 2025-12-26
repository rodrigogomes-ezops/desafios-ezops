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

# Criar rotas para todas as route tables públicas
module "app_routes" {
  for_each       = module.route_table_public.route_table_ids_by_az
  source         = "./modulos/Conectividade/prod/route"
  route_table_id = each.value
  routes_json    = replace(
    file("${path.module}/routes/app_routes.json"),
    "__INTERNET_GATEWAY_ID__",
    module.internet_gateway.internet_gateway_id
  )
}

module"route_table_public" {
  source       = "./modulos/Conectividade/prod/route-table-public"
  vpc_id       = module.vpc_app.vpc_id
  subnet_ids   = module.subnet_public.public_subnet_id
  tags         = var.tags_route_table_public
  service_name = var.rt_public_name
}

module "route_table_association_public" {
  source          = "./modulos/Conectividade/prod/route-table-association"
  subnet_ids      = module.subnet_public.public_subnet_id
  route_table_ids = module.route_table_public.route_table_ids
}