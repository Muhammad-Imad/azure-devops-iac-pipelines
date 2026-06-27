variable "name" {
  type        = string
  description = "Name of the virtual network."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group in which the virtual network is created."
}

variable "location" {
  type        = string
  description = "Azure region for the virtual network."
}

variable "address_space" {
  type        = list(string)
  description = "Address space (CIDR blocks) for the virtual network."
}

variable "dns_servers" {
  type        = list(string)
  description = "Optional custom DNS servers for the virtual network."
  default     = []
}

variable "subnets" {
  description = <<-EOT
    Map of subnets to create. Key is the subnet name. Each value supports:
      address_prefixes  - list(string) CIDR ranges for the subnet (required)
      service_endpoints - list(string) service endpoints to enable (optional)
      delegation        - object with name + service_delegation (optional)
  EOT
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), [])
    delegation = optional(object({
      name    = string
      service = string
      actions = list(string)
    }))
  }))
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to network resources."
  default     = {}
}
