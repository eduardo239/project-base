variable "region" {
  description = "GCP region"
  type        = string
}

variable "repository_id" {
  description = "ID of the Artifact Registry repository"
  type        = string
}

variable "description" {
  description = "Repository description"
  type        = string
  default     = "Docker repository"
}

variable "immutable_tags" {
  description = "Enable immutable tags"
  type        = bool
  default     = false
}

variable "format" {
  description = "Format of the repository"
  type        = string
  default     = "DOCKER"
}