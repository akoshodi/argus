variable "project_root" {
  description = "Absolute path to repository root"
  type        = string
}

variable "compose_file" {
  description = "Relative path to compose file"
  type        = string
  default     = "deploy/docker-compose.yaml"
}

variable "env_file" {
  description = "Relative path to .env file"
  type        = string
  default     = ".env"
}
