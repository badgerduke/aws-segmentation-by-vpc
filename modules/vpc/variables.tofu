variable "environmental_vpc_config" {
  description = "Configuration for environemnt VPCs"
  type = object({
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
  })
}

variable "vpc_key" {
  description = "The key value of a VPC map associated with this environmental_vpc_config"
  type = string
}