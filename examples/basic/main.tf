module "redis_cache" {
  source                          = "./terraform-azure-cache-for-redis"
  environment                     = "dev"
  region                          = "westeurope"
  resource_group_name             = "rg-example"
  redis_cache_name                = "app"
  redis_cache_capacity            = 1
  redis_cache_family              = "C"
  redis_cache_tier                = "Standard"
  redis_cache_enable_non_ssl_port = false
  redis_cache_minimum_tls_version = "1.2"
  redis_cache_maxmemory_reserved  = 50
  redis_cache_maxmemory_delta     = 50
  redis_cache_maxmemory_policy    = "allkeys-lru"
  default_tags = {
    environment = "dev"
    project     = "example"
  }
}
