variable "namespace_name" {
  type        = string
  description = "Name of the Service Bus namespace (globally unique)."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group in which the namespace is created."
}

variable "location" {
  type        = string
  description = "Azure region for the namespace."
}

variable "sku" {
  type        = string
  description = "Service Bus SKU (Basic, Standard, Premium). Premium required for VNet."
  default     = "Standard"
}

variable "capacity" {
  type        = number
  description = "Messaging units for Premium SKU (1, 2, 4, 8, 16). Ignored otherwise."
  default     = 0
}

variable "queues" {
  description = "Map of queues to create. Key is the queue name."
  type = map(object({
    max_size_in_megabytes                = optional(number, 1024)
    requires_duplicate_detection         = optional(bool, true)
    dead_lettering_on_message_expiration = optional(bool, true)
    max_delivery_count                   = optional(number, 10)
    lock_duration                        = optional(string, "PT1M")
  }))
  default = {}
}

variable "topics" {
  description = "Map of topics (with optional subscriptions) to create."
  type = map(object({
    max_size_in_megabytes = optional(number, 1024)
    subscriptions = optional(map(object({
      max_delivery_count                   = optional(number, 10)
      dead_lettering_on_message_expiration = optional(bool, true)
    })), {})
  }))
  default = {}
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the namespace."
  default     = {}
}
