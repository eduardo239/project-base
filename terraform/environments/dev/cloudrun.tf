# # Cloud Run
# module "cloud_run" {
#   source = "../../modules/cloud-run"

#   service_name = var.service_name
#   region       = var.region
#   # container_image = "${module.artifact_registry.repository_url}/${var.service_name}:latest"
#   container_image = "us-central1-docker.pkg.dev/app-xyz-dev/meu-repo/app1:latest"

#   cpu_limit     = var.cpu_limit
#   memory_limit  = var.memory_limit
#   min_instances = var.min_instances
#   max_instances = var.max_instances

#   environment_variables = var.environment_variables
#   allow_unauthenticated = var.allow_unauthenticated

#   depends_on = [
#     google_project_service.required_apis,
#     module.artifact_registry
#   ]
# }
