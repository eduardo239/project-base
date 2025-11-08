
# module "vpc" {
#   source = "../../modules/networking/vpc"
#   project_id   = var.project_id
#   network_name = var.network_name
#   depends_on = [google_project_service.required_apis]
# }

# module "subnets" {
#   source = "../../modules/networking/subnets"
#   project_id   = var.project_id
#   network_name = module.vpc.network_name
#   region       = var.region
#   depends_on = [module.vpc]
# }
