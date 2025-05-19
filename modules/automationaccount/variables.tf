variable "automation_account_name" {
  description = "Name of the Automation Account"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}
variable "vm_public_ip_address" {
  type        = string
  description = "The public IP address of the VM"
}
variable "username" {
  description = "Username for the automation account"
  type        = string
}
variable "password" {
  description = "Password for the automation account"
  type        = string
}
variable "api_service_manager_name" {
  description = "Name of the API Service Manager"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "powershell_script" {
  description = "Powershell script content"
  type        = string
}
variable "email_powershell_script_immediate" {
  description = "email Powershell script content"
  type        = string
}
variable "email_powershell_script_24hrs" {
  description = "email Powershell script content"
  type        = string
}
variable "email_powershell_script_48hrs" {
  description = "email Powershell script content"
  type        = string
}

variable "schedule_name" {
  description = "Name of the schedule for the runbook"
  type        = string
}

variable "schedule_frequency" {
  description = "Frequency for the schedule (Hour, Minute, Day)"
  type        = string
}
variable "runbook_name" {
  description = "Name of the Runbook"
  type        = string  # Example default value
}
variable "schedule_interval" {
  description = "Interval for the schedule (e.g., every 5 minutes)"
  type        = number
}
variable "tags" {
  type    = map(string)
  default = {}
}

