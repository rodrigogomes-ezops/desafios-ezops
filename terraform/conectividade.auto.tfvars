##################################################################################################################
############################################## VPC ###############################################################
##################################################################################################################

vpc_cidr_block = "10.123.0.0/16"

tags_vpc = {
  Name        = "VPC Rodrigo - Desafio EZOps"
  Owner       = "Rodrigo Gomes"
  Project     = "Desafios EZOps"
  Environment = "Test"
  ManagedBy   = "Terraform"
}

tags_route_table_public = {
  Name        = "Public Route Table Rodrigo - Desafio EZOps"
  Owner       = "Rodrigo Gomes"
  Project     = "Desafios EZOps"
  Environment = "Test"
  ManagedBy   = "Terraform"
}

###################################################################################################################
################################################## Public Subnets #################################################
###################################################################################################################

#------# Public #------#
subnet_cidr_blocks_public = {
  "us-east-2a" = "10.123.11.0/24"
  "us-east-2b" = "10.123.12.0/24"
}

availability_zones_public = {
  "us-east-2a" = "us-east-2a"
  "us-east-2b" = "us-east-2b"
}

public_subnet_names = {
  "us-east-2a" = "Public-Subnet-AZ-2a"
  "us-east-2b" = "Public-Subnet-AZ-2b"
}

rt_public_name = {
  "us-east-2a" = "Public-APP"
  "us-east-2b" = "Public-APP"
}

tags_public_subnet = {
  Name        = "Subnet Rodrigo - Desafio EZOps"
  Owner       = "Rodrigo Gomes"
  Project     = "Desafios EZOps"
  Environment = "Test"
  ManagedBy   = "Terraform"
}

###################################################################################################################
################################################## Private Subnets #################################################
###################################################################################################################

#------# Private #------#
subnet_cidr_blocks_private = {
  "us-east-2a" = "10.123.21.0/24"
  "us-east-2b" = "10.123.22.0/24"
}

availability_zones_private = {
  "us-east-2a" = "us-east-2a"
  "us-east-2b" = "us-east-2b"
}

private_subnet_names = {
  "us-east-2a" = "Private-Subnet-AZ-2a"
  "us-east-2b" = "Private-Subnet-AZ-2b"
}

rt_private_name = {
  "us-east-2a" = "Private-APP"
  "us-east-2b" = "Private-APP"
}

tags_private_subnet = {
  Name        = "Private Subnet Rodrigo - Desafio EZOps"
  Owner       = "Rodrigo Gomes"
  Project     = "Desafios EZOps"
  Environment = "Test"
  ManagedBy   = "Terraform"
}

tags_route_table_private = {
  Name        = "Private Route Table Rodrigo - Desafio EZOps"
  Owner       = "Rodrigo Gomes"
  Project     = "Desafios EZOps"
  Environment = "Test"
  ManagedBy   = "Terraform"
}

tags_nat_gateway = {
  Name        = "NAT Gateway Rodrigo - Desafio EZOps"
  Owner       = "Rodrigo Gomes"
  Project     = "Desafios EZOps"
  Environment = "Test"
  ManagedBy   = "Terraform"
}