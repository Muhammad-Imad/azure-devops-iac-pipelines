terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.80, < 4.0"
    }
  }
}

resource "azurerm_kubernetes_cluster" "this" {
  name                      = var.name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  dns_prefix                = var.dns_prefix
  kubernetes_version        = var.kubernetes_version
  automatic_channel_upgrade = "patch"
  sku_tier                  = "Standard"
  local_account_disabled    = true
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  default_node_pool {
    name                         = "system"
    vm_size                      = var.default_node_pool.vm_size
    vnet_subnet_id               = var.subnet_id
    enable_auto_scaling          = true
    min_count                    = var.default_node_pool.min_count
    max_count                    = var.default_node_pool.max_count
    os_disk_size_gb              = var.default_node_pool.os_disk_size_gb
    max_pods                     = var.default_node_pool.max_pods
    zones                        = var.default_node_pool.availability_zones
    only_critical_addons_enabled = true

    upgrade_settings {
      max_surge = "33%"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = true
    admin_group_object_ids = var.admin_group_object_ids
  }

  dynamic "oms_agent" {
    for_each = var.log_analytics_workspace_id == null ? [] : [1]

    content {
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }
  }

  tags = var.tags
}

# User node pool for application workloads, isolated from system components.
resource "azurerm_kubernetes_cluster_node_pool" "apps" {
  name                  = "apps"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size               = var.default_node_pool.vm_size
  vnet_subnet_id        = var.subnet_id
  enable_auto_scaling   = true
  min_count             = var.default_node_pool.min_count
  max_count             = var.default_node_pool.max_count
  os_disk_size_gb       = var.default_node_pool.os_disk_size_gb
  max_pods              = var.default_node_pool.max_pods
  zones                 = var.default_node_pool.availability_zones
  mode                  = "User"

  node_labels = {
    "workload" = "apps"
  }

  tags = var.tags
}

# Allow the cluster's kubelet identity to pull images from ACR.
resource "azurerm_role_assignment" "acr_pull" {
  count = var.acr_id == null ? 0 : 1

  scope                            = var.acr_id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}
