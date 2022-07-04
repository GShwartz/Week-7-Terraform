variable "name_prefix" {
  description = "prefix name"
}

variable "location" {
  description = "Loaction of objects in azure"
}

variable "rg_name" {
  description = "Name of Resource group"
}

# ["Standard_B1s", "Standard_B1ms"]
variable "size" {
  description = "VM size"
}

variable "DB_name_prefix" {
  description = "Prefix for postgres server name"
}

#variable for network range
variable "node_address_space" {
  description = "address space of vnet"
}

#variable for app subnet range
variable "node_address_prefix" {
  description = "subnet address of app VMs"
  type        = list(string)
}

variable "application_port" {
  description = "Port that you want to expose to the external load balancer"
}

#variable for db subnet range
variable "db_address_prefix" {
  description = "subnet of postgres"
}

variable "myip" {
  description = "Personal IP"
}

variable "environment" {
  description = "Deployed in Environment"
}

variable "capacity" {
  description = "Number of VMSS Machines"
}

variable "minimum" {
  description = "Min # of machines"
}

variable "maximum" {
  description = "Max # of machines"
}

variable "admin_user" {
  description = "User name to use as the admin account on the VMs that will be part of the VM scale set"
}

variable "admin_password" {
  description = "Default password for admin account"
}

variable "db_admin_user" {
  description = "User name for postgres"
}

variable "db_admin_password" {
  description = "Default password for postgres admin account"
}
