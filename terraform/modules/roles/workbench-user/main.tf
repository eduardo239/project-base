# Role customizada para usuários do Workbench
resource "google_project_iam_custom_role" "workbench_user" {
  role_id     = var.role_id
  title       = var.role_title
  description = "Role customizada para usuários do Vertex AI Workbench com permissões limitadas"
  project     = var.project_id

  permissions = [
    # Permissões para visualizar e listar instâncias do Workbench
    "notebooks.instances.list",
    "notebooks.instances.get",
    "notebooks.instances.checkUpgradability",

    # Permissões para iniciar e parar instâncias
    "notebooks.instances.start",
    "notebooks.instances.stop",
    "notebooks.instances.reset",

    # Permissões para acessar notebooks
    "notebooks.instances.use",

    # Permissões para visualizar operações
    "notebooks.operations.get",
    "notebooks.operations.list",

    # Permissões para visualizar localizações
    "notebooks.locations.get",
    "notebooks.locations.list",

    # Permissões básicas do Compute Engine (necessárias para Workbench)
    "compute.instances.get",
    "compute.instances.list",
    "compute.zones.list",
    "compute.regions.list",

    # Permissões para Storage (para salvar notebooks)
    "storage.buckets.list",
    "storage.buckets.get",
    "storage.objects.list",
    "storage.objects.get",
    "storage.objects.create",
    "storage.objects.delete",

    # Permissões para visualizar o projeto
    "resourcemanager.projects.get",
  ]

  # Define o estágio da role (ALPHA, BETA, GA, DEPRECATED)
  stage = "GA"
}

# Atribuir a role customizada a um usuário ou grupo
resource "google_project_iam_member" "workbench_user_binding" {
  project = var.project_id
  role    = google_project_iam_custom_role.workbench_user.id
  member  = "user:usuario@exemplo.com" # Substitua pelo email do usuário
}
