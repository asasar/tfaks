resource "helm_release" "ingress-0" {
  depends_on = [azurerm_kubernetes_cluster.aks[0], helm_release.aad_pod_identity_0]

  #  depends_on      = [helm_release.aad_pod_identity]
  name       = "application-gateway-kubernetes-ingress-0"
  repository = "https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/"
  chart      = "ingress-azure"
  version    = "1.4.0"
  timeout    = 1800

  set {
    type  = "string"
    name  = "appgw.subscriptionId"
    value = data.azurerm_client_config.current.subscription_id
  }

  set {
    type  = "string"
    name  = "appgw.resourceGroup"
    value = var.resource_group_name
  }

  set {
    type  = "string"
    name  = "appgw.name"
    value = azurecaf_name.names.results["azurerm_application_gateway"]
  }

  set {
    type  = "string"
    name  = "appgw.usePrivateIP"
    value = "false"
  }

  set {
    type  = "string"
    name  = "appgw.shared"
    value = "false"
  }

  set {
    type  = "string"
    name  = "armAuth.type"
    value = "aadPodIdentity"
  }

  set {
    type  = "string"
    name  = "armAuth.identityResourceID"
    value = azurerm_user_assigned_identity.app_gateway_managed_identity.id
  }

  set {
    type  = "string"
    name  = "armAuth.identityClientID"
    value = azurerm_user_assigned_identity.app_gateway_managed_identity.client_id
  }

  set {
    type  = "string"
    name  = "rbac.enabled"
    value = "true"
  }

  set {
    type  = "string"
    name  = "verbosityLevel"
    value = "true"
  }
}


resource "helm_release" "ingress-1" {
  depends_on = [azurerm_kubernetes_cluster.aks[1], helm_release.aad_pod_identity_1]
  provider   = helm.second
  name       = "application-gateway-kubernetes-ingress-1"
  repository = "https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/"
  chart      = "ingress-azure"
  version    = "1.4.0"
  timeout    = 1800

  set {
    type  = "string"
    name  = "appgw.subscriptionId"
    value = data.azurerm_client_config.current.subscription_id
  }

  set {
    type  = "string"
    name  = "appgw.resourceGroup"
    value = var.resource_group_name
  }

  set {
    type  = "string"
    name  = "appgw.name"
    value = azurecaf_name.names.results["azurerm_application_gateway"]
  }

  set {
    type  = "string"
    name  = "appgw.usePrivateIP"
    value = "false"
  }

  set {
    type  = "string"
    name  = "appgw.shared"
    value = "true"
  }

  set {
    type  = "string"
    name  = "armAuth.type"
    value = "aadPodIdentity"
  }

  set {
    type  = "string"
    name  = "armAuth.identityResourceID"
    value = azurerm_user_assigned_identity.app_gateway_managed_identity.id
  }

  set {
    type  = "string"
    name  = "armAuth.identityClientID"
    value = azurerm_user_assigned_identity.app_gateway_managed_identity.client_id
  }

  set {
    type  = "string"
    name  = "rbac.enabled"
    value = "true"
  }
}
