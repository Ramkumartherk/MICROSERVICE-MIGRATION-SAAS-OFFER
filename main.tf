module "vm" {
  source              = "./modules/virtual_machine"
  resource_group_name = var.resource_group_name
  location            = var.location
  vm_name             = var.vm_name
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  vm_size             = var.vm_size
  tags                = var.tags 
}

module "api_service_manager" {
  source              = "./modules/api_management"
  resource_group_name = var.resource_group_name
  location            = var.location  # Update with your desired location if different
  vm_public_ip        = module.vm.application_vm_public_ip_
  tags                = var.tags 
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  api_service_manager_name = var.api_service_manager_name
  }

module "automation" {
  source                 = "./modules/automationaccount"
  tags                   = var.tags
  automation_account_name = var.automation_account_name
  resource_group_name     = var.resource_group_name
  location                = var.location
  powershell_script       = file("vm_delete_script.ps1")  # Reference to your Python script
  email_powershell_script_immediate = file("email_powershell_script_immediate.ps1")
  email_powershell_script_24hrs   = file("email_powershell_script_24hrs.ps1")
  email_powershell_script_48hrs   = file("email_powershell_script_48hrs.ps1")
  runbook_name            = var.runbook_name          # Ensure this variable is passed
  schedule_name           = var.schedule_name            # Ensure this variable is passed
  schedule_frequency      = var.schedule_frequency
  schedule_interval       = var.schedule_interval
  vm_public_ip_address   = module.vm.application_vm_public_ip_
  api_service_manager_name = var.api_service_manager_name
  username = var.username
  password = var.password
}




