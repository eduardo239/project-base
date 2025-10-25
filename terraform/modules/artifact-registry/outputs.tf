output "repository_id" {
  description = "The repository ID"
  value       = google_artifact_registry_repository.docker_repo.id
}

output "repository_url" {
  description = "The repository URL"
  value       = "${var.region}-docker.pkg.dev/${google_artifact_registry_repository.docker_repo.project}/${google_artifact_registry_repository.docker_repo.repository_id}"
}