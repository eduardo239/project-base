terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.8.0"
    }
  }
  backend "gcs" {
    bucket = "terraform-state-bucket-e08795ed"
    prefix = "prod/state"
  }
}


provider "google" {
  project = var.project_id
  region  = var.region
}
