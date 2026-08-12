resource "aws_subnet" "this" {
  vpc_id     = var.vpc_id
  cidr_block = var.public_subnet_config.cidr_block
  availability_zone = var.public_subnet_config.availability_zone

  tags = {
    Name = var.public_subnet_config.name
  }
}

resource "aws_route_table" "this" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }

  tags = {
    Name = "${var.private_subnet_config.name}-rt"
  }
}

resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.this.subnet_id
  route_table_id = aws_route_table.this.id
}