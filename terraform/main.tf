provider "azurerm" {
  features {}
}

# get the image that was create by the packer script
data "azurerm_image" "webimage" {
  name                = "ubuntuImage"
  resource_group_name = var.packer_resource_group
}

# Create the resource group
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-rg"
  location = var.location
}
# create a virtual network
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/22"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    project = "DEND"
    environment = "development"
  }
}

# Create the subnet
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create the network security group
resource "azurerm_network_security_group" "main" {
  name                = "acceptanceTestSecurityGroup1"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    project = "DEND"
    environment = "development"
  }
}

# Create security rules
resource "azurerm_network_security_rule" "rule1" {
    name                         = "DenyAllInbound"
    description                  = "This rule deny all inbound traffic."
    priority                     = 110
    direction                    = "Inbound"
    access                       = "Deny"
    protocol                     = "*"
    source_port_range            = "*"
    destination_port_range       = "*"
    source_address_prefix        = "*"
    destination_address_prefix   = "*"
    resource_group_name          = azurerm_resource_group.main.name
    network_security_group_name  = azurerm_network_security_group.main.name
}

resource "azurerm_network_security_rule" "rule2" {
    name                         = "AllowInboundInsideVN"
    description                  = "This rule allow inbound traffic inside the same VN."
    priority                     = 101
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix        = "VirtualNetwork"
    destination_address_prefix   = "VirtualNetwork"
    resource_group_name          = azurerm_resource_group.main.name
    network_security_group_name  = azurerm_network_security_group.main.name
}

resource "azurerm_network_security_rule" "rule3" {
    name                         = "AllowOutboundInsideVN"
    description                  = "This rule allow outbound traffic inside the same VN."
    priority                     = 105
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix        = "VirtualNetwork"
    destination_address_prefix   = "VirtualNetwork"
    resource_group_name          = azurerm_resource_group.main.name
    network_security_group_name  = azurerm_network_security_group.main.name
}



# Create network interface
resource "azurerm_network_interface" "main" {
  count               = var.num_vms
  name                = "${var.prefix}-nic-${count.index}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
     project = "DEND"
    environment = "development"
  }
}

# Create public IP
resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}-public-ip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"

  tags = {
     project = "DEND"
    environment = "development"
  }
}

# Create load balancer
resource "azurerm_lb" "main" {
  name                = "${var.prefix}-lb"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.main.id
  }
}

# The load balancer will use this backend pool
resource "azurerm_lb_backend_address_pool" "main" {
  loadbalancer_id     = azurerm_lb.main.id
  name                = "${var.prefix}-lb-backend-pool"
}

# We associate the LB with the backend address pool
resource "azurerm_network_interface_backend_address_pool_association" "main" {
    count                 = var.num_vms
  network_interface_id    = azurerm_network_interface.main[count.index].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
}

# Create virtual machine availability set
resource "azurerm_availability_set" "main" {
  name                = "${var.prefix}-aset"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
 platform_fault_domain_count  = var.num_vms
   platform_update_domain_count = var.num_vms
  
  tags = {
     project = "DEND"
    environment = "development"
  }
}

# Create the virtual machines
resource "azurerm_linux_virtual_machine" "main" {
  count                           = var.num_vms
  name                            = "${var.prefix}-vm-${count.index}"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_D2s_v3"
  admin_username                  = "${var.username}"
  admin_password                  = "${var.password}"
  disable_password_authentication = false
  network_interface_ids = [element(azurerm_network_interface.main.*.id, count.index)]
  availability_set_id = azurerm_availability_set.main.id

  source_image_id = data.azurerm_image.webimage.id

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = {
    project = "DEND"
    environment = "development"
  }
}
