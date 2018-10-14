# Create public IPs
resource "azurerm_public_ip" "master_publicip" {
  count                        = "${var.master_vm_count}"
  name                         = "pip_master_${count.index}"
  location                     = "${var.rg_location}"
  resource_group_name          = "${azurerm_resource_group.terraformgroup.name}"
  public_ip_address_allocation = "dynamic"

  tags {
    environment = "Terraform K8s"
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "master_nsg" {
  count               = "${var.master_vm_count}"
  name                = "NSG_master_${count.index}"
  location            = "${var.rg_location}"
  resource_group_name = "${azurerm_resource_group.terraformgroup.name}"

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    environment = "Terraform K8s"
  }
}

# Create network interface
resource "azurerm_network_interface" "master_nic" {
  count                     = "${var.master_vm_count}"
  name                      = "NIC_master_${count.index}"
  location                  = "${var.rg_location}"
  resource_group_name       = "${azurerm_resource_group.terraformgroup.name}"
  network_security_group_id = "${element(azurerm_network_security_group.master_nsg.*.id, count.index)}"

  ip_configuration {
    name                          = "myNicConfiguration-${count.index}"
    subnet_id                     = "${azurerm_subnet.terraformsubnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${element(azurerm_public_ip.master_publicip.*.id, count.index)}"
  }

  tags {
    environment = "Terraform K8s"
  }
}

# Create virtual machine
resource "azurerm_virtual_machine" "master_vm" {
  count                 = "${var.master_vm_count}"
  name                  = "master-${count.index}"
  location              = "${var.rg_location}"
  resource_group_name   = "${azurerm_resource_group.terraformgroup.name}"
  network_interface_ids = ["${element(azurerm_network_interface.master_nic.*.id, count.index)}"]
  vm_size               = "${var.master_vm_size}"

  storage_os_disk {
    name              = "masterOsDisk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "master-${count.index}"
    admin_username = "${var.azureadmin}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.azureadmin}/.ssh/authorized_keys"
      key_data = "${var.sshrsa}"
    }
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
  }

  tags {
    environment = "Terraform K8s"
  }
}

output "public_ip_address" {
  value = "${azurerm_public_ip.master_publicip.*.ip_address}"
}
