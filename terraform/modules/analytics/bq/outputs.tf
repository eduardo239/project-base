output "dataset_id" {
  description = "ID do dataset"
  value       = google_bigquery_dataset.dataset.dataset_id
}

output "dataset_self_link" {
  description = "Self link do dataset"
  value       = google_bigquery_dataset.dataset.self_link
}

output "table_ids" {
  description = "IDs das tabelas criadas"
  value       = { for k, v in google_bigquery_table.tables : k => v.table_id }
}

output "view_ids" {
  description = "IDs das views criadas"
  value       = { for k, v in google_bigquery_table.views : k => v.table_id }
}

output "materialized_view_ids" {
  description = "IDs das materialized views"
  value       = { for k, v in google_bigquery_table.materialized_views : k => v.table_id }
}

output "dataset_location" {
  description = "Localização do dataset"
  value       = google_bigquery_dataset.dataset.location
}
