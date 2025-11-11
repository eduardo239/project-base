module "workbench-user-role" {
  source       = "../../modules/roles/workbench-user"
  role_title = "Workbench User Dev"
  role_id    = "workbenchUserDev"
  project_id = var.project_id
}