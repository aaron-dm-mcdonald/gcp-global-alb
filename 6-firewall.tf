# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall

# Direct SSH Access for Lizzo lovers
# For app VPC
resource "google_compute_firewall" "ssh" {
  name    = "${google_compute_network.app.name}-allow-lizzo-ssh"
  network = google_compute_network.app.name
  #direction = "INGRESS" (not needed as it is a default value- see API documentation)

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}


resource "google_compute_firewall" "web-traffic" {
  name    = "${google_compute_network.app.name}-allow-web-traffic"
  network = google_compute_network.app.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Lizzo's ping FW rule
resource "google_compute_firewall" "ping" {
  name    = "${google_compute_network.app.name}-allow-ping"
  network = google_compute_network.app.name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}