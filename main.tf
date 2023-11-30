module "config_locals" {
  source = "./inner_modules/cloudbuild_config"

  access_token_secret_id         = var.access_token_secret_id
  common_project                 = var.common_project
  builder_full_name              = var.builder_full_name
  terragrunt_run_level_directory = var.terragrunt_run_level_directory
}
