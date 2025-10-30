variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "app-xyz-dev"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

# variable "environment" {
#   description = "Environment name"
#   type        = string
#   default     = "prod"
# }

# variable "service_name" {
#   description = "Service name"
#   type        = string
#   default     = "app1"
# }

# variable "repository_id" {
#   description = "Artifact Registry repository name"
#   type        = string
#   default     = "repoapp1"
# }

# variable "cpu_limit" {
#   description = "CPU limit"
#   type        = string
#   default     = "1"
# }

# variable "memory_limit" {
#   description = "Memory limit"
#   type        = string
#   default     = "512Mi"
# }

# variable "min_instances" {
#   description = "Minimum instances"
#   type        = number
#   default     = 1
# }

# variable "max_instances" {
#   description = "Maximum instances"
#   type        = number
#   default     = 2
# }

# variable "environment_variables" {
#   description = "Environment variables"
#   type        = map(string)
#   default     = {}
# }

# variable "allow_unauthenticated" {
#   description = "Allow unauthenticated access"
#   type        = bool
#   default     = true
# }