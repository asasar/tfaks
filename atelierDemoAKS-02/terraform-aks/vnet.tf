resource "azurerm_virtual_network" "vnet" {
  name                = azurecaf_name.names.results["azurerm_virtual_network"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.aks.vnet.vnetaddress_space]
  tags                = merge(var.default_tags, tomap({ "type" = "VNet" }))
}

resource "azurerm_subnet" "clusters" {
  name                 = "aks"
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = [var.aks.vnet.vnetcluster_address_prefixes]
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_subnet" "subnet_gateway" {
  name                 = "gateway"
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = [var.aks.vnet.vnetgateway_address_prefixes]
  virtual_network_name = azurerm_virtual_network.vnet.name
}
