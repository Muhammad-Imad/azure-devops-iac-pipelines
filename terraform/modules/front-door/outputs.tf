output "profile_id" {
  value       = azurerm_cdn_frontdoor_profile.this.id
  description = "Resource ID of the Front Door profile."
}

output "endpoint_hostname" {
  value       = azurerm_cdn_frontdoor_endpoint.this.host_name
  description = "Default hostname of the Front Door endpoint."
}

output "waf_policy_id" {
  value       = azurerm_cdn_frontdoor_firewall_policy.this.id
  description = "Resource ID of the WAF policy."
}
