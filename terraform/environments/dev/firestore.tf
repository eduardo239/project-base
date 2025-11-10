module "firestore" {
  source     = "../../modules/storage/firestore"
  project_id = var.project_id
}