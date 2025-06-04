# Client -> Static IP -> Fwd Rule -> HTTP Proxy -> URL Map (URL Map chooses backend service)

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address
# Resource: Reserve Global Static IP Address
resource "google_compute_global_address" "lb" {
  name   = "lb-static-ip"
 
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map
# Resource: Global URL Map
# Purpose: Routes incoming HTTP(S) requests to appropriate backend services based on URL path rules.
# Since we're not specifying custom path matchers, all requests are sent to the default backend.

resource "google_compute_url_map" "lb" {
  name = "${var.app_name}-lb-url-map"

  # The default backend service to route requests to when no path matcher rules are defined.
  # This is where all traffic goes unless otherwise routed.
  default_service = google_compute_backend_service.lb.self_link
}


# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_http_proxy
# Resource: Global HTTP Proxy
# Purpose: Acts as the intermediary between the URL map and the frontend forwarding rule.
# The proxy interprets HTTP requests and applies URL map routing rules.

resource "google_compute_target_http_proxy" "lb" {
  name = "${var.app_name}-lb-http-proxy"

  # Reference to the URL map resource that defines the routing behavior.
  url_map = google_compute_url_map.lb.self_link
}


# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_forwarding_rule
# Resource: Global Forwarding Rule
# Purpose: This is the external-facing component of the load balancer.
# It listens for incoming traffic on a specified IP and port, and forwards it to the appropriate target proxy.
# In global load balancers, this is where traffic from the public internet first arrives.

resource "google_compute_global_forwarding_rule" "lb" {
  name       = "${var.app_name}-lb-forwarding-rule"

  # Specifies the target proxy (in this case, an HTTP proxy) to which the traffic should be forwarded.
  # The proxy then uses the URL map to route requests to the correct backend service.
  target     = google_compute_target_http_proxy.lb.self_link

  port_range            = "80"
  ip_protocol           = "TCP"

  # The static global IP address that this rule listens on.
  # This must be reserved beforehand via google_compute_global_address.
  ip_address = google_compute_global_address.lb.address

  # Indicates that this load balancer uses the "next-gen" external managed load balancing architecture.
  # This is required for global external HTTP(S) load balancers.
  load_balancing_scheme = "EXTERNAL_MANAGED"
}


