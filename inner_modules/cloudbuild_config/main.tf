locals {
  access_token_available_secret = var.access_token_secret_id == "" ? {} : {
    access_token = {
      version_name = "projects/${var.common_project}/secrets/${var.access_token_secret_id}/versions/latest"
      env          = "ACCESS_TOKEN"
    }
  }

  access_token_volume = var.access_token_secret_id == "" ? {} : {
    volume1 = {
      name = "root-copy"
      path = "/root-copy"
    }
  }

  non_steps_config = {
    logs_bucket   = "$_LOGS_BUCKET"
    timeout       = "1200s"
    substitutions = {}
    available_secrets = {
      secret_manager = merge(
        local.access_token_available_secret
      )
    }
    options = {
      volumes = merge(
        local.access_token_volume
      )
    }
  }

  pre_terragrunt_run_steps = var.access_token_secret_id == "" ? {} : {
    token_setup = {
      id         = "gh token setup"
      name       = var.builder_full_name
      secret_env = ["ACCESS_TOKEN"]
      args = [
        "-c",
        <<-EOT
              echo "$$ACCESS_TOKEN" > /root/access_token
              gh auth login --with-token < /root/access_token
              gh auth setup-git

            cp -a /root /root-copy
          EOT
      ]
    }
  }

  terragrunt_run = {
    plan = {
      id   = "terragrunt run-all plan"
      name = var.builder_full_name
      dir  = var.terragrunt_run_level_directory
      args = [
        "-x",
        "-c",
        <<-EOT
            if [[ "${var.access_token_secret_id}" != "" ]]
            then
              cp -a /root-copy /root
            fi

            terragrunt run-all plan  \
              --terragrunt-non-interactive \
              -parallelism=30
          EOT
      ]
    }

    apply = {
      id   = "terragrunt run-all apply"
      name = var.builder_full_name
      dir  = var.terragrunt_run_level_directory
      args = [
        "-x",
        "-c",
        <<-EOT
            if [[ "${var.access_token_secret_id}" != "" ]]
            then
              cp -a /root-copy /root
            fi

            terragrunt run-all apply  \
              --terragrunt-non-interactive \
              -parallelism=30
          EOT
      ]
    }

    destroy = {
      id   = "terragrunt run-all destroy"
      name = var.builder_full_name
      dir  = var.terragrunt_run_level_directory
      args = [
        "-x",
        "-c",
        <<-EOT
            if [[ "${var.access_token_secret_id}" != "" ]]
            then
              cp -a /root-copy /root
            fi

            terragrunt run-all destroy  \
              --terragrunt-non-interactive \
              -parallelism=30
          EOT
      ]
    }
  }

  terragrunt_apply_steps = merge(
    local.pre_terragrunt_run_steps,
    { apply = local.terragrunt_run["apply"] }
  )

  terragrunt_plan_steps = merge(
    local.pre_terragrunt_run_steps,
    { plan = local.terragrunt_run["plan"] }
  )

  terragrunt_destroy_steps = merge(
    local.pre_terragrunt_run_steps,
    { destroy = local.terragrunt_run["destroy"] }
  )

  apply = merge(
    local.non_steps_config,
    { steps = local.terragrunt_apply_steps }
  )

  plan = merge(
    local.non_steps_config,
    { steps = local.terragrunt_plan_steps }
  )

  destroy = merge(
    local.non_steps_config,
    { steps = local.terragrunt_destroy_steps }
  )

  token_step = var.access_token_secret_id == "" ? null : "token_setup"

  order_of_apply_steps = compact([
    local.token_step,
    "apply",
  ])

  order_of_plan_steps = compact([
    local.token_step,
    "plan",
  ])

  order_of_destroy_steps = compact([
    local.token_step,
    "destroy",
  ])
}
