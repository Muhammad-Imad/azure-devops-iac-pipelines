terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.80, < 4.0"
    }
  }
}

locals {
  # Flatten topic subscriptions into a single map for for_each.
  topic_subscriptions = merge([
    for topic_name, topic in var.topics : {
      for sub_name, sub in topic.subscriptions :
      "${topic_name}/${sub_name}" => {
        topic_name                           = topic_name
        subscription_name                    = sub_name
        max_delivery_count                   = sub.max_delivery_count
        dead_lettering_on_message_expiration = sub.dead_lettering_on_message_expiration
      }
    }
  ]...)
}

resource "azurerm_servicebus_namespace" "this" {
  name                = var.namespace_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  capacity            = var.sku == "Premium" ? var.capacity : 0
  minimum_tls_version = "1.2"

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "azurerm_servicebus_queue" "this" {
  for_each = var.queues

  name                                 = each.key
  namespace_id                         = azurerm_servicebus_namespace.this.id
  max_size_in_megabytes                = each.value.max_size_in_megabytes
  requires_duplicate_detection         = each.value.requires_duplicate_detection
  dead_lettering_on_message_expiration = each.value.dead_lettering_on_message_expiration
  max_delivery_count                   = each.value.max_delivery_count
  lock_duration                        = each.value.lock_duration
}

resource "azurerm_servicebus_topic" "this" {
  for_each = var.topics

  name                  = each.key
  namespace_id          = azurerm_servicebus_namespace.this.id
  max_size_in_megabytes = each.value.max_size_in_megabytes
}

resource "azurerm_servicebus_subscription" "this" {
  for_each = local.topic_subscriptions

  name                                 = each.value.subscription_name
  topic_id                             = azurerm_servicebus_topic.this[each.value.topic_name].id
  max_delivery_count                   = each.value.max_delivery_count
  dead_lettering_on_message_expiration = each.value.dead_lettering_on_message_expiration
}
