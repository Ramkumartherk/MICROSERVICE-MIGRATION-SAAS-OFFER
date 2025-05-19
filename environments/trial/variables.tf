variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "location" {
  type        = string
  description = "The location of the resources"
}

variable "vm_name" {
  type        = string
  description = "The name of the virtual machine"
}

variable "acr_login_server" {
  type        = string
  description = "The login server for the Azure Container Registry (ACR)"
}

variable "image_name" {
  type        = string
  description = "The name of the container image in ACR"
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
  default     = "Standard_DC2ds_v3"
}

