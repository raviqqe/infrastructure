variable "default_source_ranges" {
  default = ["0.0.0.0/0"]
}

resource "google_compute_network" "main" {
  name = "main"
}

resource "google_compute_firewall" "ssh" {
  name          = "ssh"
  network       = google_compute_network.default.name
  source_ranges = var.default_source_ranges

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["ssh"]
}

resource "google_compute_firewall" "mosh" {
  name          = "mosh"
  network       = google_compute_network.default.name
  source_ranges = var.default_source_ranges

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

resource "google_compute_firewall" "http" {
  name          = "http"
  network       = google_compute_network.default.name
  source_ranges = var.default_source_ranges

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  target_tags = ["http"]
}

resource "google_compute_instance" "xenon" {
  name                      = "xenon"
  machine_type              = "e2-highcpu-4"
  allow_stopping_for_update = true
  tags                      = ["http", "mosh", "ssh"]
  metadata = {
    ssh-keys = join(":", [var.ssh_user, var.ssh_public_key])
  }

  boot_disk {
    initialize_params {
      size = 256
      type = "pd-balanced"
    }
  }

  network_interface {
    network = google_compute_network.default.name

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
