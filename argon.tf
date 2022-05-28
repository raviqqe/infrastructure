data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

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

resource "aws_security_group_rule" "ingress" {
  security_group_id = aws_security_group.default.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 0
  to_port           = 22
}

resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.default.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 0
  to_port           = 0
}

resource "aws_instance" "argon" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.neon.key_name
  security_groups = [aws_security_group.default.id]
}

output "argon_domain_name" {
  value = aws_instance.argon.public_dns
}
