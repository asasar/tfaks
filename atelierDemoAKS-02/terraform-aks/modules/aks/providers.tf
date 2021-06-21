
terraform {
  #backend "azurerm" {}
  required_version = ">= 0.13"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      #version = ">=2.35.0"
    }

    azurecaf = {
      source = "aztfmod/azurecaf"
      #version = ">=1.1.5"
    }
  }
}
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

data "azurerm_client_config" "current" {}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.aks[0].kube_admin_config.0.host
    username               = azurerm_kubernetes_cluster.aks[0].kube_admin_config.0.username
    password               = azurerm_kubernetes_cluster.aks[0].kube_admin_config.0.password
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks[0].kube_admin_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks[0].kube_admin_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks[0].kube_admin_config.0.cluster_ca_certificate)
  }
}

provider "helm" {
  alias = "second"
  kubernetes {
    host                   = azurerm_kubernetes_cluster.aks[1].kube_admin_config.0.host
    username               = azurerm_kubernetes_cluster.aks[1].kube_admin_config.0.username
    password               = azurerm_kubernetes_cluster.aks[1].kube_admin_config.0.password
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks[1].kube_admin_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks[1].kube_admin_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks[1].kube_admin_config.0.cluster_ca_certificate)
  }
}
