output "id" {
  value       = azurerm_linux_web_app.this.id
  description = "Resource ID of the web app."
}

output "name" {
  value       = azurerm_linux_web_app.this.name
  description = "Name of the web app."
}

output "default_hostname" {
  value       = azurerm_linux_web_app.this.default_hostname
  description = "Default hostname of the web app."
}

output "principal_id" {
  value       = azurerm_linux_web_app.this.identity[0].principal_id
  description = "System-assigned managed identity principal ID of the web app."
}

output "slot_principal_ids" {
  value       = { for k, s in azurerm_linux_web_app_slot.this : k => s.identity[0].principal_id }
  description = "Map of slot name to system-assigned managed identity principal ID."
}

output "slot_names" {
  value       = [for s in azurerm_linux_web_app_slot.this : s.name]
  description = "Names of the deployment slots."
}
