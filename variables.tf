############################
# Common vars
############################
variable "environment" {
  description = "The environment name (e.g., dev, prod) used for resource naming."
  type        = string
  default     = "dev"
  validation {
    condition     = length(var.environment) > 0
    error_message = "The environment name must not be empty."
  }
}

variable "default_tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(any)
  validation {
    condition     = length(keys(var.default_tags)) > 0
    error_message = "The default_tags map must not be empty."
  }
}

variable "region" {
  description = "The Azure region where the resources will be deployed."
  type        = string
  default     = "weu"
  validation {
    condition     = length(var.region) > 0
    error_message = "The region must not be empty."
  }
}

############################
# Resource groups vars
############################
variable "resource_group_location" {
  description = "Specifies the supported Azure location where the resource group exists. Changing this forces a new resource to be created."
  default     = "West Europe"
  type        = string
  validation {
    condition     = length(var.resource_group_location) > 0
    error_message = "The resource group location must not be empty."
  }
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Redis instance. Changing this forces a new resource to be created."
  type        = string
  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "The resource group name must not be empty."
  }
}

############################
# REDIS CACHE variables
############################
variable "redis_cache_tier" {
  description = "The SKU tier of Redis to use. Possible values are Basic, Standard, and Premium."
  type        = string
  default     = "Standard"
  validation {
    condition     = var.redis_cache_tier == "Basic" || var.redis_cache_tier == "Standard" || var.redis_cache_tier == "Premium"
    error_message = "The redis_cache_tier must be either 'Basic', 'Standard', or 'Premium'."
  }
}

variable "redis_cache_name" {
  description = "The name of the Redis instance. Changing this forces a new resource to be created."
  type        = string
  validation {
    condition     = length(var.redis_cache_name) > 0
    error_message = "The redis_cache_name must not be empty."
  }
}

variable "redis_cache_capacity" {
  description = "The size of the Redis cache to deploy. Valid values for a SKU family of C (Basic/Standard) are 0, 1, 2, 3, 4, 5, 6, and for P (Premium) family are 1, 2, 3, 4."
  type        = string
  default     = "2"
  validation {
    condition     = contains(["0", "1", "2", "3", "4", "5", "6"], var.redis_cache_capacity) || contains(["1", "2", "3", "4"], var.redis_cache_capacity)
    error_message = "The redis_cache_capacity must be one of the following: 0, 1, 2, 3, 4, 5, 6 for Basic/Standard, or 1, 2, 3, 4 for Premium."
  }
}

variable "redis_cache_family" {
  description = "The SKU family/pricing group to use. Valid values are C (for Basic/Standard SKU family) and P (for Premium)."
  type        = string
  default     = "C"
  validation {
    condition     = var.redis_cache_family == "C" || var.redis_cache_family == "P"
    error_message = "The redis_cache_family must be either 'C' or 'P'."
  }
}

variable "redis_cache_enable_non_ssl_port" {
  description = "Whether to enable the non-SSL port (6379). Disabled by default."
  type        = string
  default     = "false"
  validation {
    condition     = var.redis_cache_enable_non_ssl_port == "true" || var.redis_cache_enable_non_ssl_port == "false"
    error_message = "The redis_cache_enable_non_ssl_port must be either 'true' or 'false'."
  }
}

variable "redis_cache_minimum_tls_version" {
  description = "The minimum TLS version to support. Defaults to 1.2."
  type        = string
  default     = "1.2"
  validation {
    condition     = contains(["1.0", "1.1", "1.2", "1.3"], var.redis_cache_minimum_tls_version)
    error_message = "The redis_cache_minimum_tls_version must be one of the following: '1.0', '1.1', '1.2', '1.3'."
  }
}

variable "redis_cache_maxmemory_reserved" {
  description = "The value in megabytes reserved for non-cache usage (e.g., for failover)."
  type        = string
  default     = "10"
  validation {
    condition     = can(regex("^[0-9]+$", var.redis_cache_maxmemory_reserved))
    error_message = "The redis_cache_maxmemory_reserved must be a numeric value."
  }
}

variable "redis_cache_maxmemory_delta" {
  description = "The max-memory delta for the Redis instance in megabytes."
  type        = string
  default     = "2"
  validation {
    condition     = can(regex("^[0-9]+$", var.redis_cache_maxmemory_delta))
    error_message = "The redis_cache_maxmemory_delta must be a numeric value."
  }
}

variable "redis_cache_maxmemory_policy" {
  description = "The policy that Redis will use to select items to remove when maxmemory is reached. Default is 'allkeys-lru'."
  type        = string
  default     = "allkeys-lru"
  validation {
    condition     = contains(["volatile-lru", "allkeys-lru", "volatile-random", "allkeys-random", "volatile-ttl", "noeviction"], var.redis_cache_maxmemory_policy)
    error_message = "The redis_cache_maxmemory_policy must be one of the following: 'volatile-lru', 'allkeys-lru', 'volatile-random', 'allkeys-random', 'volatile-ttl', 'noeviction'."
  }
}
