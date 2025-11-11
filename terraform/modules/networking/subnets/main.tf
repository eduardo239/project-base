resource "google_compute_subnetwork" "public_subnet" {
  name          = "${var.network_name}-public-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = var.network_name

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }

  private_ip_google_access = true
}

resource "google_compute_subnetwork" "private_subnet" {
  name          = "${var.network_name}-private-subnet"
  ip_cidr_range = "10.0.2.0/24"
  region        = var.region
  network       = var.network_name

  private_ip_google_access = true
}
