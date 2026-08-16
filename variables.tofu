variable "environmental_vpc_config" {
  description = "Configuration for environemnt VPCs"
  type = map(object({
    name = string
    cidr_block = string
    private_subnets = map(object({
      name = string  
      cidr_block = string
      availability_zone = string
      ec2 = map(object({
        webserver_tag_name = string
        webserver_role_name = string
        user_data_file = string
        message = string
      }))
    }))
    public_subnets = map(object({
        name = string
        cidr_block = string
        availability_zone = string
        nat_gateway = bool
        load_balancer = bool
    }))
  }))
}