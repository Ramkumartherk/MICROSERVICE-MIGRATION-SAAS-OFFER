terraform {
  backend "azurerm" {
    resource_group_name   = "DMAP_SaaS"                   # Your existing resource group
    storage_account_name  = "dmapsaasstorageaccount"       # Your existing storage account
    container_name        = "saascontainer"                      # Newly created container
     key                   = "test"       # State file name
  }
}