output "network_name" {
  description = "The name of the VPC network"
  value       = google_compute_network.vpc.name
}

output "network_self_link" {
  description = "The self link of the VPC network"
  value       = google_compute_network.vpc.self_link
}

output "network_id" {
  description = "The ID of the VPC network"
  value       = google_compute_network.vpc.id
}
