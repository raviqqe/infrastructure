data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
}

# TODO
# resource "google_compute_instance" "xenon" {
#   name         = "xenon"
#   machine_type = "e2-highcpu-4"
#   zone         = "us-west1-b"

#   boot_disk {
#     initialize_params {
#       image = "ubuntu-20"
#     }
#   }

#   network_interface {
#     network = "default"
#   }
# }
