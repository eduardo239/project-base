variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "service_account_name" {
  description = "Service account name"
  type        = string
  default     = "github-actions"
}

# variable "create_key" {
#   description = "Create service account key"
#   type        = bool
#   default     = false
# }