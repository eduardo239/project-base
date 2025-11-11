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

# Removed unused variables - can be re-added when needed
# variable "environment" { ... }
# variable "service_name" { ... }
# variable "repository_id" { ... }

# Cloud Run variables - currently unused but available for future use
# variable "cpu_limit" { ... }
# variable "memory_limit" { ... }
# variable "min_instances" { ... }
# variable "max_instances" { ... }
# variable "environment_variables" { ... }
# variable "allow_unauthenticated" { ... }

# Network and CI/CD variables - currently unused
# variable "network_name" { ... }
# variable "github_owner" { ... }
# variable "github_repo" { ... }

# Storage and messaging variables - currently unused
# variable "location" { ... }
# variable "topic_name" { ... }
# variable "subscription_name" { ... }

# Keep this one as it might be used
# variable "message_retention_duration" {}
