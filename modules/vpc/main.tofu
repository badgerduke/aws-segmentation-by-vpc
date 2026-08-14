locals {
  natgw_subnets = {for key, value in var.environmental_vpc_config[var.vpc_key].public_subnets : key => value if value.nat_gateway == true}
}

module "vpc" {
  source = "./vpc"
  vpc_config = var.environmental_vpc_config[var.vpc_key]
}

module "nat_gateway_public_subnets" {
  source = "./nat_gateway_public_subnet"
  for_each = local.natgw_subnets
  vpc_id = module.development_vpc.vpc_id
  internet_gateway_id = module.vpc.igw_id
  public_subnet_config = each.value
}

module "nat_gateway" {
  source = "./nat_gateway"
  # Choose one of the natgw public sunsets for the NAT Gateway
  subnet_id = values(module.nat_gateway_public_subnets)[0]
}


module "private_subnets" {
  source = "./private_subnets"
  vpc_id = module.development_vpc.vpc_id
  private_subnet_config = var.environmental_vpc_config["dev_vpc"].private_subnets
  nat_gateway_id = module.nat_gateway.nat_gateway_id
}