output "vnet_id" {
  value       = azurerm_virtual_network.this.id
  description = "Resource ID of the virtual network."
}

output "vnet_name" {
  value       = azurerm_virtual_network.this.name
  description = "Name of the virtual network."
}

output "subnet_ids" {
  value       = { for k, s in azurerm_subnet.this : k => s.id }
  description = "Map of subnet name to subnet resource ID."
}

output "nsg_ids" {
  value       = { for k, n in azurerm_network_security_group.this : k => n.id }
  description = "Map of subnet name to associated NSG resource ID."
}
