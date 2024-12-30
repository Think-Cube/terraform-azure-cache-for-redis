output "id" {
  description = "The Route ID of the Redis Cache instance."
  value       = azurerm_redis_cache.main.id
  sensitive   = false
}

output "hostname" {
  description = "The Hostname of the Redis Cache instance."
  value       = azurerm_redis_cache.main.hostname
  sensitive   = false
}

output "redis_cache_ssl_port" {
  description = "The SSL Port of the Redis Cache instance."
  value       = azurerm_redis_cache.main.ssl_port
  sensitive   = false
}

output "redis_cache_port" {
  description = "The non-SSL Port of the Redis Cache instance."
  value       = azurerm_redis_cache.main.port
  sensitive   = true
}

output "redis_cache_primary_access_key" {
  description = "The Primary Access Key for the Redis Cache instance."
  value       = azurerm_redis_cache.main.primary_access_key
  sensitive   = true
}

output "redis_cache_secondary_access_key" {
  description = "The Secondary Access Key for the Redis Cache instance."
  value       = azurerm_redis_cache.main.secondary_access_key
  sensitive   = true
}

output "redis_cache_primary_connection_string" {
  description = "The primary connection string for the Redis Cache instance."
  value       = azurerm_redis_cache.main.primary_connection_string
  sensitive   = true
}

output "redis_cache_secondary_connection_string" {
  description = "The secondary connection string for the Redis Cache instance."
  value       = azurerm_redis_cache.main.secondary_connection_string
  sensitive   = true
}
