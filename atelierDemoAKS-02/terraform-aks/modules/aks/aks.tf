

resource "azurerm_kubernetes_cluster" "aks" {
  count               = var.qty_aks
  kubernetes_version  = var.aks.kubversion
  name                = "${azurecaf_name.names.result}${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "dnsprefix-${azurecaf_name.names.result}${count.index}"
  tags                = merge(var.default_tags, tomap({ "type" = "aks" }))
  node_resource_group = "${azurecaf_name.names.result}${count.index}-node"

  identity {
    type = "SystemAssigned"
  }

  linux_profile {
    admin_username = "azureuser"

    ssh_key {
      key_data = tls_private_key.key_ssh.public_key_openssh
    }
  }

  default_node_pool {
    name                 = "coreaks${count.index}"
    node_count           = var.aks.node_count
    vm_size              = var.aks.aksvm_size
    orchestrator_version = var.aks.kubversion
    vnet_subnet_id       = var.vnet_subnet_id
  }

  role_based_access_control {
    enabled = true
    azure_active_directory {
      managed                = true
      admin_group_object_ids = [var.admin_groupAd_ObjectId]
    }
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = var.aks.network.network_policy
    dns_service_ip     = var.aks.network.dns_service_ip
    docker_bridge_cidr = var.aks.network.docker_bridge_cidr
    service_cidr       = var.aks.network.service_cidr
  }

  addon_profile {
    http_application_routing {
      enabled = false
    }
    azure_policy {
      enabled = true
    }
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.aks.id
    }
  }

  timeouts {
    create = "15m"
  }
}
