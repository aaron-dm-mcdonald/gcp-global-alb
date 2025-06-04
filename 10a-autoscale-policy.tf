# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_autoscaler
# Resource: MIG Autoscaling
resource "google_compute_region_autoscaler" "region_a" {
  name   = "${var.app_name}-${var.region_a}-autoscaler"
  target = google_compute_region_instance_group_manager.region_a.id
  region = var.region_a

  autoscaling_policy {
    max_replicas    = 4
    min_replicas    = 2
    cooldown_period = 60

    # 50% CPU for autoscaling event
    cpu_utilization {
      target = 0.5
    }
  }
}

