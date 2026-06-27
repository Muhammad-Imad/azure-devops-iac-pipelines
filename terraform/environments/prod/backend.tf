terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.80, < 4.0"
    }
  }

  # Remote state in an Azure Storage Account. Values are placeholders; supply
  # real ones via `-backend-config` in the pipeline. The prod state lives under
  # a separate state key (and ideally a separate storage account / subscription).
  #
  #   terraform init \
  #     -backend-config="resource_group_name=rg-tfstate" \
  #     -backend-config="storage_account_name=sttfstateacme" \
  #     -backend-config="container_name=tfstate" \
  #     -backend-config="key=prod.terraform.tfstate"
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstateacme"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
    use_azuread_auth     = true
  }
}
