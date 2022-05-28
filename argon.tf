variable "canonical_owner_id" {
  default = "099720109477"
}

variable "default_cidr_blocks" {
  default = ["0.0.0.0/0"]
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = [var.canonical_owner_id]

  filter {
    name   = "creation-date"
    values = ["2022-04-*"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "neon" {
  public_key = var.ssh_public_key
}

resource "aws_security_group" "default" {}

resource "aws_security_group_rule" "ssh" {
  security_group_id = aws_security_group.default.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = var.default_cidr_blocks
}

resource "aws_security_group_rule" "mosh" {
  security_group_id = aws_security_group.default.id
  type              = "ingress"
  protocol          = "udp"
  from_port         = 60000
  to_port           = 61000
  cidr_blocks       = var.default_cidr_blocks
}

resource "aws_security_group_rule" "http" {
  security_group_id = aws_security_group.default.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8080
  to_port           = 8080
  cidr_blocks       = var.default_cidr_blocks
}

resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.default.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = var.default_cidr_blocks
}

resource "aws_spot_instance_request" "argon" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t4g.micro"
  key_name               = aws_key_pair.neon.key_name
  vpc_security_group_ids = [aws_security_group.default.id]
}

output "argon_domain_name" {
  value = aws_instance.argon.public_dns
}
