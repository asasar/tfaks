resource "azurerm_container_registry" "acr" {
  name                = azurecaf_name.names.results["azurerm_container_registry"]
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Basic"
  admin_enabled       = false
  tags                = merge(var.default_tags, tomap({ "type" = "acr" }))
}

