## How to use

```
provider "azurerm" {
features {}
}

module "cache-for-redis" {
  source  = "spy86/cache-for-redis/azure"
  version = "1.0.3"
  redis_cache_name = "test"
  resource_group_name = "weu-test-rg"
  environment = "dev"
  redis_cache_capacity = "2"
  redis_cache_enable_non_ssl_port = "false"
  redis_cache_family = "C"
  redis_cache_maxmemory_delta = "2"
  redis_cache_maxmemory_policy = "allkeys-lru"
  redis_cache_maxmemory_reserved = "10"
  redis_cache_minimum_tls_version = "1.2"
  redis_cache_tier = "Standard"
  region = "weu"
  resource_group_location = "West Europe"

  default_tags = {
      Administrator = "Someone"
      Department = "IT"
      CostCentre = "ABC123"
      ContactPerson = "Someone@example.com"
      ManagedByTerraform = "True"
}
}
```