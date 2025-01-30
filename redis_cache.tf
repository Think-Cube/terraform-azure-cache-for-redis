resource "azurerm_redis_cache" "main" {
  name                 = "${var.environment}-${var.redis_cache_name}-${var.region}-redis"
  location             = data.azurerm_resource_group.rg.location
  resource_group_name  = data.azurerm_resource_group.rg.name
  capacity             = var.redis_cache_capacity
  family               = var.redis_cache_family
  sku_name             = var.redis_cache_tier
  non_ssl_port_enabled = var.redis_cache_enable_non_ssl_port
  minimum_tls_version  = var.redis_cache_minimum_tls_version
  redis_configuration {
    maxmemory_reserved  = var.redis_cache_maxmemory_reserved
    maxmemory_delta     = var.redis_cache_maxmemory_delta
    maxmemory_policy    = var.redis_cache_maxmemory_policy
  }
  tags = var.default_tags
}
