locals {
  compose_path = "${var.project_root}/${var.compose_file}"
  env_path     = "${var.project_root}/${var.env_file}"
}

resource "null_resource" "stack_up" {
  triggers = {
    compose_sha = filemd5(local.compose_path)
    env_sha     = filemd5(local.env_path)
  }

  provisioner "local-exec" {
    command = "docker compose --env-file ${local.env_path} -f ${local.compose_path} up -d --remove-orphans"
  }
}

resource "null_resource" "stack_down" {
  triggers = {
    compose_sha = filemd5(local.compose_path)
    env_sha     = filemd5(local.env_path)
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "docker compose --env-file ${local.env_path} -f ${local.compose_path} down"
  }
}

output "up_command" {
  value       = "terraform -chdir=terraform init && terraform -chdir=terraform apply -auto-approve -var='project_root=<ABSOLUTE_REPO_PATH>'"
  description = "One command to deploy the full observability stack"
}
