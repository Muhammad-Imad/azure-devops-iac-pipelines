output "workspace_id" {
  value       = azurerm_log_analytics_workspace.this.id
  description = "Resource ID of the Log Analytics workspace."
}

output "workspace_customer_id" {
  value       = azurerm_log_analytics_workspace.this.workspace_id
  description = "Customer (workspace) ID of the Log Analytics workspace."
}

output "app_insights_id" {
  value       = azurerm_application_insights.this.id
  description = "Resource ID of the Application Insights component."
}

output "instrumentation_key" {
  value       = azurerm_application_insights.this.instrumentation_key
  description = "Application Insights instrumentation key."
  sensitive   = true
}

output "connection_string" {
  value       = azurerm_application_insights.this.connection_string
  description = "Application Insights connection string."
  sensitive   = true
}
