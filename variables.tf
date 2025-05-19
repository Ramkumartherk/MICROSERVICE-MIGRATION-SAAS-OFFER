variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "api_service_manager_name" {
  description = "Name of the API Service Manager"
  type        = string
}

variable "client_secret" {
  type        = string
  description = "subscription id"
}
variable "subscription_id" {
  type        = string
  description = "subscription id"
}
variable "client_id" {
  type        = string
  description = "subscription id"
}
variable "tenant_id" {
  type        = string
  description = "subscription id"
}
variable "location" {
  type        = string
  description = "The location of the resources"
}

variable "vm_name" {
  type        = string
  description = "The name of the virtual machine"
}



variable "admin_username" {
  type        = string
  description = "Admin username for the VM"
}

variable "admin_password" {
  type        = string
  description = "Admin password for the VM"
}



variable "vm_size" {
  type        = string
  description = "The size of the VM"
}



variable "tags" {
  type    = map(string)
  default = {}
}

variable "publisher_name" {
  description = "Name of the publisher"
  type        = string
} 

variable "publisher_email" {
  description = "Email of the publisher"
  type        = string
}

variable "storage_account_name" {
  description = "The name of the storage account."
  type        = string
}


variable "runbook_name" {
  description = "Name of the Runbook"
  type        = string  # Example default value
}

variable "automation_account_name" {
  description = "Name of the Automation Account"
  type        = string
}


variable "schedule_name" {
  description = "Name of the schedule for the runbook"
  type        = string
  default     = "runbook-schedule"  # Example default value
}

variable "username" {
  description = "Username for the automation account"
  type        = string
}

variable "password" {
  description = "Password for the automation account"
  type        = string
}

variable "schedule_frequency" {
  description = "Frequency for the schedule (Hour, Minute, Day)"
  type        = string
  default     = "Minute"
}

variable "schedule_interval" {
  description = "Interval for the schedule (e.g., every 5 minutes)"
  type        = number
  default     = 5
}