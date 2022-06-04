locals {
  default_source_ranges = ["0.0.0.0/0"]
}

data "google_compute_network" "default" {
  name = "default"
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
  machine_type              = "e2-highcpu-4"
  allow_stopping_for_update = true
  tags                      = ["http", "mosh", "ssh"]
  metadata = {
    ssh-keys = join(":", [local.ssh.user, local.ssh.public_key])
  }

  boot_disk {
    initialize_params {
      size = 256
      type = "pd-standard"
    }
  }

  network_interface {
    network = data.google_compute_network.default.name

    access_config {}
  }

  scheduling {
    provisioning_model = "SPOT"
    preemptible        = true
    automatic_restart  = false
  }
}

output "xenon_ip_address" {
  value = google_compute_instance.xenon.network_interface.0.access_config.0.nat_ip
}
