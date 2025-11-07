variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}
variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}
variable "region" {
  description = "The region where the subnetwork will be created"
  type        = string
}
