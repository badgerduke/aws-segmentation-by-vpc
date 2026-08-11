variable "vpc_config" {
  description = "Configuration for environemnt VPCs"
  type = map(object({
    name = string
    cidr_block = string
    private_subnets = map(object({
      name = string  
      cidr_block = string
      availability_zone = string
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