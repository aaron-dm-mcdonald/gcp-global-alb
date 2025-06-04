# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_health_check
# Resource: Global Health Check
resource "google_compute_health_check" "lb" {
  name                = "${var.app_name}-lb-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 3

  http_health_check {
    request_path = "/index.html"
    port         = 80
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_backend_service
# Resource: Global Backend Service
# Rule of thumb: one backend service PER application (our apps are the same but in different regions)
# 
resource "google_compute_backend_service" "lb" {
  name                  = "${var.app_name}-lb-backend-service"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  health_checks         = [ google_compute_health_check.lb.self_link ]
  port_name             = "webserver"
  
  backend {
    group           = google_compute_region_instance_group_manager.region_a.instance_group
    capacity_scaler = 0.5
    balancing_mode  = "UTILIZATION"
  }

  backend {
    group           = google_compute_region_instance_group_manager.region_b.instance_group
    capacity_scaler = 0.5
    balancing_mode  = "UTILIZATION"
  }

  # backend {
  #   group           = google_compute_region_instance_group_manager.region_a.instance_group
  #   capacity_scaler = 1
  #   balancing_mode  = "RATE"
  #   max_rate_per_instance = 5
  # }

  # backend {
  #   group           = google_compute_region_instance_group_manager.region_b.instance_group
  #   capacity_scaler = 1
  #   balancing_mode  = "RATE"
  #   max_rate_per_instance = 5
  # }
}


# Alternative for efficent traffic routing based on IP used
# backend {
#     group           = google_compute_region_instance_group_manager.region_a.instance_group
#     capacity_scaler = 0.5
#     balancing_mode  = "UTILIZATION"
#   }

#   backend {
#     group           = google_compute_region_instance_group_manager.region_b.instance_group
#     capacity_scaler = 0.5
#     balancing_mode  = "UTILIZATION"
#   }