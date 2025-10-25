project_id      = "seu-project-id"
region          = "us-central1"
environment     = "prod"
service_name    = "project-base"
repository_id = "meu-repo"

cpu_limit    = "2"
memory_limit = "1Gi"

min_instances = 1
max_instances = 100

environment_variables = {
  ENV = "production"
  LOG_LEVEL = "info"
}

allow_unauthenticated = true