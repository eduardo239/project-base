
output "custom_role_id" {
  description = "ID da role customizada criada"
  value       = google_project_iam_custom_role.workbench_user.id
}

output "custom_role_name" {
  description = "Nome completo da role customizada"
  value       = google_project_iam_custom_role.workbench_user.name
}