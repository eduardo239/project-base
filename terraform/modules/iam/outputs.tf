output "service_account_email" {
  description = "Service account email"
  value       = google_service_account.github_actions_key.email
}

output "service_account_key" {
  description = "Service account key (sensitive)"
  value       = var.create_key ? google_service_account_key.github_actions_key[0].private_key : null
  sensitive   = true
}