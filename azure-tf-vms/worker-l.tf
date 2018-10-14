# Create public IPs
resource "azurerm_public_ip" "worker_l_publicip" {
  count                        = "${var.worker_l_vm_count}"
  name                         = "pip-worker-l-${count.index}"
  location                     = "${var.rg_location}"
  resource_group_name          = "${azurerm_resource_group.terraformgroup.name}"
  public_ip_address_allocation = "dynamic"

  tags {
    environment = "Terraform K8s"
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "worker_l_nsg" {
  count               = "${var.worker_l_vm_count}"
  name                = "NSG-worker-l-${count.index}"
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
resource "azurerm_network_interface" "worker_l_nic" {
  count                     = "${var.worker_l_vm_count}"
  name                      = "NIC-worker-l-${count.index}"
  location                  = "${var.rg_location}"
  resource_group_name       = "${azurerm_resource_group.terraformgroup.name}"
  network_security_group_id = "${element(azurerm_network_security_group.worker_l_nsg.*.id, count.index)}"

  ip_configuration {
    name                          = "myNicConfiguration-${count.index}"
    subnet_id                     = "${azurerm_subnet.terraformsubnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${element(azurerm_public_ip.worker_l_publicip.*.id, count.index)}"
  }

  tags {
    environment = "Terraform K8s"
  }
}

# Create virtual machine
resource "azurerm_virtual_machine" "worker_l_vm" {
  count                 = "${var.worker_l_vm_count}"
  name                  = "worker-l-${count.index}"
  location              = "${var.rg_location}"
  resource_group_name   = "${azurerm_resource_group.terraformgroup.name}"
  network_interface_ids = ["${element(azurerm_network_interface.worker_l_nic.*.id, count.index)}"]
  vm_size               = "${var.worker_vm_size}"

  storage_os_disk {
    name              = "workerlOsDisk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.5"
    version   = "latest"
  }

  os_profile {
    computer_name  = "worker-l-${count.index}"
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
