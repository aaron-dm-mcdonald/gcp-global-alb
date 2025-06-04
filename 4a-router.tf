# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router
resource "google_compute_router" "region_a" {
  name    = "${var.region_a}-router"
  region  = var.region_a
  network = google_compute_network.app.id
}


