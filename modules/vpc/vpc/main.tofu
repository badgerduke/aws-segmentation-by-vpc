resource "aws_vpc" "this" {
  cidr_block       = var.vpc_config.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_config.name
  }
}
