# terraform {
#   required_version = ">= 1.5.0"
#   required_providers {
#     google = {
#       source  = "hashicorp/google"
#       version = "7.8.0"
#     }
#   }
#   backend "gcs" {
#     bucket = "terraform-9237123"
#     prefix = "app-xyz-dev/state"
#   }
# }


# provider "google" {
#   project = "app-xyz-dev"
#   region  = "us-central1"
# }

