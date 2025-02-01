# variables.tf
variable "azure_region" {
  description = "The Azure region to deploy resources"
  type        = string
  default     = "East Asia"  # Hong Kong region
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
