variable "vpc_id" {
  description = "The ID of the VPC"
  type = string
}

variable "internet_gateway_id" {
  description = "The ID of Internet Gateway"
  type = string
}

variable "public_subnet_config" {
  description = "Configuration for private subnets"
  type = object({
      name = string  
      cidr_block = string
      availability_zone = string
      private = bool
    })
}