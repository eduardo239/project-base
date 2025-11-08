module "cloud-build" {
  source = "../../modules/ci-cd/cloudbuild"

  github_owner = var.github_owner
  github_repo  = var.github_repo
  repo_name    = var.repo_name
  project_id   = var.project_id
}