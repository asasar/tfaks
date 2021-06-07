provider "azurerm" {
  features {}
}

resource "random_string" "random" {
  length  = 2
  special = false
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-aks-demo-${random_string.random.result}-dev-neu"
  location = "france central"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-aks-demo-${random_string.random.result}-dev-neu"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kubernetes_version  = "1.18.17"
  dns_prefix          = "demo-dev-neu"
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }
  identity {
    type = "SystemAssigned"
  }
}

output "aksName" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "rgName" {
  value = azurerm_resource_group.rg.name
}
