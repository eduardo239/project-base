project_id    = "app-xyz-dev"
region        = "us-central1"
environment   = "dev"
service_name  = "project-base"
repository_id = "meu-repo"

cpu_limit    = "2"
memory_limit = "1Gi"

min_instances = 1
max_instances = 100

environment_variables = {
  ENV       = "development"
  LOG_LEVEL = "info"
}

allow_unauthenticated = true

github_owner = "eduardo239"
github_repo  = "github-repo"
repo_name    = "source-repo"