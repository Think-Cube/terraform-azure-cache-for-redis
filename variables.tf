############################
#Common vars
############################
variable "environment" {
  description = "Var used for backend container name key"
  type = string
  default = "dev"
}
variable "tag_environment" {
  description = "A mapping of tags to assign to the resource."
  type = string
  default = "dev"
}
variable "resource_owner" {
  description = "A mapping of tags to assign to the resource."
  type = string
  default = "Test organization"
}
variable "region" {
  description = "Region in which resources are deployed"
  type = string
  default = "weu"
}
############################
#Resource gropus vars
############################
variable "resource_group_location" {
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  default = "West Europe"
  type = string
}
variable "resource_group_name" {
  description = "The name of the resource group in which to create the Redis instance. Changing this forces a new resource to be created."
  type = string
}
############################
#REDIS CACHE variable
############################
variable "redis_cache_tier" {
    description = "The SKU of Redis to use. Possible values are Basic, Standard and Premium."
    type = string
    default = "Standard"
}
variable "redis_cache_name" {
    description = "The name of the Redis instance. Changing this forces a new resource to be created."
    type = string

}
variable "redis_cache_capacity" {
    description = "The size of the Redis cache to deploy. Valid values for a SKU family of C (Basic/Standard) are 0, 1, 2, 3, 4, 5, 6, and for P (Premium) family are 1, 2, 3, 4"
    type = string
    default = "2"
}
variable "redis_cache_family" {
    description = "The SKU family/pricing group to use. Valid values are C (for Basic/Standard SKU family) and P (for Premium)"
    type = string
    default = "C"
}
variable "redis_cache_enable_non_ssl_port" {
    description = "Enable the non-SSL port (6379) - disabled by default."
    type = string
    default = "false"
}
variable "redis_cache_minimum_tls_version" {
    description = "The minimum TLS version. Defaults to 1.0."
    type = string
    default = "1.2"
}
variable "redis_cache_maxmemory_reserved" {
    description = "The value in megabytes reserved for non-cache usage e.g. failover"
    type = string
    default = "10"
}
variable "redis_cache_maxmemory_delta" {
    description = "The max-memory delta for this Redis instance."
    type = string
    default = "2"
}
variable "redis_cache_maxmemory_policy" {
    description = "How Redis will select what to remove when maxmemory is reached."
    type = string
    default = "allkeys-lru"
}