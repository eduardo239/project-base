terraform {
  required_version = ">= 1.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Habilitar APIs necessárias
resource "google_project_service" "required_apis" {
  for_each = toset([
    "run.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
  ])

  service            = each.value
  disable_on_destroy = false
}

# Artifact Registry
module "artifact_registry" {
  source = "../../modules/artifact-registry"

  region        = var.region
  repository_id = var.repository_id
  description   = "Docker repository for ${var.environment}"

  depends_on = [google_project_service.required_apis]
}

# IAM
module "iam" {
  source = "../../modules/iam"

  project_id           = var.project_id
  service_account_name = "${var.service_name}-${var.environment}-sa"
  create_key           = true # Criar chave para o service account

  depends_on = [google_project_service.required_apis]
}

# Cloud Run
module "cloud_run" {
  source = "../../modules/cloud-run"

  service_name    = var.service_name
  region          = var.region
  container_image = "${module.artifact_registry.repository_url}/${var.service_name}:latest"

  cpu_limit     = var.cpu_limit
  memory_limit  = var.memory_limit
  min_instances = var.min_instances
  max_instances = var.max_instances

  environment_variables = var.environment_variables
  allow_unauthenticated = var.allow_unauthenticated

  depends_on = [
    google_project_service.required_apis,
    module.artifact_registry
  ]
}