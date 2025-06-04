resource "google_compute_router" "region_b" {
  name    = "${var.region_b}-router"
  region  = var.region_b
  network = google_compute_network.app.id
}
