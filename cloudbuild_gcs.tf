# Cloudbuild Logs bucket
resource "google_storage_bucket" "cloudbuild_logs" {
  project  = var.project_id
  name     = "${var.resource_name_prefix}cb-logs${var.resource_name_suffix}"
  location = var.cloudbuild_gcs_location
  labels = {
    purpose = "cloudbuild-logs"
    type    = var.trigger_purpose
  }
  uniform_bucket_level_access = true
  force_destroy               = true
}


#  Cloudbuild Artifact bucket
resource "google_storage_bucket" "cloudbuild_artifacts" {
  project  = var.project_id
  name     = "${var.resource_name_prefix}cb-artifacts${var.resource_name_suffix}"
  location = var.cloudbuild_gcs_location
  labels = {
    purpose = "cloudbuild-artifacts"
    type    = var.trigger_purpose
  }
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
  force_destroy = true
}

