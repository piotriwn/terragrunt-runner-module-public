output "all_config_orders" {
  description = "List of steps (ordered!) that should be sequentially processed by dynamic block in each trigger definiton file."
  value = {
    apply   = local.order_of_apply_steps
    plan    = local.order_of_plan_steps
    destroy = local.order_of_destroy_steps
  }
}

output "all_config_files" {
  description = "Variable containing all local variables pertaining to Cloud Build job config."
  value = {
    apply   = local.apply
    plan    = local.plan
    destroy = local.destroy
  }
}
