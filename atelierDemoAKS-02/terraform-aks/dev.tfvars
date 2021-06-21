default_tags = {
    application   = "aks-demo1"
    environment   = "dev"
    Location      = "Lyon"
}

environment = "dev"
admin_groupAd_ObjectId="fca593dd-494d-44a8-995f-c545a5e1a795"

aks = {
  aksvm_size                 = "Standard_D2_v2"
  kubversion                 = "1.19.9"
  nameRGNodes                = "akstest"
  node_count                 = 2
  vnet_subnet_id             = ""
  log_analytics_workspace_id = ""
  network =  {
      network_policy     = "calico"
      dns_service_ip     = "10.0.0.10"
      docker_bridge_cidr = "172.17.0.1/16"
      service_cidr       = "10.0.0.0/16"
    }

    vnet = {
      vnetaddress_space                    = "172.23.16.0/20"
      vnetgateway_address_prefixes         = "172.23.30.0/24"
      vnetcluster_address_prefixes         = "172.23.16.0/22"
      vnetcluster_address_prefixesfrontend = "172.23.24.0/24"
      vnetcluster_address_prefixesmiddle   = "172.23.26.0/23"
      vnetcluster_address_prefixesbackend  = "172.23.28.0/23"
  }
}