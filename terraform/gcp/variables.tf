# variables.tf
variable "gcp_project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "gcp_region" {
  description = "The GCP region to deploy resources"
  type        = string
  default     = "asia-east2"  # Hong Kong region
}

variable "db_username" {
  description = "Username for the MySQL database"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Password for the MySQL database"
  type        = string
  sensitive   = true
}
