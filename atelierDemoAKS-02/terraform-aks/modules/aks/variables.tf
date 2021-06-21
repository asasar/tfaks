variable "location" {
  description = "Resource location"
  type        = string
  default     = "westus2"
}

variable "environment" {
  description = "name of environment"
  type        = string
}

variable "default_tags" {
  description = "list of tags"
}

variable "admin_groupAd_ObjectId" {
}

variable "vnet_subnet_id" {

}
variable "resource_group_name" {}
variable "aks" {
  description = "The AKS configuration."
  type = object({
    aksvm_size                 = string
    kubversion                 = string
    node_count                 = number
    log_analytics_workspace_id = string
    vnet = object({
      vnetaddress_space                    = string
      vnetcluster_address_prefixes         = string
      vnetgateway_address_prefixes         = string
      vnetcluster_address_prefixesfrontend = string
      vnetcluster_address_prefixesbackend  = string
      vnetcluster_address_prefixesmiddle   = string
    })
    network = object({
      network_policy     = string
      dns_service_ip     = string
      docker_bridge_cidr = string
      service_cidr       = string
    })
  })
}

variable "cluster" {
  description = "Name of the Application Gateway SKU."
  default     = "Standard_v2"
}

variable "subnet_gatewayId" {
}

variable "app_gateway_sku" {
  description = "Name of the Application Gateway SKU."
  default     = "Standard_v2"
}

variable "qty_aks" {
  default = 1
}

variable "unique_id" {
}

