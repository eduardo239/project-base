resource "google_filestore_instance" "instance" {
  name     = "test-instance"
  location = "us-central1-a"
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