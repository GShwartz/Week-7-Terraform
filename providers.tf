terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.10.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "Tf-Storage"
    storage_account_name = "gazurestorage"
    container_name       = "newcontainer"
    key                  = "terraform.state"

  }
}


provider "azurerm" {
  features {

  }
}