# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "app" {
  name                            = "${var.app_name}-network"
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  mtu                             = 1460
  delete_default_routes_on_create = false

}


