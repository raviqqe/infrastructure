resource "google_compute_instance" "xenon" {
  name                      = "xenon"
  machine_type              = "e2-highcpu-4"
  allow_stopping_for_update = true
  tags                      = ["http-server"]
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
    network = "default"

    access_config {}
  }

  scheduling {
    provisioning_model = "SPOT"
  }
}

output "xenon_ip_address" {
  value = google_compute_instance.xenon.network_interface.0.access_config.0.nat_ip
}
