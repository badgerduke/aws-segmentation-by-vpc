resource "aws_vpc" "this" {
  cidr_block       = var.vpc_config.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_config.name
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_config.name}-igws"
  }
}


