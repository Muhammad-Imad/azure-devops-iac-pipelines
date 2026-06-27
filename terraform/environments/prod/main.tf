###############################################################################
# Prod environment — production-grade composition: Premium SKUs, zone-redundant
# node pools, ACR geo-replication, Premium Front Door with managed WAF rule
# sets in Prevention mode, and purge-protected Key Vault.
###############################################################################

locals {
  name_suffix = "${var.org}-${var.environment}"

  common_tags = merge(
    {
      environment = var.environment
      managed_by  = "terraform"
      project     = var.org
      criticality = "tier-1"
    },
    var.tags
  )
}

module "resource_group" {
  source = "../../modules/resource-group"

  name     = "rg-${local.name_suffix}"
  location = var.location
  tags     = local.common_tags
}

module "vnet" {
  source = "../../modules/vnet"

  name                = "vnet-${local.name_suffix}"
  resource_group_name = module.resource_group.name
  location            = var.location
  address_space       = ["10.20.0.0/16"]
  tags                = local.common_tags

  subnets = {
    "snet-apps" = {
      address_prefixes  = ["10.20.1.0/24"]
      service_endpoints = ["Microsoft.KeyVault", "Microsoft.ServiceBus"]
      delegation = {
        name    = "appservice-delegation"
        service = "Microsoft.Web/serverFarms"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
    "snet-aks" = {
      address_prefixes  = ["10.20.8.0/22"]
      service_endpoints = ["Microsoft.KeyVault"]
    }
    "snet-pe" = {
      address_prefixes = ["10.20.2.0/24"]
    }
  }
}

module "observability" {
  source = "../../modules/application-insights"

  name_prefix         = local.name_suffix
  resource_group_name = module.resource_group.name
  location            = var.location
  retention_in_days   = 90
  daily_quota_gb      = -1
  tags                = local.common_tags
}

module "acr" {
  source = "../../modules/acr"

  name                     = "acr${var.org}${var.environment}"
  resource_group_name      = module.resource_group.name
  location                 = var.location
  sku                      = "Premium"
  admin_enabled            = false
  georeplication_locations = [var.secondary_location]
  retention_days           = 30
  tags                     = local.common_tags
}

module "key_vault" {
  source = "../../modules/key-vault"

  name                       = "kv-${var.org}-${var.environment}"
  resource_group_name        = module.resource_group.name
  location                   = var.location
  tenant_id                  = var.tenant_id
  sku_name                   = "premium"
  purge_protection_enabled   = true
  soft_delete_retention_days = 90
  network_default_action     = "Deny"
  allowed_subnet_ids         = [module.vnet.subnet_ids["snet-apps"]]
  allowed_ip_rules           = var.ci_runner_ip_ranges
  tags                       = local.common_tags

  secret_reader_principal_ids = concat(
    [module.app_service.principal_id],
    values(module.app_service.slot_principal_ids)
  )
}

module "service_bus" {
  source = "../../modules/service-bus"

  namespace_name      = "sb-${local.name_suffix}"
  resource_group_name = module.resource_group.name
  location            = var.location
  sku                 = "Premium"
  capacity            = 1
  tags                = local.common_tags

  queues = {
    "orders" = {
      max_size_in_megabytes = 5120
    }
  }

  topics = {
    "payments" = {
      subscriptions = {
        "ledger"     = {}
        "fraudcheck" = {}
      }
    }
  }
}

module "app_service" {
  source = "../../modules/app-service"

  name                           = "app-${local.name_suffix}"
  resource_group_name            = module.resource_group.name
  location                       = var.location
  sku_name                       = "P2v3"
  worker_count                   = 3
  docker_registry_url            = "https://${module.acr.login_server}"
  docker_image_name              = "checkout-svc:stable"
  deployment_slots               = ["staging"]
  subnet_id                      = module.vnet.subnet_ids["snet-apps"]
  app_insights_connection_string = module.observability.connection_string
  health_check_path              = "/healthz"
  tags                           = local.common_tags

  app_settings = {
    "ASPNETCORE_ENVIRONMENT" = "Production"
    "ServiceBus__Namespace"  = "${module.service_bus.namespace_name}.servicebus.windows.net"
  }
}

resource "azurerm_role_assignment" "app_acr_pull" {
  for_each = toset(concat(
    [module.app_service.principal_id],
    values(module.app_service.slot_principal_ids)
  ))

  scope                = module.acr.id
  role_definition_name = "AcrPull"
  principal_id         = each.value
}

module "aks" {
  source = "../../modules/aks"

  name                       = "aks-${local.name_suffix}"
  resource_group_name        = module.resource_group.name
  location                   = var.location
  dns_prefix                 = "aks-${local.name_suffix}"
  subnet_id                  = module.vnet.subnet_ids["snet-aks"]
  acr_id                     = module.acr.id
  log_analytics_workspace_id = module.observability.workspace_id
  admin_group_object_ids     = var.aks_admin_group_object_ids
  tags                       = local.common_tags

  default_node_pool = {
    vm_size            = "Standard_D4s_v5"
    min_count          = 3
    max_count          = 10
    availability_zones = ["1", "2", "3"]
  }
}

module "front_door" {
  source = "../../modules/front-door"

  name                = "fd-${local.name_suffix}"
  resource_group_name = module.resource_group.name
  endpoint_name       = "ep-${local.name_suffix}"
  origin_host_name    = module.app_service.default_hostname
  sku_name            = "Premium_AzureFrontDoor"
  waf_mode            = "Prevention"
  health_probe_path   = "/healthz"
  tags                = local.common_tags
}
