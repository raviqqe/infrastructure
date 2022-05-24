resource "google_compute_instance" "xenon" {
  name         = "xenon"
  machine_type = "e2-highcpu-4"
  zone         = "us-west1-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-20"
    }
  }

  network_interface {
    network = "default"
  }
}
