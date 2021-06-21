module "aks" {
  source                 = "./modules/aks"
  location               = var.location
  aks                    = var.aks
  resource_group_name    = azurerm_resource_group.rg.name
  environment            = var.environment
  default_tags           = var.default_tags
  vnet_subnet_id         = azurerm_subnet.clusters.id
  admin_groupAd_ObjectId = var.admin_groupAd_ObjectId
  subnet_gatewayId       = azurerm_subnet.subnet_gateway.id
  app_gateway_sku        = var.app_gateway_sku
  qty_aks                = 2
  unique_id              = local.unique_id
}
