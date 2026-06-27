terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.80, < 4.0"
    }
  }

  # Remote state in an Azure Storage Account. Values are intentionally
  # placeholders; supply real ones via `-backend-config` or a partial
  # backend file in the pipeline (never commit secrets).
  #
  #   terraform init \
  #     -backend-config="resource_group_name=rg-tfstate" \
  #     -backend-config="storage_account_name=sttfstateacme" \
  #     -backend-config="container_name=tfstate" \
  #     -backend-config="key=dev.terraform.tfstate"
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstateacme"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
    use_azuread_auth     = true
  }
}
