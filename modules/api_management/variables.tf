variable "resource_group_name" {
  description = "Existing resource group name"
  type        = string
  default     = "DMAP_SaaS"
}

variable "api_service_manager_name" {
  description = "Name of the API Service Manager"
  type        = string
}
variable "publisher_name" {
  description = "Name of the publisher"
  type        = string
}
variable "publisher_email" {
  description = "Email of the publisher"
  type        = string
}
variable "location" {
  description = "Azure region for the API Service Manager"
  type        = string
  default     = "East US"
}
variable "vm_public_ip" {
  type        = string
  description = "Admin password for the VM"
}
variable "tags" {
  type    = map(string)
  default = {}
}
