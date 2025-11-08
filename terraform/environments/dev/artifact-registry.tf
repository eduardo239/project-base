# # Artifact Registry
# module "artifact_registry" {
#   source = "../../modules/artifact-registry"

#   region        = var.region
#   repository_id = var.repository_id
#   description   = "Docker repository for ${var.environment}"

#   depends_on = [google_project_service.required_apis]
# }

# # IAM
# module "iam" {
#   source = "../../modules/iam"

#   project_id           = var.project_id
#   service_account_name = "${var.service_name}-${var.environment}-sa"
#   # create_key           = false # Usar Workload Identity em vez de chaves

#   depends_on = [google_project_service.required_apis]
# }
