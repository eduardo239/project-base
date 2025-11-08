# module "bigquery_analytics" {
#   source = "../../modules/analytics/bq"

#   project_id   = var.project_id
#   dataset_id   = "analytics_dataset"
#   dataset_name = "Analytics Dataset"
#   location     = "US"

#   description = "Dataset para análises de dados"

#   default_table_expiration_ms = 3600000   # 1 hora em milissegundos

#   labels = {
#     environment = "dev"
#     team = "data-engineering"
#   }

#   access_roles = [
#     {
#       role = "OWNER"
#       user_by_email = "admin@example.com"
#     },
#     {
#       role = "READER"
#       group_by_email = "data-analysts@example.com"
#     }
#   ]


#   tables = [
#     {
#       table_id    = "users"
#       description = "Tabela de usuários"
#       schema      = file("${path.module}/bq-schemas/users_schema.json")
#       time_partitioning = {
#         type  = "DAY"
#         field = "created_at"
#       }
#       clustering = ["user_id", "country"]
#       labels = {
#         data_type = "user_data"
#       }
#     },
#     {
#       table_id    = "events"
#       description = "Tabela de eventos"
#       schema      = file("${path.module}/bq-schemas/events_schema.json")
#       time_partitioning = {
#         type  = "DAY"
#         field = "event_timestamp"
#       }
#       clustering = ["event_type", "user_id"]
#     }
#   ]

#   views = [
#     {
#       view_id     = "active_users"
#       description = "View de usuários ativos"
#       query       = <<-SQL
#         SELECT
#           user_id,
#           email,
#           created_at
#         FROM `${var.project_id}.analytics_dataset.users`
#         WHERE status = 'active'
#       SQL
#       labels = {
#         view_type = "materialized"
#       }
#     }
#   ]
# }