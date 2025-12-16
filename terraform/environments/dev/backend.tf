terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.8.0"
    }
  }
  backend "gcs" {
    bucket = "terraform-state-0000000"
    prefix = "app-lastbit-dev/state"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
