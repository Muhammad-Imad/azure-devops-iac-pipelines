variable "subscription_id" {
  type        = string
  description = "Azure subscription ID for the prod environment."
}

variable "tenant_id" {
  type        = string
  description = "Entra ID tenant ID."
}

variable "location" {
  type        = string
  description = "Primary Azure region."
  default     = "westeurope"
}

variable "secondary_location" {
  type        = string
  description = "Secondary region for ACR geo-replication."
  default     = "northeurope"
}

variable "environment" {
  type        = string
  description = "Environment short name."
  default     = "prod"
}

variable "org" {
  type        = string
  description = "Organization / project short name used in resource naming."
  default     = "acme"
}

variable "aks_admin_group_object_ids" {
  type        = list(string)
  description = "Entra ID group object IDs granted AKS cluster-admin."
  default     = []
}

variable "ci_runner_ip_ranges" {
  type        = list(string)
  description = "CIDR ranges of CI runners permitted to reach Key Vault."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Common tags applied to all resources."
  default     = {}
}
