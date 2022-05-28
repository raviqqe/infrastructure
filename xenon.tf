variable "default_source_ranges" {
  default = ["0.0.0.0/0"]
}

data "google_compute_network" "default" {
  name = "default"
}

resource "google_compute_network" "main" {
  name = "main"
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
