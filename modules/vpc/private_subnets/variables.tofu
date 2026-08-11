variable "vpc_id" {
  description = "The ID of the VPC"
  type = string
}

variable "nat_gateway_id" {
  description = "The ID of NAT Gateway"
  type = string
}

variable "private_subnet_config" {
  description = "Configuration for private subnets"
  type = object({
      name = string  
      cidr_block = string
      availability_zone = string
      private = bool
    })
}