resource "azurerm_log_analytics_workspace" "aks" {
  name                = azurecaf_name.names.results["azurerm_log_analytics_workspace"]
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  retention_in_days   = 30
  tags                = merge(var.default_tags, tomap({ "type" = "log_analytics" }))
}
