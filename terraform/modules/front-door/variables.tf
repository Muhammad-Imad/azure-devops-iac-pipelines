variable "name" {
  type        = string
  description = "Name of the Front Door (Standard/Premium) profile."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group in which the Front Door profile is created."
}

variable "sku_name" {
  type        = string
  description = "Front Door SKU (Standard_AzureFrontDoor or Premium_AzureFrontDoor). Premium required for managed WAF rule sets."
  default     = "Premium_AzureFrontDoor"
}

variable "endpoint_name" {
  type        = string
  description = "Name of the Front Door endpoint."
}

variable "origin_host_name" {
  type        = string
  description = "Hostname of the backend origin (e.g. the App Service default hostname)."
}

variable "waf_mode" {
  type        = string
  description = "WAF policy mode (Prevention or Detection)."
  default     = "Prevention"
}

variable "waf_managed_rule_sets" {
  description = "Managed WAF rule sets to enable."
  type = list(object({
    type    = string
    version = string
    action  = optional(string, "Block")
  }))
  default = [
    {
      type    = "Microsoft_DefaultRuleSet"
      version = "2.1"
      action  = "Block"
    },
    {
      type    = "Microsoft_BotManagerRuleSet"
      version = "1.0"
      action  = "Block"
    }
  ]
}

variable "rate_limit_threshold" {
  type        = number
  description = "Requests per minute per client IP before rate limiting kicks in."
  default     = 600
}

variable "health_probe_path" {
  type        = string
  description = "Path used by the Front Door health probe."
  default     = "/healthz"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to Front Door resources."
  default     = {}
}
