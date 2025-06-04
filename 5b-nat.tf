resource "google_compute_router_nat" "region_b" {
  name   = "${var.region_b}-nat"
  router = google_compute_router.region_b.name
  region = var.region_b

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option             = "MANUAL_ONLY"

  subnetwork {
    name                    = google_compute_subnetwork.region_b.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  nat_ips = [google_compute_address.region_b.self_link]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address
resource "google_compute_address" "region_b" {
  name         = "${var.region_b}-nat"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
  region       = var.region_b
}