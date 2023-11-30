# Example on how to invoke this module.

# provider config
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0"
    }
  }
}

module "meta_trigger" {
  source = "./.."

  resource_name_prefix           = "meta-"
  resource_name_suffix           = "-bootstrap"
  project_id                     = "<your-project-id>"
  included_files_list            = ["envs/*", "envs/onboard/**"]
  builder_full_name              = "<your-builder-name>"
  terragrunt_run_level_directory = "envs/onboard"
  solution_folder                = "<folder-with-the-solution>"
  meta_sa_folder_roles_list = [
    "roles/editor",
    "roles/secretmanager.secretAccessor",
    "roles/resourcemanager.projectIamAdmin"
  ]
  cloudbuild_gcs_location = "europe-west1"
  trigger_location        = "europe-west1"
  trigger_purpose         = "meta"
  common_project          = "<common-project-id>"
  cb_repository_id        = "<repository-id>"
  access_token_secret_id  = "gh-access-token"
}
