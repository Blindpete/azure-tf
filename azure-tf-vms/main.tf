# backend strage
terraform {
  backend "azurerm" {}
}

provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
}

# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "terraformgroup" {
  name     = "${var.rg_name}"
  location = "${var.rg_location}"

  tags {
    environment = "Terraform K8s"
  }
}

# Create virtual network
resource "azurerm_virtual_network" "terraformnetwork" {
  name                = "K8sVnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.rg_location}"
  resource_group_name = "${azurerm_resource_group.terraformgroup.name}"

  tags {
    environment = "Terraform K8s"
  }
}

# Create subnet
resource "azurerm_subnet" "terraformsubnet" {
  name                 = "K8sSunet"
  resource_group_name  = "${azurerm_resource_group.terraformgroup.name}"
  virtual_network_name = "${azurerm_virtual_network.terraformnetwork.name}"
  address_prefix       = "10.0.1.0/24"
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = "${azurerm_resource_group.terraformgroup.name}"
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = "${azurerm_resource_group.terraformgroup.name}"
  location                 = "${var.rg_location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags {
    environment = "Terraform K8s"
  }
}
