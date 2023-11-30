resource "google_cloudbuild_trigger" "trigger" {
  for_each = {
    apply = {
      invert_regex   = false
      local_var_name = "apply"
    }
    plan = {
      invert_regex   = true
      local_var_name = "plan"
    }
    # plan-pr = {
    #   invert_regex   = false
    #   local_var_name = "plan"
    # }
    destroy = {
      local_var_name = "destroy"
    }
  }

  name            = "${var.resource_name_prefix}terragrunt-${var.trigger_purpose}-${each.key}${var.resource_name_suffix}"
  project         = var.project_id
  description     = "This runs terragrunt ${each.value.local_var_name} (${var.trigger_purpose})."
  service_account = "projects/${var.project_id}/serviceAccounts/${google_service_account.cloud_build_sa.email}"
  location        = var.trigger_location
  included_files  = var.included_files_list # only trigger if at least one file under terraform dir has been changed

  dynamic "repository_event_config" {
    for_each = contains(["apply", "plan", "plan-pr"], each.key) ? ["dummy"] : []

    content {
      repository = var.cb_repository_id

      dynamic "push" {
        for_each = contains(["apply", "plan"], each.key) ? ["dummy"] : []

        content {
          branch       = "main"
          invert_regex = each.value.invert_regex
        }
      }

      dynamic "pull_request" {
        for_each = contains(["plan-pr"], each.key) ? ["dummy"] : []

        content {
          branch          = "main"
          comment_control = "COMMENTS_ENABLED_FOR_EXTERNAL_CONTRIBUTORS_ONLY"
          invert_regex    = each.value.invert_regex
        }
      }
    }
  }

  dynamic "source_to_build" {
    for_each = contains(["destroy"], each.key) ? ["dummy"] : []

    content {
      repository = var.cb_repository_id
      ref        = "refs/heads/main"
      repo_type  = "UNKNOWN"
    }
  }

  substitutions = {
    _LOGS_BUCKET = google_storage_bucket.cloudbuild_logs.url
  }

  /*
  The whole motivation for having CB config written in this ugly dynamic-block-way is that if I had the config written in yaml, I could only refernce yaml files present IN THE REPOSITORY THAT TRIGGERED THIS JOB. In other words, when I push to some example_envs repo, the yaml file should be present in that repo (NOT in the current repo). I COULD NOT reference another repo or cloud storage. And I want to have a central location for CB config, not to have it dispersed across all customers' repositories. Therefore the only option I have for the moment is the approach below.

  We'll be adding parameters to content {} block when we need them, so far I have only included ones that I needed.
  */
  build {
    logs_bucket   = module.config_locals.all_config_files[each.value.local_var_name]["logs_bucket"]
    timeout       = lookup(module.config_locals.all_config_files[each.value.local_var_name], "timeout", null)
    substitutions = lookup(module.config_locals.all_config_files[each.value.local_var_name], "substitutions", null)

    # we either pass map(object) or list(string) to for_each; we cannot pass list(object); since map(object) is unordered and cloud build steps ARE ordered, I devised this workaround of auxiliary (ordered) list(string), where each element is a step name which I later refer to in content {} block
    dynamic "step" {
      for_each = module.config_locals.all_config_orders[each.value.local_var_name]

      content {
        name       = module.config_locals.all_config_files[each.value.local_var_name].steps[step.value].name
        id         = lookup(module.config_locals.all_config_files[each.value.local_var_name].steps[step.value], "id", null)
        args       = lookup(module.config_locals.all_config_files[each.value.local_var_name].steps[step.value], "args", null)
        script     = lookup(module.config_locals.all_config_files[each.value.local_var_name].steps[step.value], "script", null)
        dir        = lookup(module.config_locals.all_config_files[each.value.local_var_name].steps[step.value], "dir", null)
        secret_env = lookup(module.config_locals.all_config_files[each.value.local_var_name].steps[step.value], "secret_env", null)
      }
    }

    dynamic "available_secrets" {
      # didn't work with checking against {} (== {}), so I used length here; to be potentially revisited for cosmetics
      for_each = length(module.config_locals.all_config_files[each.value.local_var_name]["available_secrets"]["secret_manager"]) == 0 ? [] : ["dummy"]

      content {
        dynamic "secret_manager" {
          for_each = module.config_locals.all_config_files[each.value.local_var_name]["available_secrets"]["secret_manager"]

          content {
            version_name = secret_manager.value.version_name
            env          = secret_manager.value.env
          }
        }
      }
    }

    dynamic "options" {
      for_each = module.config_locals.all_config_files[each.value.local_var_name]["options"] == {} ? [] : ["dummy"]

      content {
        dynamic "volumes" {
          for_each = module.config_locals.all_config_files[each.value.local_var_name]["options"]["volumes"]

          content {
            name = volumes.value.name
            path = volumes.value.path
          }
        }
      }
    }
  }

  depends_on = [time_sleep.wait_30_after_roles_binding]
}
