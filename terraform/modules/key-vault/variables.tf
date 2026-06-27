variable "name" {
  type        = string
  description = "Name of the Key Vault (globally unique, 3-24 chars)."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group in which the Key Vault is created."
}

variable "location" {
  type        = string
  description = "Azure region for the Key Vault."
}

variable "tenant_id" {
  type        = string
  description = "Entra ID tenant ID associated with the Key Vault."
}

variable "sku_name" {
  type        = string
  description = "Key Vault SKU (standard or premium)."
  default     = "standard"
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Enable purge protection. Recommended true for production."
  default     = true
}

variable "soft_delete_retention_days" {
  type        = number
  description = "Number of days deleted vaults/secrets are retained."
  default     = 90
}

variable "rbac_authorization_enabled" {
  type        = bool
  description = "Use Azure RBAC for data plane access instead of access policies."
  default     = true
}

variable "network_default_action" {
  type        = string
  description = "Default network action (Deny or Allow). Deny is recommended."
  default     = "Deny"
}

variable "allowed_subnet_ids" {
  type        = list(string)
  description = "Subnet IDs permitted to reach the vault when default action is Deny."
  default     = []
}

variable "allowed_ip_rules" {
  type        = list(string)
  description = "CIDR ranges permitted to reach the vault (e.g. CI runners)."
  default     = []
}

variable "secret_reader_principal_ids" {
  type        = list(string)
  description = "Managed identity principal IDs granted Key Vault Secrets User."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the Key Vault."
  default     = {}
}
