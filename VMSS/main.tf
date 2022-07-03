resource "azurerm_linux_virtual_machine_scale_set" "VMSS" {
  name                            = "VMSS"
  resource_group_name             = var.RSG_name
  location                        = var.location
  sku                             = var.VMSS_size
  instances                       = var.capacity
  admin_username                  = var.admin_user
  admin_password                  = var.admin_password
  disable_password_authentication = false
  depends_on                      = [var.VMSS_nsg_id]

# create original image
source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

# Nic`s parameters and configuration with relation to the LB
  network_interface {
    name                      = "VMSS-NIC"
    primary                   = true
    network_security_group_id = var.VMSS_nsg_id

    ip_configuration {
      name                                   = "IPConfiguration"
      primary                                = true
      subnet_id                              = var.VMSS_subnet_id
      load_balancer_backend_address_pool_ids = [var.BEpool_id]
      load_balancer_inbound_nat_rules_ids    = [var.LB_natpool_id]
    }
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  # Since these can change via auto-scaling outside of Terraform,
  # let's ignore any changes to the number of instances
  lifecycle {
    ignore_changes = [instances]
  }


}

#scaling metrics
resource "azurerm_monitor_autoscale_setting" "scaling" {
  name                = "autoscale-config"
  resource_group_name = var.RSG_name
  location            = var.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.VMSS.id

  profile {
    name = "AutoScale"

    capacity {
      default = var.capacity
      minimum = var.minimum
      maximum = var.maximum
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.VMSS.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }

    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.VMSS.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }


}

#runing a custom script (can see content in the link) to install python and update\upgrade
#in order to be able to configure machines via Ansible
#resource "azurerm_virtual_machine_scale_set_extension" "script" {
#  name                         = "script"
#  publisher                    = "Microsoft.OSTCExtensions"
#  type                         = "CustomScriptForLinux"
#  type_handler_version         = "1.2"
#  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.VMSS.id
#  settings = <<SETTINGS
#    {
#"fileUris": ["https://avshastorage.blob.core.windows.net/files/script.sh"],
#    "commandToExecute": "script.sh"
#  }
#SETTINGS
#}
