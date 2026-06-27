output "namespace_id" {
  value       = azurerm_servicebus_namespace.this.id
  description = "Resource ID of the Service Bus namespace."
}

output "namespace_name" {
  value       = azurerm_servicebus_namespace.this.name
  description = "Name of the Service Bus namespace."
}

output "principal_id" {
  value       = azurerm_servicebus_namespace.this.identity[0].principal_id
  description = "System-assigned managed identity principal ID of the namespace."
}

output "queue_ids" {
  value       = { for k, q in azurerm_servicebus_queue.this : k => q.id }
  description = "Map of queue name to resource ID."
}

output "topic_ids" {
  value       = { for k, t in azurerm_servicebus_topic.this : k => t.id }
  description = "Map of topic name to resource ID."
}
