# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat
resource "google_compute_router_nat" "region_a" {
  name   = "${var.region_a}-nat"
  router = google_compute_router.region_a.name
  region = var.region_a

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option             = "MANUAL_ONLY"

  subnetwork {
    name                    = google_compute_subnetwork.region_a.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  nat_ips = [google_compute_address.region_a.self_link]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address
resource "google_compute_address" "region_a" {
  name         = "${var.region_a}-nat"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
  region       = var.region_a
}


