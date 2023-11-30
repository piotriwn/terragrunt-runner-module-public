# terragrunt-runner-module-public

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name                                                                      | Version  |
| ------------------------------------------------------------------------- | -------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_google"></a> [google](#requirement\_google)          | >= 5.0.0 |

## Providers

| Name                                                       | Version |
| ---------------------------------------------------------- | ------- |
| <a name="provider_google"></a> [google](#provider\_google) | 5.5.0   |
| <a name="provider_time"></a> [time](#provider\_time)       | 0.9.1   |

## Modules

| Name                                                                          | Source                            | Version |
| ----------------------------------------------------------------------------- | --------------------------------- | ------- |
| <a name="module_config_locals"></a> [config\_locals](#module\_config\_locals) | ./inner_modules/cloudbuild_config | n/a     |

## Resources

| Name                                                                                                                                           | Type     |
| ---------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [google_cloudbuild_trigger.trigger](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger)         | resource |
| [google_folder_iam_member.meta_sa_folder](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder_iam_member)    | resource |
| [google_project_iam_member.sa_roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member)        | resource |
| [google_project_iam_member.sa_roles_common](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.cloud_build_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account)        | resource |
| [google_storage_bucket.cloudbuild_artifacts](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket)    | resource |
| [google_storage_bucket.cloudbuild_logs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket)         | resource |
| [time_sleep.wait_30_after_roles_binding](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep)                   | resource |

## Inputs

| Name                                                                                                                               | Description                                                                                                                                                                                   | Type           | Default | Required |
| ---------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | ------- | :------: |
| <a name="input_access_token_secret_id"></a> [access\_token\_secret\_id](#input\_access\_token\_secret\_id)                         | ID of the secret containing GH access token.                                                                                                                                                  | `string`       | `""`    |    no    |
| <a name="input_builder_full_name"></a> [builder\_full\_name](#input\_builder\_full\_name)                                          | Name of the image that will be utilised by config jobs.                                                                                                                                       | `string`       | n/a     |   yes    |
| <a name="input_cb_repository_id"></a> [cb\_repository\_id](#input\_cb\_repository\_id)                                             | ID of the repository as it's been added to 2nd gen repositories in Cloud Build. Schema: projects/{{project}}/locations/{{location}}/connections/{{parent\_connection}}/repositories/{{name}}. | `string`       | n/a     |   yes    |
| <a name="input_cloudbuild_gcs_location"></a> [cloudbuild\_gcs\_location](#input\_cloudbuild\_gcs\_location)                        | Location of the data in the GCS buckets: Cloudbuild logs and artifacts.                                                                                                                       | `string`       | n/a     |   yes    |
| <a name="input_common_project"></a> [common\_project](#input\_common\_project)                                                     | ID of the project that hosts "meta" triggers and other general resources.                                                                                                                     | `string`       | n/a     |   yes    |
| <a name="input_included_files_list"></a> [included\_files\_list](#input\_included\_files\_list)                                    | List of files that will be included in the Cloud Build configuration.                                                                                                                         | `list(string)` | n/a     |   yes    |
| <a name="input_meta_sa_folder_roles_list"></a> [meta\_sa\_folder\_roles\_list](#input\_meta\_sa\_folder\_roles\_list)              | The list of roles that will be granted to the SA linked to meta Cloud Build triggers in the folder containing Terragrunt projects.                                                            | `list(string)` | `[]`    |    no    |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id)                                                                 | ID of the project that will host the Cloud Build-related resources.                                                                                                                           | `string`       | n/a     |   yes    |
| <a name="input_resource_name_prefix"></a> [resource\_name\_prefix](#input\_resource\_name\_prefix)                                 | Prefix for the resource names.                                                                                                                                                                | `string`       | n/a     |   yes    |
| <a name="input_resource_name_suffix"></a> [resource\_name\_suffix](#input\_resource\_name\_suffix)                                 | Suffix for the resource names.                                                                                                                                                                | `string`       | n/a     |   yes    |
| <a name="input_sa_roles_list"></a> [sa\_roles\_list](#input\_sa\_roles\_list)                                                      | The list of roles that will be granted to the SA linked to Cloud Build in the project containing CB triggers.                                                                                 | `list(string)` | `[]`    |    no    |
| <a name="input_sa_roles_list_common_project"></a> [sa\_roles\_list\_common\_project](#input\_sa\_roles\_list\_common\_project)     | The list of roles that will be granted to the SA linked to Cloud Build in the common project.                                                                                                 | `list(string)` | `[]`    |    no    |
| <a name="input_solution_folder"></a> [solution\_folder](#input\_solution\_folder)                                                  | The resource name of the folder the policy is attached to. Its format is folders/{folder\_id}.                                                                                                | `string`       | `""`    |    no    |
| <a name="input_terragrunt_run_level_directory"></a> [terragrunt\_run\_level\_directory](#input\_terragrunt\_run\_level\_directory) | Directory where Terragrunt will run.                                                                                                                                                          | `string`       | n/a     |   yes    |
| <a name="input_trigger_location"></a> [trigger\_location](#input\_trigger\_location)                                               | Location of the CB trigger (e.g. global or specified region).                                                                                                                                 | `string`       | n/a     |   yes    |
| <a name="input_trigger_purpose"></a> [trigger\_purpose](#input\_trigger\_purpose)                                                  | Part of the name that specifies whether it's a "exec" type trigger, or "meta" type.                                                                                                           | `string`       | n/a     |   yes    |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
