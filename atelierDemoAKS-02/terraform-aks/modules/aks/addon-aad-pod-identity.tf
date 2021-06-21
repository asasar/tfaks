
resource "helm_release" "aad_pod_identity_0" {
  depends_on = [azurerm_kubernetes_cluster.aks]
  name       = "aad-pod-identity-0"
  namespace  = "default"
  repository = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  chart      = "aad-pod-identity"
  version    = "4.1.1"
  timeout    = 1800

  # Use auto update of synced kubernetes secrets, see https://github.com/kubernetes-sigs/secrets-store-csi-driver/blob/master/docs/README.rotation.md#enable-auto-rotation
  set {
    name  = "secrets-store-csi-driver.enableSecretRotation"
    value = "true"
  }
}

resource "helm_release" "aad_pod_identity_1" {
  provider   = helm.second
  depends_on = [azurerm_kubernetes_cluster.aks]
  name       = "aad-pod-identity-1"
  namespace  = "default"
  repository = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  chart      = "aad-pod-identity"
  version    = "4.1.1"
  timeout    = 1800
  # Use auto update of synced kubernetes secrets, see https://github.com/kubernetes-sigs/secrets-store-csi-driver/blob/master/docs/README.rotation.md#enable-auto-rotation
  set {
    name  = "secrets-store-csi-driver.enableSecretRotation"
    value = "true"
  }

  # The provider checks if it actually has access to the key vault
}
