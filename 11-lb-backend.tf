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

resource "google_compute_backend_service" "lb" {
  name                  = "${var.app_name}-lb-backend-service"
  protocol              = "HTTP"
  
  # Specifies the type of load balancing. 
  # EXTERNAL_MANAGED is required for global HTTP(S) load balancing (not classic)
  load_balancing_scheme = "EXTERNAL_MANAGED"

  # HC must be global when using EXTERNAL_MANAGED.
  health_checks         = [ google_compute_health_check.lb.self_link ]

  # Named port used by the backend VMs (must match the named port on instance groups).
  port_name             = "webserver"

  # Backend for Region A
  backend {
    group                = google_compute_region_instance_group_manager.region_a.instance_group
    capacity_scaler      = 1
    balancing_mode       = "RATE"
    max_rate_per_instance = 10  # Adjust this value based on your use case
  }

  # Backend for Region B
  backend {
    group                = google_compute_region_instance_group_manager.region_b.instance_group
    capacity_scaler      = 1
    balancing_mode       = "RATE"
    max_rate_per_instance = 10  # Adjust this value as well
  }
 
}




### alternative

#  # Backend for Region A
#   backend {
#     # Reference to the managed instance group in region_a
#     group           = google_compute_region_instance_group_manager.region_a.instance_group

#     # Limits the portion of backend capacity that can be used.
#     # 0.5 means only 50% of backend capacity is used for load balancing.
#     capacity_scaler = 1

#     # Defines how traffic is distributed to this backend.
#     # UTILIZATION mode distributes traffic based on VM usage/load.
#     balancing_mode  = "UTILIZATION"
#   }

#   # Backend for Region B
#   backend {
#     # Reference to the managed instance group in region_b
#     group           = google_compute_region_instance_group_manager.region_b.instance_group
#     capacity_scaler = 1
#     balancing_mode  = "UTILIZATION"
#   }