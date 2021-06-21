
resource "random_string" "random" {
  length  = 2
  special = false
}

locals {
  unique_id = random_string.random.result
}

resource "azurecaf_name" "names" {
  name           = "demo"
  resource_type  = "azurerm_resource_group"
  resource_types = ["azurerm_virtual_network"]
  prefixes       = ["april", var.environment, local.unique_id]
  suffixes       = ["exakis"]
  clean_input    = true
}


resource "azurerm_resource_group" "rg" {
  name     = azurecaf_name.names.result
  location = var.location
  tags = merge(
    var.default_tags,
    {
      display_name = "App AKS Resource Group",
      created      = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp()),
      lastDeploy   = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
    }
  )
}
