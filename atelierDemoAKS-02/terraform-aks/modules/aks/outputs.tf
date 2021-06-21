output "aksName1" {
  value = azurerm_kubernetes_cluster.aks[0].name
}

output "aksName2" {
  value = azurerm_kubernetes_cluster.aks[1].name
}

output "rgName" {
  value = var.resource_group_name
}

