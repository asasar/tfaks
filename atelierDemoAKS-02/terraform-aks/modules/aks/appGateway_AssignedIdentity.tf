resource "azurerm_user_assigned_identity" "app_gateway_managed_identity" {
  location            = var.location
  resource_group_name = var.resource_group_name
  name                = azurecaf_name.names.results["azurerm_user_assigned_identity"]
}

# Give the new Azure Identity "Contributor" role to your Application Gateway
resource "azurerm_role_assignment" "app_gateway_managed_identity_contributor" {
  scope                = azurerm_application_gateway.appGateway.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.app_gateway_managed_identity.principal_id
}

# Give the new Azure Identity "Reader" role to the Application Gateway resource group
resource "azurerm_role_assignment" "app_gateway_managed_identity_reader" {
  scope                = data.azurerm_resource_group.aks.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.app_gateway_managed_identity.principal_id
}
