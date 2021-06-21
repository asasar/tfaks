

resource "azurerm_role_assignment" "aks_oms" {
  count                = var.qty_aks
  scope                = azurerm_kubernetes_cluster.aks[count.index].id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id         = azurerm_kubernetes_cluster.aks[count.index].addon_profile[0].oms_agent[0].oms_agent_identity[0].object_id
}

resource "azurerm_role_assignment" "aks_subnet" {
  count                = var.qty_aks
  scope                = var.vnet_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks[count.index].identity[0].principal_id
}

resource "azurerm_role_assignment" "aks_acr" {
  count                = var.qty_aks
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks[count.index].kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "aks_rg_mio" {
  count                = var.qty_aks
  scope                = data.azurerm_resource_group.aks.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_kubernetes_cluster.aks[count.index].kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "aks_rg_nodes_mio" {
  depends_on           = [azurerm_kubernetes_cluster.aks]
  count                = var.qty_aks
  scope                = data.azurerm_resource_group.aksNodes[count.index].id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_kubernetes_cluster.aks[count.index].kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "aks_rg_vmc" {
  depends_on           = [azurerm_kubernetes_cluster.aks]
  count                = var.qty_aks
  scope                = data.azurerm_resource_group.aksNodes[count.index].id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks[count.index].kubelet_identity[0].object_id
}
