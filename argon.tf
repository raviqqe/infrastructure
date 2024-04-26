locals {
  canonical_owner_id  = "099720109477"
  default_cidr_blocks = ["0.0.0.0/0"]
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = [local.canonical_owner_id]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd*/ubuntu-noble-24.04-*-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }
}

resource "aws_key_pair" "argon" {
  public_key = local.ssh.public_key
}

resource "aws_security_group" "default" {}

resource "aws_security_group_rule" "ssh" {
  security_group_id = aws_security_group.default.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = local.default_cidr_blocks
}

resource "aws_security_group_rule" "mosh" {
  security_group_id = aws_security_group.default.id
  type              = "ingress"
  protocol          = "udp"
  from_port         = 60000
  to_port           = 61000
  cidr_blocks       = local.default_cidr_blocks
}

resource "aws_security_group_rule" "http" {
  security_group_id = aws_security_group.default.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8080
  to_port           = 8080
  cidr_blocks       = local.default_cidr_blocks
}

resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.default.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = local.default_cidr_blocks
}

resource "aws_spot_instance_request" "argon" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t4g.micro"
  key_name               = aws_key_pair.argon.key_name
  vpc_security_group_ids = [aws_security_group.default.id]
  wait_for_fulfillment   = true
}

resource "aws_eip" "argon" {
  instance = aws_spot_instance_request.argon.spot_instance_id
}
