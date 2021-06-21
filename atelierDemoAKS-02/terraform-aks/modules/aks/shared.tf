
resource "tls_private_key" "key_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurecaf_name" "names" {
  name          = "demo"
  resource_type = "azurerm_kubernetes_cluster"
  resource_types = [
    "azurerm_public_ip",
    "azurerm_application_gateway",
    "azurerm_user_assigned_identity",
    "azurerm_container_registry",
    "azurerm_log_analytics_workspace",
    "azurerm_key_vault"
  ]
  prefixes    = ["april", var.environment, var.unique_id]
  suffixes    = ["exakis"]
  clean_input = true
}

data "azurerm_resource_group" "aks" {
  name = var.resource_group_name
}
data "azurerm_resource_group" "aksNodes" {
  depends_on = [azurerm_kubernetes_cluster.aks]
  count      = var.qty_aks
  name       = azurerm_kubernetes_cluster.aks[count.index].node_resource_group
}

