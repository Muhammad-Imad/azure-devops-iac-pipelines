variable "name" {
  type        = string
  description = "Name of the AKS cluster."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group in which the cluster is created."
}

variable "location" {
  type        = string
  description = "Azure region for the cluster."
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes control plane version."
  default     = "1.29"
}

variable "dns_prefix" {
  type        = string
  description = "DNS prefix for the cluster API server."
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for node pools (Azure CNI)."
}

variable "default_node_pool" {
  description = "Configuration for the system (default) node pool."
  type = object({
    vm_size            = optional(string, "Standard_D4s_v5")
    min_count          = optional(number, 2)
    max_count          = optional(number, 5)
    os_disk_size_gb    = optional(number, 128)
    max_pods           = optional(number, 50)
    availability_zones = optional(list(string), ["1", "2", "3"])
  })
  default = {}
}

variable "acr_id" {
  type        = string
  description = "Resource ID of the ACR to grant AcrPull to the kubelet identity. Optional."
  default     = null
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics workspace ID for Container Insights. Optional."
  default     = null
}

variable "admin_group_object_ids" {
  type        = list(string)
  description = "Entra ID group object IDs granted cluster-admin via Azure RBAC."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the cluster."
  default     = {}
}
