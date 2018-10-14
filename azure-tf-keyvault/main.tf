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

resource "azurerm_azuread_application" "test" {
  name                       = "tfvault2"
  homepage                   = "https://homepage"
  identifier_uris            = ["https://uri"]
  reply_urls                 = ["https://replyurl"]
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = true
}

resource "azurerm_resource_group" "test" {
  name     = "${var.rg_name}"
  location = "${var.rg_location}"
}

resource "azurerm_key_vault" "test" {
  name                = "pctestabc"
  location            = "${var.rg_location}"
  resource_group_name = "${azurerm_resource_group.test.name}"

  sku {
    name = "standard"
  }

  tenant_id = "${var.tenant_id}"

  access_policy {
    tenant_id = "${var.tenant_id}"
    object_id = "${azurerm_azuread_application.test.id}"

    # Need to set more permissiions fef: https://www.terraform.io/docs/providers/azurerm/r/key_vault_certificate.html
    key_permissions = [
      "get",
    ]

    secret_permissions = [
      "get",
    ]
  }

  enabled_for_disk_encryption = true

  tags {
    environment = "Production"
  }
}

output "application_id" {
  value = "${azurerm_azuread_application.test.application_id }"
}
