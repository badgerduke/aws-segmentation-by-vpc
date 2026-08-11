variable "vpc_config" {
  description = "Represents the configuration for a VPC"
  type = object({
    name = string
    cidr_block = string
    subnets = map(object({
      cidr_block = string
    }))
  })
}