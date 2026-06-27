terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.80, < 4.0"
    }
  }
}

resource "azurerm_container_registry" "this" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku                           = var.sku
  admin_enabled                 = var.admin_enabled
  public_network_access_enabled = true

  dynamic "georeplications" {
    for_each = var.sku == "Premium" ? toset(var.georeplication_locations) : []

    content {
      location                = georeplications.value
      zone_redundancy_enabled = true
      tags                    = var.tags
    }
  }

  dynamic "retention_policy" {
    for_each = var.sku == "Premium" ? [1] : []

    content {
      enabled = true
      days    = var.retention_days
    }
  }

  trust_policy {
    enabled = var.sku == "Premium"
  }

  tags = var.tags
}
