output "resource_group_name" {
  value       = module.resource_group.name
  description = "Name of the prod resource group."
}

output "acr_login_server" {
  value       = module.acr.login_server
  description = "ACR login server used by CI to push images."
}

output "app_service_name" {
  value       = module.app_service.name
  description = "Name of the App Service web app."
}

output "app_service_default_hostname" {
  value       = module.app_service.default_hostname
  description = "Default hostname of the App Service web app."
}

output "front_door_hostname" {
  value       = module.front_door.endpoint_hostname
  description = "Public Front Door endpoint hostname."
}

output "aks_cluster_name" {
  value       = module.aks.name
  description = "Name of the AKS cluster."
}

output "key_vault_uri" {
  value       = module.key_vault.vault_uri
  description = "URI of the prod Key Vault."
}
