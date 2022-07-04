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
