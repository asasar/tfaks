resource "azurerm_key_vault" "keyVault" {
  name                       = replace(replace(azurecaf_name.names.results["azurerm_key_vault"], "demoasr", "demoasr01"), "-", "")
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  tags                       = merge(var.default_tags, tomap({ "type" = "kv" }))
  access_policy {
    tenant_id          = data.azurerm_client_config.current.tenant_id
    object_id          = data.azurerm_client_config.current.object_id
    key_permissions    = ["create", "get", "purge", "list", "recover", "delete"]
    secret_permissions = ["set", "get", "purge", "list", "delete"]
  }
}

resource "azurerm_key_vault_access_policy" "groupAd" {
  key_vault_id       = azurerm_key_vault.keyVault.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = var.admin_groupAd_ObjectId
  key_permissions    = ["create", "get", "purge", "list", "recover", "delete"]
  secret_permissions = ["set", "get", "purge", "list", "delete"]
}

resource "azurerm_key_vault_access_policy" "aksIdentity" {
  count = var.qty_aks

  key_vault_id       = azurerm_key_vault.keyVault.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azurerm_kubernetes_cluster.aks[count.index].kubelet_identity[0].object_id
  key_permissions    = ["create", "get", "purge", "list", "recover", "delete"]
  secret_permissions = ["set", "get", "purge", "list", "delete"]
}


resource "azurerm_key_vault_access_policy" "appgateway" {
  key_vault_id       = azurerm_key_vault.keyVault.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azurerm_user_assigned_identity.app_gateway_managed_identity.principal_id
  key_permissions    = ["create", "get", "purge", "list", "recover", "delete"]
  secret_permissions = ["set", "get", "purge", "list", "delete"]
}

resource "azurerm_key_vault_secret" "client_certificate" {
  count        = var.qty_aks
  name         = "${azurerm_kubernetes_cluster.aks[count.index].name}--client--certificate"
  value        = azurerm_kubernetes_cluster.aks[count.index].kube_config.0.client_certificate
  key_vault_id = azurerm_key_vault.keyVault.id
}

resource "azurerm_key_vault_secret" "kvsecretkube_config" {
  count        = var.qty_aks
  name         = "${azurerm_kubernetes_cluster.aks[count.index].name}--kube--config"
  value        = azurerm_kubernetes_cluster.aks[count.index].kube_config_raw
  key_vault_id = azurerm_key_vault.keyVault.id
}


resource "azurerm_key_vault_secret" "acr_id" {
  depends_on   = [azurerm_container_registry.acr]
  name         = "acr--id"
  value        = azurerm_container_registry.acr.id
  key_vault_id = azurerm_key_vault.keyVault.id
}

resource "azurerm_key_vault_secret" "acr_login_server" {
  depends_on   = [azurerm_container_registry.acr]
  name         = "acr--loginServer"
  value        = azurerm_container_registry.acr.login_server
  key_vault_id = azurerm_key_vault.keyVault.id
}

resource "azurerm_key_vault_secret" "acr_admin_username" {
  depends_on   = [azurerm_container_registry.acr]
  name         = "acr--adminUsername"
  value        = azurerm_container_registry.acr.admin_username
  key_vault_id = azurerm_key_vault.keyVault.id
}

resource "azurerm_key_vault_secret" "acr_admin_password" {
  depends_on   = [azurerm_container_registry.acr]
  name         = "acr--adminPassword"
  value        = azurerm_container_registry.acr.admin_password
  key_vault_id = azurerm_key_vault.keyVault.id
}

resource "azurerm_key_vault_secret" "aks_private_key_pem" {
  name         = "aks--privatekey--pem"
  value        = tls_private_key.key_ssh.private_key_pem
  key_vault_id = azurerm_key_vault.keyVault.id
}

resource "azurerm_key_vault_secret" "aks_public_key_openssh" {
  name         = "aks--publickey--openssh"
  value        = tls_private_key.key_ssh.public_key_openssh
  key_vault_id = azurerm_key_vault.keyVault.id
}


resource "azurerm_key_vault_secret" "aks_clientkey" {
  count        = var.qty_aks
  name         = "${azurerm_kubernetes_cluster.aks[count.index].name}--aks--clientkey"
  value        = azurerm_kubernetes_cluster.aks[count.index].kube_config.0.client_key
  key_vault_id = azurerm_key_vault.keyVault.id
}


resource "azurerm_key_vault_secret" "aks_cluster_ca_certificate" {
  count        = var.qty_aks
  name         = "${azurerm_kubernetes_cluster.aks[count.index].name}--aks--clustercacertificate"
  value        = azurerm_kubernetes_cluster.aks[count.index].kube_config.0.cluster_ca_certificate
  key_vault_id = azurerm_key_vault.keyVault.id
}


resource "azurerm_key_vault_secret" "aks_username" {
  count        = var.qty_aks
  name         = "${azurerm_kubernetes_cluster.aks[count.index].name}--aks--username"
  value        = azurerm_kubernetes_cluster.aks[count.index].kube_config.0.username
  key_vault_id = azurerm_key_vault.keyVault.id
}


resource "azurerm_key_vault_secret" "aks_password" {
  count        = var.qty_aks
  name         = "${azurerm_kubernetes_cluster.aks[count.index].name}--aks--password"
  value        = azurerm_kubernetes_cluster.aks[count.index].kube_config.0.password
  key_vault_id = azurerm_key_vault.keyVault.id
}

resource "azurerm_key_vault_secret" "aks_host" {
  count        = var.qty_aks
  name         = "${azurerm_kubernetes_cluster.aks[count.index].name}--aks--host"
  value        = azurerm_kubernetes_cluster.aks[count.index].kube_config.0.host
  key_vault_id = azurerm_key_vault.keyVault.id
}

