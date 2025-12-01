# Terraform Azure Redis Cache Module

This module deploys an **Azure Redis Cache** instance using Terraform.

## Description

The module provisions an Azure Redis Cache configured for a specific environment and region.  
It allows defining performance characteristics, memory policies, and TLS settings.  
It automatically names the resource using the pattern: `<environment>-<redis_cache_name>-<region>-redis`

## Features

- Supports **Basic**, **Standard**, and **Premium** SKUs  
- Configurable **capacity**, **family**, and **TLS version**  
- Option to enable or disable **non-SSL ports**  
- Fine-tuning of **Redis memory configuration** (reserved memory, delta, eviction policy)  
- Automatic tagging for consistency across environments  

## Typical Use Cases

- Caching layer for application workloads  
- Session storage for APIs or web apps  
- Message queue or temporary key-value store  

## Notes

- The module requires an existing **Azure Resource Group**.  
- Ensure that the chosen SKU and capacity are available in your selected region.  
- Default naming convention ensures consistent resource identification across environments.


```
module "redis_cache" {
  source = "./terraform-azure-cache-for-redis"

  environment         = "dev"
  region              = "westeurope"
  resource_group_name = "rg-example"

  redis_cache_name                = "app"
  redis_cache_capacity            = 1
  redis_cache_family              = "C"
  redis_cache_tier                = "Standard"
  redis_cache_enable_non_ssl_port = false
  redis_cache_minimum_tls_version = "1.2"

  redis_cache_maxmemory_reserved = 50
  redis_cache_maxmemory_delta    = 50
  redis_cache_maxmemory_policy   = "allkeys-lru"

  default_tags = {
    environment = "dev"
    project     = "example"
  }
}
```