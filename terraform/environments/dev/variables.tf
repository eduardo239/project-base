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

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "service_name" {
  description = "Service name"
  type        = string
  default     = "app1"
}

variable "repository_id" {
  description = "Artifact Registry repository name"
  type        = string
  default     = "repoapp1"
}

variable "cpu_limit" {
  description = "CPU limit"
  type        = string
  default     = "1"
}

variable "memory_limit" {
  description = "Memory limit"
  type        = string
  default     = "512Mi"
}

variable "min_instances" {
  description = "Minimum instances"
  type        = number
  default     = 1
}

variable "max_instances" {
  description = "Maximum instances"
  type        = number
  default     = 2
}

variable "environment_variables" {
  description = "Environment variables"
  type        = map(string)
  default     = {}
}

variable "allow_unauthenticated" {
  description = "Allow unauthenticated access"
  type        = bool
  default     = true
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
  default     = "vpc-network-dev"
}

## ci-cd build
variable "github_owner" {
  description = "GitHub repository owner"
  type        = string
  default     = "eduardo239"
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "project-base"
}