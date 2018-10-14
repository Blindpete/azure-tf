# Create public IPs
resource "azurerm_public_ip" "worker_w_publicip" {
  count                        = "${var.worker_w_vm_count}"
  name                         = "pip-worker-w-${count.index}"
  location                     = "${var.rg_location}"
  resource_group_name          = "${azurerm_resource_group.terraformgroup.name}"
  public_ip_address_allocation = "dynamic"

  tags {
    environment = "Terraform K8s"
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "worker_w_nsg" {
  count               = "${var.worker_w_vm_count}"
  name                = "NSG-worker-w-${count.index}"
  location            = "${var.rg_location}"
  resource_group_name = "${azurerm_resource_group.terraformgroup.name}"

  security_rule {
    name                       = "RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    environment = "Terraform K8s"
  }
}

# Create network interface
resource "azurerm_network_interface" "worker_w_nic" {
  count                     = "${var.worker_w_vm_count}"
  name                      = "NIC_worker_w_${count.index}"
  location                  = "${var.rg_location}"
  resource_group_name       = "${azurerm_resource_group.terraformgroup.name}"
  network_security_group_id = "${element(azurerm_network_security_group.worker_w_nsg.*.id, count.index)}"

  ip_configuration {
    name                          = "myNicConfiguration-w-${count.index}"
    subnet_id                     = "${azurerm_subnet.terraformsubnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${element(azurerm_public_ip.worker_w_publicip.*.id, count.index)}"
  }

  tags {
    environment = "Terraform K8s"
  }
}

# Create virtual machine
resource "azurerm_virtual_machine" "worker_w_vm" {
  count                 = "${var.worker_w_vm_count}"
  name                  = "worker-w-${count.index}"
  location              = "${var.rg_location}"
  resource_group_name   = "${azurerm_resource_group.terraformgroup.name}"
  network_interface_ids = ["${element(azurerm_network_interface.worker_w_nic.*.id, count.index)}"]
  vm_size               = "${var.worker_vm_size}"

  storage_os_disk {
    name              = "workerwOsDisk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServerSemiAnnual"
    sku       = "Datacenter-Core-1803-with-Containers-smalldisk" # Update to 1809 when ready
    version   = "latest"
  }

  os_profile {
    computer_name  = "worker-w-${count.index}"
    admin_username = "${var.azureadmin}"
    admin_password = "mN#?[mu'qcq5'/?$YBuLUtT7sQBN6=?u" #OTP Iagmore it ;)
  }

  os_profile_windows_config {
    enable_automatic_upgrades = true
    provision_vm_agent        = true
  }

  tags {
    environment = "Terraform K8s"
  }
}
