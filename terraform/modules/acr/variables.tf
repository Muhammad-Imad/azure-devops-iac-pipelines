variable "name" {
  type        = string
  description = "Name of the container registry (alphanumeric, globally unique)."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group in which the registry is created."
}

variable "location" {
  type        = string
  description = "Azure region for the registry."
}

variable "sku" {
  type        = string
  description = "Registry SKU (Basic, Standard, Premium). Premium required for geo-replication / private link."
  default     = "Premium"
}

variable "admin_enabled" {
  type        = bool
  description = "Whether the admin user is enabled. Should be false; use managed identity instead."
  default     = false
}

variable "georeplication_locations" {
  type        = list(string)
  description = "Regions to geo-replicate the registry to (Premium only)."
  default     = []
}

variable "retention_days" {
  type        = number
  description = "Number of days untagged manifests are retained before cleanup (Premium only)."
  default     = 14
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the registry."
  default     = {}
}
