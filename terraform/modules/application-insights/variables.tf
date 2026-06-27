variable "name_prefix" {
  type        = string
  description = "Prefix used to derive the Log Analytics workspace and App Insights names."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group in which observability resources are created."
}

variable "location" {
  type        = string
  description = "Azure region for the observability resources."
}

variable "log_analytics_sku" {
  type        = string
  description = "Log Analytics workspace SKU."
  default     = "PerGB2018"
}

variable "retention_in_days" {
  type        = number
  description = "Log retention period in days."
  default     = 90
}

variable "daily_quota_gb" {
  type        = number
  description = "Daily ingestion cap in GB (-1 for unlimited)."
  default     = -1
}

variable "application_type" {
  type        = string
  description = "Application Insights application type."
  default     = "web"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to observability resources."
  default     = {}
}
