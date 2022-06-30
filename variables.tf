# ==================================================== #
#                        Main                          #
# ==================================================== #
variable "rg_name" {
  description = "Resource Group Name"
}

variable "location" {
  description = "Set Location"
}

# ==================================================== #
#                       Network                        #
# ==================================================== #
variable "virtual_network_name" {
  description = "Name for the Virtual Network"
}

variable "db_dns_zone_name" {
  description = "DNS Name for Flexible server"
}

variable "command_nic_ip_configuration_name" {
  description = "Name of the NIC attached to Command VM"
}

##### Load Balancer #####
variable "lb_backend_ap_ip_configuration_name" {
  description = "Name the NIC to be shown under the load balancer backend address pool"
}

# ==================================================== #
#                      Platforms                       #
# ==================================================== #
##### Linux OS Profile #####
variable "publisher" {
  description = "OS Publisher"
}

variable "offer" {
  description = "Source"
}

variable "linux_sku" {
  description = "Distribution"
}

variable "os_version" {
  description = "Version"
}

##### WebApp VM Platform #####
variable "counter" {
  description = "How many VMs?"
  type        = number
}

variable "webapp_vm_admin_user" {
  description = "VM Admin User"
}

variable "webapp_vm_admin_password" {
  description = "VM Admin Password"
}

variable "webapp_vm_type_b1s" {
  description = "VM Type (Usually Standard_B1s)"
}

variable "webapp_vm_type_b1ms" {
  description = "VM Type (Usually Standard_B1s)"
}

variable "webapp_storage_os_disk_name" {
  description = "Disk Name"
}

variable "managed_disk_type" {
  description = "Managed Disk Type"
}

variable "webapp_create_option" {
  description = "Create Option"
}

variable "webapp_disk_catch" {
  description = "Disk Catch"
}

variable "webapp_disk_size_gb" {
  description = "Disk Size GB"
}

variable "vm_disk_name" {
  description = "Disk Name"
}

variable "webapp_vm_name" {
  description = "Name of the WebApp Virtual Machine"
}

variable "webapp_vm_computer_name" {
  description = "Name of the Computer inside the webapp VM"
}

##### Terminal VM Platform #####
variable "command_vm_computer_name" {
  description = "Name of the Computer inside the terminal VM"
}

variable "command_vm_name" {
  description = "Name of the Terminal VM"
}

variable "command_vm_admin_password" {
  description = "Command Admin Password"
}

variable "db_user" {
  description = "Database User"
}

variable "db_password" {
  description = "Database Password"
}

variable "db_server_name" {
  description = "Database Server Name"
}
