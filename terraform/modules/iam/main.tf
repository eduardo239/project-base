# Service Account para GitHub Actions
resource "google_service_account" "github_actions" {
  account_id   = var.service_account_name
  display_name = "GitHub Actions Service Account"
  description  = "Service account for CI/CD pipeline"
}

# Permissões para Cloud Run
resource "google_project_iam_member" "cloud_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

# Permissões para Artifact Registry
resource "google_project_iam_member" "artifact_registry_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

# Permissões para Storage (para Cloud Build)
resource "google_project_iam_member" "storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

# Permissão para agir como Service Account
resource "google_service_account_iam_member" "service_account_user" {
  service_account_id = google_service_account.github_actions.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.github_actions.email}"
}

# # Criar chave (usar com cuidado - melhor usar Workload Identity)
# resource "google_service_account_key" "github_actions_key" {
#   count              = var.create_key ? 1 : 0
#   service_account_id = google_service_account.github_actions.name
# }