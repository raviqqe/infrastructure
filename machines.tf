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

resource "aws_instance" "argon" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
}

resource "google_compute_instance" "xenon" {
  name                      = "xenon"
  machine_type              = "e2-highcpu-4"
  allow_stopping_for_update = true
  tags                      = ["http-server"]
  metadata = {
    ssh-keys = "raviqqe:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM6+38+Cid9vR4T44jZu5cbY5YatdXS9Sh0vnn7ZDimQ raviqqe@gmail.com"
  }

  boot_disk {
    initialize_params {
      size = 256
      type = "pd-balanced"
    }
  }

  network_interface {
    network = "default"

    access_config {}
  }
}
