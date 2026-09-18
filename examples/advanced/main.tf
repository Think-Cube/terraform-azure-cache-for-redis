module "redis" {
  source = "github.com/Think-Cube/terraform-azure-cache-for-redis?ref=v1.0.0"

  name                          = "redis-prod-example"
  resource_group_name           = "rg-example"
  location                      = "West Europe"
  sku_name                      = "Premium"
  family                        = "P"
  capacity                      = 1
  non_ssl_port_enabled          = false
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false
  redis_version                 = "6"
  replicas_per_primary          = 1
  zones                         = ["1", "2"]

  redis_configuration = {
    maxmemory_policy    = "allkeys-lru"
    maxmemory_reserved  = 50
    maxmemory_delta     = 50
    authentication_enabled = true
  }

  patch_schedules = [
    {
      day_of_week        = "Sunday"
      start_hour_utc     = 2
      maintenance_window = "PT5H"
    }
  ]

  identity = {
    type = "SystemAssigned"
  }

  tags = {
    environment = "prod"
    managed_by  = "terraform"
  }
}