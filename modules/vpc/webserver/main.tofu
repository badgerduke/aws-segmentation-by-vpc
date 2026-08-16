resource "aws_instance" "webserver" {
  subnet_id = var.webserver_config.subnet_id
  ami = data.aws_ami.rhel9_latest.image_id
  instance_type = "t3.medium"
  tenancy = "default"
  user_data = templatefile("${path.module}/${var.webserver_config.user_data_file}", {
    message = var.webserver_config.message
  })
  vpc_security_group_ids = [aws_security_group.this.id]
  iam_instance_profile = aws_iam_instance_profile.this.name
}

data "aws_ami" "rhel9_latest" {
    most_recent = true
    owners = ["309956199498"]
    filter {
      name = "name"
      values = ["RHEL-9*"]
    }
    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }
    filter {
      name = "architecture"
      values = ["x86_64"]
    }
}

resource "aws_security_group" "this" {
  description = "Webserver security group"
  name = "${var.webserver_config.instance_tag_name}-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.webserver_config.instance_tag_name}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_80_from_load_balancer" {
    description = "Allow 80 from load balancer"
    security_group_id = aws_security_group.this.id
    ip_protocol = "tcp"
    referenced_security_group_id = var.load_balancer_security_group_id
    from_port = 80
    to_port = 80

    tags = {
      Name = "${var.webserver_config.instance_tag_name}-sg-rule-allow-80-from-load-balancer"
    }
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  description = "Allow all egress"
  security_group_id = aws_security_group.this.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"

  tags = {
    Name = "${var.webserver_config.instance_tag_name}-sg-rule-allow-all-egress"
  }
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.webserver_config.instance_tag_name}-instance-profile"
  role = aws_iam_role.this.name
}

resource "aws_iam_role" "this" {
    name = "${var.webserver_config.instance_role_name}"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid = "AllowEC2"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            }
        ]
    })

    tags = {
      tag-key = "${var.webserver_config.instance_role_name}"
    }
}

resource "aws_iam_role_policy_attachment" "bastion_role_attach_ssm_managed_policy" {
    role = aws_iam_role.this.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

