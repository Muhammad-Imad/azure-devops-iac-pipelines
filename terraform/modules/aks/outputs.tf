output "id" {
  value       = azurerm_kubernetes_cluster.this.id
  description = "Resource ID of the AKS cluster."
}

output "name" {
  value       = azurerm_kubernetes_cluster.this.name
  description = "Name of the AKS cluster."
}

output "oidc_issuer_url" {
  value       = azurerm_kubernetes_cluster.this.oidc_issuer_url
  description = "OIDC issuer URL used for workload identity federation."
}

output "kubelet_identity_object_id" {
  value       = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
  description = "Object ID of the kubelet managed identity."
}

output "node_resource_group" {
  value       = azurerm_kubernetes_cluster.this.node_resource_group
  description = "Auto-generated resource group containing cluster nodes."
}
