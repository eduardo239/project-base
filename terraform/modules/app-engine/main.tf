terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

resource "google_app_engine_application" "app" {
  project     = var.project_id
  location_id = var.region
}
