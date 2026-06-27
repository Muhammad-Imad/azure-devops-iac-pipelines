variable "name" {
  type        = string
  description = "Name of the Linux Web App."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group in which the web app is created."
}

variable "location" {
  type        = string
  description = "Azure region for the web app."
}

variable "sku_name" {
  type        = string
  description = "SKU of the App Service Plan (e.g. P1v3 for production-grade workloads)."
  default     = "P1v3"
}

variable "worker_count" {
  type        = number
  description = "Number of workers (instances) in the App Service Plan."
  default     = 2
}

variable "docker_image_name" {
  type        = string
  description = "Container image reference (repository:tag) deployed to the web app."
}

variable "docker_registry_url" {
  type        = string
  description = "URL of the container registry, e.g. https://acmeacr.azurecr.io."
}

variable "deployment_slots" {
  type        = list(string)
  description = "Names of additional deployment slots (e.g. [\"staging\"]) used for blue/green."
  default     = ["staging"]
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID used for regional VNet integration (private outbound). Optional."
  default     = null
}

variable "app_insights_connection_string" {
  type        = string
  description = "Application Insights connection string for telemetry."
  default     = null
  sensitive   = true
}

variable "app_settings" {
  type        = map(string)
  description = "Additional application settings. Reference secrets via Key Vault references only."
  default     = {}
}

variable "health_check_path" {
  type        = string
  description = "Health check path probed by the platform."
  default     = "/healthz"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the web app resources."
  default     = {}
}
