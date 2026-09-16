output "id" {
  description = "The ID of the Redis Cache."
  value       = azurerm_redis_cache.main.id
  sensitive   = false
}

output "name" {
  description = "The name of the Redis Cache."
  value       = azurerm_redis_cache.main.name
  sensitive   = false
}

output "hostname" {
  description = "The Hostname of the Redis Instance."
  value       = azurerm_redis_cache.main.hostname
  sensitive   = false
}

output "port" {
  description = "The non-SSL Port of the Redis Instance."
  value       = azurerm_redis_cache.main.port
  sensitive   = false
}

output "ssl_port" {
  description = "The SSL Port of the Redis Instance."
  value       = azurerm_redis_cache.main.ssl_port
  sensitive   = false
}

output "primary_access_key" {
  description = "The Primary Access Key for the Redis Instance."
  value       = azurerm_redis_cache.main.primary_access_key
  sensitive   = true
}

output "secondary_access_key" {
  description = "The Secondary Access Key for the Redis Instance."
  value       = azurerm_redis_cache.main.secondary_access_key
  sensitive   = true
}

output "primary_connection_string" {
  description = "The primary connection string of the Redis Instance."
  value       = azurerm_redis_cache.main.primary_connection_string
  sensitive   = true
}

output "secondary_connection_string" {
  description = "The secondary connection string of the Redis Instance."
  value       = azurerm_redis_cache.main.secondary_connection_string
  sensitive   = true
}

output "redis_configuration" {
  description = "The Redis configuration of the Redis Instance."
  value       = azurerm_redis_cache.main.redis_configuration
  sensitive   = false
}
