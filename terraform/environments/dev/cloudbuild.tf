module "cloud-build" {
  source = "../../modules/ci-cd/cloudbuild"

  github_owner = var.github_owner
  github_repo  = var.github_repo
  project_id   = var.project_id

  depends_on = [google_project_service.required_apis]
}



