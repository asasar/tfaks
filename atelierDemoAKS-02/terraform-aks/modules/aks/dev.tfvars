default_tags = {
    application   = "aks-demo"
    environment   = "dev"
    deployed_by   = "ASR"
    Location      = "Lyon"
}

environment = "dev"

admin_groupAd_ObjectId="fca593dd-494d-44a8-995f-c545a5e1a795"

aks = {
  aksvm_size                 = "Standard_D2_v2"
  kubversion                 = "1.19.9"
  node_count                 = 2
  log_analytics_workspace_id = ""
  network =  {
      network_policy     = "calico"
      dns_service_ip     = "10.0.0.10"
      docker_bridge_cidr = "172.17.0.1/16"
      service_cidr       = "10.0.0.0/16"
    }

    vnet = {
    vnetaddress_space                    = "10.0.0.0/8"
    vnetcluster_address_prefixes         = "10.240.0.0/16"
    vnetgateway_address_prefixes         = "10.1.0.0/16"
    vnetcluster_address_prefixesfrontend = "10.2.0.0/16"
    vnetcluster_address_prefixesbackend  = "10.3.0.0/16"
    vnetcluster_address_prefixesmiddle   = "10.4.0.0/16"
}
}



