resource "google_filestore_instance" "instance" {
  name     = var.filestore_instance_name
  location = var.location
  tier     = "BASIC_HDD"

  file_shares {
    capacity_gb = 1024
    name        = "share1"
  }

  networks {
    network = "default"
    modes   = ["MODE_IPV4"]
  }
}
