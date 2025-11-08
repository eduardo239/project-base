resource "random_id" "bucket_suffix" {
  byte_length = 4
}


resource "google_storage_bucket" "terraform_state" {
  name          = "terraform-state-bucket-${random_id.bucket_suffix.hex}"
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  lifecycle {
    prevent_destroy = false
  }

  versioning {
    enabled = true
  }
}