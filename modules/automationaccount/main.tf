# Create Automation Account
resource "azurerm_automation_account" "example" {
  name                = var.automation_account_name
  tags                = var.tags
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Basic"
}

resource "azurerm_automation_variable_string" "vm_ip_address" {
  name                    = "VM_IP_Address"
  resource_group_name     = azurerm_automation_account.example.resource_group_name
  automation_account_name = azurerm_automation_account.example.name
  value                   = var.vm_public_ip_address
  description             = "The IP address of the VM to be used in runbooks."
}

resource "azurerm_automation_variable_string" "api_service_manager_name" {
  name                    = "API_Service_Manager_Name"
  resource_group_name     = azurerm_automation_account.example.resource_group_name
  automation_account_name = azurerm_automation_account.example.name
  value                   = var.api_service_manager_name
  description             = "The name of the API Service Manager to be used in runbooks."
}

resource "azurerm_automation_variable_string" "username" {
  name                    = "username"
  resource_group_name     = azurerm_automation_account.example.resource_group_name
  automation_account_name = azurerm_automation_account.example.name
  value                   = var.username
  description             = "The username to be used in runbooks."
}

resource "azurerm_automation_variable_string" "password" {
  name                    = "password"
  resource_group_name     = azurerm_automation_account.example.resource_group_name
  automation_account_name = azurerm_automation_account.example.name
  value                   = var.password
  description             = "The password to be used in runbooks."
}

# Create Automation Runbook with PowerShell script content
resource "azurerm_automation_runbook" "example" {
  name                    = "${var.automation_account_name}-delete-vm-runbook"
  location                = azurerm_automation_account.example.location
  resource_group_name     = azurerm_automation_account.example.resource_group_name
  automation_account_name = azurerm_automation_account.example.name
  tags                = var.tags
  log_progress            = true
  log_verbose             = true
  runbook_type            = "PowerShell"  # Changed to PowerShell
  content                 = var.powershell_script # Reference to the PowerShell script

  depends_on = [azurerm_automation_account.example]
}



# Schedule for the Automation Runbook to run once
resource "azurerm_automation_schedule" "example" {
  name                    = "vmdelete-automation-schedule"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.example.name
  frequency               = "OneTime"  # Set frequency to OneTime
  start_time              = timeadd(timestamp(), "43h")  # Add 48 hours (2 days) to the current time
  timezone                = "Asia/Kolkata"  # Set timezone to IST (Asia/Kolkata)
  description             = "This is an dmapssas schedule that runs once."
}

# Link the schedule with the runbook to create an Automation Job Schedule
resource "azurerm_automation_job_schedule" "example" {
  
  resource_group_name     = azurerm_automation_account.example.resource_group_name
  automation_account_name = azurerm_automation_account.example.name
  runbook_name            = azurerm_automation_runbook.example.name
  schedule_name           = azurerm_automation_schedule.example.name
}

# ---------------------------------- RUNBOOKS AND SCHEDULES FOR EMAIL SENDING ----------------------------------

# Runbook for sending the first email immediately
resource "azurerm_automation_runbook" "email_runbook_immediate" {
  name                    = "${var.automation_account_name}-send-email-immediate"
  location                = azurerm_automation_account.example.location
  tags                = var.tags
  resource_group_name     = azurerm_automation_account.example.resource_group_name
  automation_account_name = azurerm_automation_account.example.name
  log_progress            = true
  log_verbose             = true
  runbook_type            = "PowerShell"
  content                 = var.email_powershell_script_immediate  # PowerShell script for sending the immediate email
  depends_on              = [azurerm_automation_account.example]
}

# Runbook for sending the second email after 24 hours
resource "azurerm_automation_runbook" "email_runbook_24hrs" {
  name                    = "${var.automation_account_name}-send-email-24hrs"
  location                = azurerm_automation_account.example.location
  tags                = var.tags
  resource_group_name     = azurerm_automation_account.example.resource_group_name
  automation_account_name = azurerm_automation_account.example.name
  log_progress            = true
  log_verbose             = true
  runbook_type            = "PowerShell"
  content                 = var.email_powershell_script_24hrs  # PowerShell script for sending the 24-hour email
  depends_on              = [azurerm_automation_account.example]
}

# Runbook for sending the third email after 48 hours
resource "azurerm_automation_runbook" "email_runbook_48hrs" {
  name                    = "${var.automation_account_name}-send-email-48hrs"
  location                = azurerm_automation_account.example.location
  tags                = var.tags
  resource_group_name     = azurerm_automation_account.example.resource_group_name
  automation_account_name = azurerm_automation_account.example.name
  log_progress            = true
  log_verbose             = true
  runbook_type            = "PowerShell"
  content                 = var.email_powershell_script_48hrs  # PowerShell script for sending the 48-hour email
  depends_on              = [azurerm_automation_account.example]
}

# ---------------------------------- SCHEDULES ----------------------------------

# Schedule for sending the first email immediately
resource "azurerm_automation_schedule" "email_schedule_immediate" {
  name                    = "send-email-immediate"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.example.name
  frequency               = "OneTime"
  start_time              = timeadd(timestamp(), "10m")  # Immediate run
  timezone                = "Asia/Kolkata"
  description             = "This is a schedule that sends an email immediately."
}

# Schedule for sending the second email after 24 hours
resource "azurerm_automation_schedule" "email_schedule_24hrs" {
  name                    = "send-email-24hrs"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.example.name
  frequency               = "OneTime"
  start_time              = timeadd(timestamp(), "24h")  # Run after 24 hours
  timezone                = "Asia/Kolkata"
  description             = "This is a schedule that sends an email after 24 hours."
}

# Schedule for sending the third email after 48 hours
resource "azurerm_automation_schedule" "email_schedule_48hrs" {
  name                    = "send-email-48hrs"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.example.name
  frequency               = "OneTime"
  start_time              = timeadd(timestamp(), "43h")  # Run after 48 hours
  timezone                = "Asia/Kolkata"
  description             = "This is a schedule that sends an email after 48 hours."
}

# ---------------------------------- JOB SCHEDULES ----------------------------------

# Link the immediate email schedule with the immediate email runbook
resource "azurerm_automation_job_schedule" "email_job_schedule_immediate" {
  resource_group_name     = azurerm_automation_account.example.resource_group_name
  automation_account_name = azurerm_automation_account.example.name
  runbook_name            = azurerm_automation_runbook.email_runbook_immediate.name
  schedule_name           = azurerm_automation_schedule.email_schedule_immediate.name
}

# Link the 24-hour email schedule with the 24-hour email runbook
resource "azurerm_automation_job_schedule" "email_job_schedule_24hrs" {
  resource_group_name     = azurerm_automation_account.example.resource_group_name
  automation_account_name = azurerm_automation_account.example.name
  runbook_name            = azurerm_automation_runbook.email_runbook_24hrs.name
  schedule_name           = azurerm_automation_schedule.email_schedule_24hrs.name
}

# Link the 48-hour email schedule with the 48-hour email runbook
resource "azurerm_automation_job_schedule" "email_job_schedule_48hrs" {
  resource_group_name     = azurerm_automation_account.example.resource_group_name
  automation_account_name = azurerm_automation_account.example.name
  runbook_name            = azurerm_automation_runbook.email_runbook_48hrs.name
  schedule_name           = azurerm_automation_schedule.email_schedule_48hrs.name
}