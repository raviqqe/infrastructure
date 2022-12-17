locals {
  default_source_ranges = ["0.0.0.0/0"]
}

data "google_compute_network" "default" {
  name = "default"
}

resource "google_compute_address" "xenon" {
  name = "xenon"
}

resource "google_compute_firewall" "http" {
  name          = "http"
  network       = data.google_compute_network.default.name
  source_ranges = local.default_source_ranges

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  target_tags = ["http"]
}

resource "google_compute_firewall" "mosh" {
  name          = "mosh"
  network       = data.google_compute_network.default.name
  source_ranges = local.default_source_ranges

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "udp"
    ports    = ["60000-61000"]
  }

  target_tags = ["mosh"]
}

resource "google_compute_firewall" "ssh" {
  name          = "ssh"
  network       = data.google_compute_network.default.name
  source_ranges = local.default_source_ranges

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["ssh"]
}

resource "google_compute_instance" "xenon" {
  name                      = "xenon"
  machine_type              = "e2-highcpu-2"
  allow_stopping_for_update = true
  tags                      = ["http", "mosh", "ssh"]

  metadata = {
    ssh-keys       = join(":", [local.ssh.user, local.ssh.public_key])
    startup-script = <<-EOF
apt -y update --fix-missing
apt -y install build-essential git rcm zsh
apt -y upgrade
EOF
  }

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
      type  = "pd-standard"
      size  = 32
    }
  }

  network_interface {
    network = data.google_compute_network.default.name

    access_config {
      nat_ip = google_compute_address.xenon.address
    }
  }

  scheduling {
    provisioning_model = "SPOT"
    preemptible        = true
    automatic_restart  = false
  }
}

data "google_compute_image" "ubuntu" {
  project = "ubuntu-os-cloud"
  family  = "ubuntu-2204-lts"
}
