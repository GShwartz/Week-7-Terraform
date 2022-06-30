# Configure Resource Group
resource "azurerm_resource_group" "staging_rg" {
  name     = var.rg_name
  location = var.location

  lifecycle {
    prevent_destroy = false

  }

}


