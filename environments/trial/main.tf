provider "azurerm" {
  features {}
  subscription_id = "b83326f1-b625-4cbc-b5c3-c2f240c6665d"
}

module "vm" {
  source              = "../../modules/virtual_machine"
  resource_group_name = var.resource_group_name
  location            = var.location
  vm_name             = var.vm_name
  acr_login_server    = var.acr_login_server
  image_name          = var.image_name
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  vm_size             = var.vm_size
}




