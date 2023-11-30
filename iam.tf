resource "google_service_account" "cloud_build_sa" {
  account_id   = "${var.resource_name_prefix}cb-${var.trigger_purpose}${var.resource_name_suffix}"
  display_name = "Cloud Build ${var.trigger_purpose} SA."
  description  = "Service Account responsible for running Cloud Build (${var.trigger_purpose})."
  project      = var.project_id
}

resource "google_project_iam_member" "sa_roles" {
  for_each = toset(var.sa_roles_list)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.cloud_build_sa.email}"
}

resource "google_folder_iam_member" "meta_sa_folder" {
  for_each = toset(var.meta_sa_folder_roles_list)

  folder = var.solution_folder
  role   = each.value
  member = "serviceAccount:${google_service_account.cloud_build_sa.email}"
}

resource "google_project_iam_member" "sa_roles_common" {
  for_each = toset(var.sa_roles_list_common_project)

  project = var.common_project
  role    = each.value
  member  = "serviceAccount:${google_service_account.cloud_build_sa.email}"
}

resource "time_sleep" "wait_30_after_roles_binding" {
  depends_on = [google_project_iam_member.sa_roles,
    google_folder_iam_member.meta_sa_folder,
    google_project_iam_member.sa_roles_common
  ]

  create_duration = "30s"

  # lifecycle {
  #   replace_triggered_by = [
  #     google_project_iam_member.sa_roles
  #   ]
  # }
}
