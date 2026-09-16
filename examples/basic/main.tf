module "redis" {
  source = "github.com/Think-Cube/terraform-azure-cache-for-redis?ref=v1.0.0"

  name                = "my-redis"
  resource_group_name = "my-rg"
  location            = "West Europe"
  capacity            = 1
  family              = "C"
  sku_name            = "Standard"

  minimum_tls_version    = "1.2"
  non_ssl_port_enabled   = false

  redis_configuration = {
    maxmemory_policy = "allkeys-lru"
  }

  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}