variable "access_token_secret_id" {
  description = "ID of the secret containing GH access token."
  type        = string
  default     = ""
}

variable "common_project" {
  description = "ID of the project that hosts \"meta\" triggers and other general resources."
  type        = string
}

variable "builder_full_name" {
  description = "Name of the image that will be utilised by config jobs."
  type        = string
}

variable "terragrunt_run_level_directory" {
  description = "Directory where Terragrunt will run."
  type        = string
}
