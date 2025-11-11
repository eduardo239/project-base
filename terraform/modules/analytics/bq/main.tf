# Dataset
resource "google_bigquery_dataset" "dataset" {
  dataset_id    = var.dataset_id
  friendly_name = var.dataset_name
  description   = var.description
  location      = var.location
  project       = var.project_id

  default_table_expiration_ms     = var.default_table_expiration_ms
  default_partition_expiration_ms = var.default_partition_expiration_ms

  labels = var.labels

  delete_contents_on_destroy = var.delete_contents_on_destroy

  dynamic "access" {
    for_each = var.access_roles
    content {
      role           = access.value.role
      user_by_email  = try(access.value.user_by_email, null)
      group_by_email = try(access.value.group_by_email, null)
      domain         = try(access.value.domain, null)
      special_group  = try(access.value.special_group, null)

      dynamic "view" {
        for_each = access.value.view != null ? [access.value.view] : []
        content {
          project_id = view.value.project_id
          dataset_id = view.value.dataset_id
          table_id   = view.value.table_id
        }
      }
    }
  }

  dynamic "default_encryption_configuration" {
    for_each = var.encryption_key != null ? [1] : []
    content {
      kms_key_name = var.encryption_key
    }
  }
}

# Tables
resource "google_bigquery_table" "tables" {
  for_each = { for table in var.tables : table.table_id => table }

  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = each.value.table_id
  project    = var.project_id

  description = try(each.value.description, null)
  labels      = try(each.value.labels, {})
  schema      = try(each.value.schema, null)

  deletion_protection = try(each.value.deletion_protection, false)
  expiration_time     = try(each.value.expiration_time, null)

  dynamic "time_partitioning" {
    for_each = each.value.time_partitioning != null ? [each.value.time_partitioning] : []
    content {
      type          = time_partitioning.value.type
      field         = try(time_partitioning.value.field, null)
      expiration_ms = try(time_partitioning.value.expiration_ms, null)
    }
  }

  dynamic "range_partitioning" {
    for_each = each.value.range_partitioning != null ? [each.value.range_partitioning] : []
    content {
      field = range_partitioning.value.field
      range {
        start    = range_partitioning.value.range.start
        end      = range_partitioning.value.range.end
        interval = range_partitioning.value.range.interval
      }
    }
  }

  clustering = try(each.value.clustering, null)

  dynamic "encryption_configuration" {
    for_each = var.encryption_key != null ? [1] : []
    content {
      kms_key_name = var.encryption_key
    }
  }

  depends_on = [google_bigquery_dataset.dataset]
}

# Views
resource "google_bigquery_table" "views" {
  for_each = { for view in var.views : view.view_id => view }

  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = each.value.view_id
  project    = var.project_id

  description = try(each.value.description, null)
  labels      = try(each.value.labels, {})

  view {
    query          = each.value.query
    use_legacy_sql = try(each.value.use_legacy_sql, false)
  }

  deletion_protection = try(each.value.deletion_protection, false)

  depends_on = [
    google_bigquery_dataset.dataset,
    google_bigquery_table.tables
  ]
}

# Materialized Views
resource "google_bigquery_table" "materialized_views" {
  for_each = { for mv in var.materialized_views : mv.view_id => mv }

  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = each.value.view_id
  project    = var.project_id

  description = try(each.value.description, null)
  labels      = try(each.value.labels, {})

  materialized_view {
    query                            = each.value.query
    enable_refresh                   = try(each.value.enable_refresh, true)
    refresh_interval_ms              = try(each.value.refresh_interval_ms, 1800000)
    allow_non_incremental_definition = try(each.value.allow_non_incremental_definition, false)
  }

  depends_on = [
    google_bigquery_dataset.dataset,
    google_bigquery_table.tables
  ]
}

# Scheduled Queries (Data Transfer)
resource "google_bigquery_data_transfer_config" "scheduled_queries" {
  for_each = { for sq in var.scheduled_queries : sq.display_name => sq }

  display_name           = each.value.display_name
  location               = var.location
  data_source_id         = "scheduled_query"
  schedule               = each.value.schedule
  destination_dataset_id = google_bigquery_dataset.dataset.dataset_id

  params = {
    query                           = each.value.query
    destination_table_name_template = try(each.value.destination_table, null)
    write_disposition               = try(each.value.write_disposition, "WRITE_TRUNCATE")
    partitioning_field              = try(each.value.partitioning_field, "")
  }

  disabled = try(each.value.disabled, false)

  depends_on = [google_bigquery_dataset.dataset]
}

# IAM Bindings for Dataset
resource "google_bigquery_dataset_iam_binding" "dataset_iam" {
  for_each = var.iam_bindings

  dataset_id = google_bigquery_dataset.dataset.dataset_id
  project    = var.project_id
  role       = each.key
  members    = each.value
}
