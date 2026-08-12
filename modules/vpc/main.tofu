locals {

  dev_natgw_subnets = {for key, value in var.environmental_vpc_config["dev_vpc"].public_subnets : key => value if value.nat_gateway == true}
  dev_natgw_subnet_ids = [for subnet_id in module.development_public_subnets.subnet_id : subnet_id if subnet_id == [for subnet in dev_natgw_subnets: ]
  dev_natgw_subnet_ids = [for subnet_id in ] 
    
    
  }]
    source = ""
    
  }.public_subnets : ]
}

module "development_vpc" {
  source = "./vpc"
  vpc_config = var.environmental_vpc_config["dev_vpc"]
}s

module "development_public_subnets" {
  source = "./public_subnets"
  vpc_id = module.development_vpc.vpc_id
  internet_gateway_id = module.development_vpc.igw_id
  public_subnet_config = var.environmental_vpc_config["dev_vpc"].public_subnets
}

module "development_nat_gateway" {
  source = "./nat_gateways"
}


module "development_private_subnets" {
  source = "./private_subnets"
  vpc_id = module.development_vpc.vpc_id
  private_subnet_config = var.environmental_vpc_config["dev_vpc"].private_subnets
  nat_gateway_id = 
}