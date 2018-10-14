# Azure Auth info
variable subscription_id {}

variable tenant_id {}
variable client_id {}
variable client_secret {}

# Worker Info
variable "worker_l_vm_count" {
  default = 1
}

variable "worker_w_vm_count" {
  default = 1
}

# Master Info
variable "master_vm_count" {
  default = 1
}

variable "rg_name" {
  default = "k8s-testing"
}

variable "rg_location" {
  default = "northeurope"
}

variable "azureadmin" {
  default = "azureadmin"
}

variable "sshrsa" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjSwu84MLpxgAqTuSw9eq5LFGGZgAAwBneWX2sjAnN7+qkG3sLYJOS9XmVIrkJpN5Msnxio7xh0Zad5Z8yQbwoxU7s+cPHo9DsUi6NThg/VigArb8gsQeONoHIoHXK5DBulo8OvikUAs3R8q7irBFbissMLgy8SwelgCXIrJ6+an/M74JW88VuyCLQ8RhTnNefvauoEQLHsjDBn38zgjpKuqcMqHifFkYtVRsl2smpxNC0VZJAXHZTllBribAvn12lQl/2wg9K1Y16ds1Oh+cIAsq60wD2rhewQnLzFLhbw1rIbCZK7b94nOuMem0BuF7YRyKVqcg0V18lQNc/6OpaShV6HgnhxSKyGnmQYHW7QQSG25sugP7Y1PJUQzJPNS2G2JFNBTXyQlBbPE7cIGIEgzH3eIVX26Wgo9yeZo89FMKKQcb8lDDYqFCOA1EUeDuuXvqG0Du4g902lIYZBevZhEAX27PZwKTzIeYjKABsl2/ZoBKUr5ED/7EnF3RrKaqw3YM8BaVSdKeeFgivak6lkYELo60o1jJHupJCA83bV/GzsU71O7IPqTobFjvwckqCsFTN/fhkKIkAU2Vc5dPwDXnL8EjL2dVNUPetCxPhT9XWtA+kRfuaTBDy2zslvCktZn/2RPUzADDz79HcXRqa+nIbar+B8EeaSWYhWVL/xQ=="
}

# Ref: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes
variable "worker_vm_size" {
  default = "Standard_B2ms"
}

variable "master_vm_size" {
  default = "Standard_B1s"
}

variable "worker_w_vm_size" {}
