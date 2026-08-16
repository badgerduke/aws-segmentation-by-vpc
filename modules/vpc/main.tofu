locals {
  natgw_subnets = {for key, value in var.environmental_vpc_config[var.vpc_key].public_subnets : key => value if value.nat_gateway == true}
  private_subnet_ec2 = flatten([
    for ec2_key, ec2_val in var.environmental_vpc_config[var.vpc_key].private_subnets.ec2 : [
      for ps_key, ps_val  in module.private_subnets : {
        key    = "${ps_val.subnet_id}-${ec2_key}"
        instance_tag_name    = ec2_val.instance_tag_name
        instance_role_name   = ec2_val.instance_role_name
        user_data_file      = ec2_val.user_data_file
        message  = ec2.message
        subnet_id = ps_val.subnet_id
      }
    ]
  ])

  private_subnet_ec2_map = {for item in local.private_subnet_ec2 : item.key => item}
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
  for_each = var.environmental_vpc_config[var.vpc_key].private_subnets
  vpc_id = module.development_vpc.vpc_id
  private_subnet_config = each.value
  nat_gateway_id = module.nat_gateway.nat_gateway_id
}

module "load_balancer_security_group" {
  source = "./load_balancer_security_group"
}

module "webserver" {
  source = "./webserver"
  for_each = local.private_subnet_ec2_map
  vpc_id = module.vpc.vpc_id
  load_balancer_security_group_id = module.load_balancer_security_group.id
  webserver_config = each.value
}