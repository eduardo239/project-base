resource "google_cloudbuild_trigger" "main_trigger" {
  name        = "main-branch-trigger"
  description = "Trigger for main branch pushes"
  filename    = "cloudbuild.yaml"

  github {
    owner = var.github_owner
    name  = var.github_repo

    push {
      branch = "^main$"
    }
  }
}

resource "google_sourcerepo_repository" "repo" {
  name = var.repo_name
}

# Service Account para Cloud Build (opcional)
resource "google_service_account" "cloudbuild_sa" {
  account_id   = "cloudbuild-sa"
  display_name = "Cloud Build Service Account"
}

resource "google_project_iam_member" "cloudbuild_roles" {
  for_each = toset([
    "roles/cloudbuild.builds.builder",
    "roles/storage.admin",
    "roles/logging.logWriter"
  ])

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.cloudbuild_sa.email}"
}