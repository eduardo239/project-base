variable "create_key" {
  description = "Whether to create a service account key"
  type        = bool
  default     = false
}


output "service_account_key" {
  description = "Service account key (sensitive)"
  value       = var.create_key ? google_service_account_key.github_actions_key[0].private_key : null
  sensitive   = true
}