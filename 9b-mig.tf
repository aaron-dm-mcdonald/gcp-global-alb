# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_zones
# Datasource: Get a list of Google Compute zones that are UP in a region
data "google_compute_zones" "region_b" {
  status = "UP"
  region = var.region_b
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_instance_group_manager
# Resource: Managed Instance Group
resource "google_compute_region_instance_group_manager" "region_b" {
  depends_on         = [google_compute_router_nat.region_b]
  name               = "${var.app_name}-${var.region_b}-mig"
  base_instance_name = "${var.app_name}-private-${var.region_b}"
  region             = var.region_b

  # Compute zones to be used for VM creation
  distribution_policy_zones = data.google_compute_zones.region_b.names

  # Instance Template
  version {
    instance_template = google_compute_region_instance_template.region_b.id
  }

  # Named Port
  named_port {
    name = var.backend_port_name
    port = 80
  }

  # Autohealing Config
  auto_healing_policies {
    health_check      = google_compute_health_check.app.id
    initial_delay_sec = 300
  }
}