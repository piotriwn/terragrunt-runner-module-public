variable "resource_name_prefix" {
  description = "Prefix for the resource names."
  type        = string

}

variable "resource_name_suffix" {
  description = "Suffix for the resource names."
  type        = string
}

variable "project_id" {
  description = "ID of the project that will host the Cloud Build-related resources."
  type        = string
}

variable "included_files_list" {
  description = "List of files that will be included in the Cloud Build configuration."
  type        = list(string)
}

variable "trigger_location" {
  description = "Location of the CB trigger (e.g. global or specified region)."
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

variable "sa_roles_list" {
  description = "The list of roles that will be granted to the SA linked to Cloud Build in the project containing CB triggers."
  type        = list(string)
  default     = []
}

variable "meta_sa_folder_roles_list" {
  description = "The list of roles that will be granted to the SA linked to meta Cloud Build triggers in the folder containing Terragrunt projects."
  type        = list(string)
  default     = []
}

variable "solution_folder" {
  description = "The resource name of the folder the policy is attached to. Its format is folders/{folder_id}."
  type        = string
  default     = ""
}

variable "cloudbuild_gcs_location" {
  description = "Location of the data in the GCS buckets: Cloudbuild logs and artifacts."
  type        = string
}

variable "trigger_purpose" {
  description = "Part of the name that specifies whether it's a \"exec\" type trigger, or \"meta\" type."
  type        = string
  validation {
    condition     = var.trigger_purpose == "exec" || var.trigger_purpose == "meta"
    error_message = "Purpose must be either \"exec\" or \"meta\"."
  }
}

variable "common_project" {
  description = "ID of the project that hosts \"meta\" triggers and other general resources."
  type        = string
}

variable "access_token_secret_id" {
  description = "ID of the secret containing GH access token."
  type        = string
  default     = ""
}

variable "cb_repository_id" {
  description = "ID of the repository as it's been added to 2nd gen repositories in Cloud Build. Schema: projects/{{project}}/locations/{{location}}/connections/{{parent_connection}}/repositories/{{name}}."
  type        = string
}

variable "sa_roles_list_common_project" {
  description = "The list of roles that will be granted to the SA linked to Cloud Build in the common project."
  type        = list(string)
  default     = []
}
