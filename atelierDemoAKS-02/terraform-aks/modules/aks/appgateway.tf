resource "azurerm_public_ip" "pip" {
  name                = azurecaf_name.names.results["azurerm_public_ip"]
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

locals {
  vnetName                       = "aks"
  backend_address_pool_name      = "${local.vnetName}-beap"
  frontend_port_name             = "${local.vnetName}-feport"
  frontend_ip_configuration_name = "${local.vnetName}-feip"
  http_setting_name              = "${local.vnetName}-be-htst"
  listener_name                  = "${local.vnetName}-httplstn"
  request_routing_rule_name      = "${local.vnetName}-rqrt"
}

resource "azurerm_application_gateway" "appGateway" {
  name                = azurecaf_name.names.results["azurerm_application_gateway"]
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = var.app_gateway_sku
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = azurerm_public_ip.pip.name
    subnet_id = var.subnet_gatewayId
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_port {
    name = "httpsPort"
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
    path                  = "/ping/"
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  #   probe {
  #     name                = "mysite.domain.com-probe"
  #     host                = "mysite.domain.com"
  #     path                = "/"
  #     interval            = 30
  #     timeout             = 30
  #     unhealthy_threshold = 3
  #     protocol            = "Http"

  # #    match {
  # #      # define a local for this big list and put it here.
  # #      status_code = [200, 999]
  # #    }
  #   }

  // Ignore most changes as they should be managed by AKS ingress controller
  # lifecycle {
  #   ignore_changes = [
  #     backend_address_pool,
  #     backend_http_settings,
  #     frontend_port,
  #     http_listener,
  #     probe,
  #     request_routing_rule,
  #     url_path_map,
  #     ssl_certificate,
  #     redirect_configuration,
  #     autoscale_configuration,
  #     tags["managed-by-k8s-ingress"],
  #     tags["last-updated-by-k8s-ingress"],
  #   ]
  # }

  tags = merge(var.default_tags, tomap({ "type" = "app gateway" }))
}
