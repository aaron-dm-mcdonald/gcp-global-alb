resource "google_compute_region_instance_template" "region_b" {
  name         = "${var.app_name}-${var.region_b}-template"
  description  = "This template is used to clone lizzo"
  region       = var.region_b
  machine_type = "e2-medium"


  # Create a new disk from an image and set as boot disk
  disk {
    source_image = "debian-cloud/debian-12"
    boot         = true
  }

  # Network Configurations 
  network_interface {
    subnetwork = google_compute_subnetwork.region_b.id
    /*access_config {
      # Include this section to give the VM an external IP address
    } */
  }

  # Install Webserver using file() function
  metadata_startup_script = file("./scripts/startup-b.sh")
}

