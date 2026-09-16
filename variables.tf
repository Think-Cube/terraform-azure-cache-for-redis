variable "name" {
  description = "The name of the Redis instance. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Redis instance. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
}

variable "capacity" {
  description = "The size of the Redis cache to deploy. Valid values for a SKU family of C (Basic/Standard) are 0, 1, 2, 3, 4, 5, 6, and for P (Premium) family are 1, 2, 3, 4."
  type        = number
  default     = 2
}

variable "family" {
  description = "The SKU family/pricing group to use. Valid values are C (for Basic/Standard SKU family) and P (for Premium)."
  type        = string
  default     = "C"
}

variable "sku_name" {
  description = "The SKU of Redis to use. Possible values are Basic, Standard and Premium."
  type        = string
  default     = "Standard"
}

variable "non_ssl_port_enabled" {
  description = "Enable the non-SSL port (6379). Disabled by default."
  type        = bool
  default     = false
}

variable "minimum_tls_version" {
  description = "The minimum TLS version. Defaults to 1.2."
  type        = string
  default     = "1.2"
}

variable "public_network_access_enabled" {
  description = "Whether or not public network access is allowed for this Redis Cache."
  type        = bool
  default     = true
}

variable "redis_version" {
  description = "Redis version. Only major version needed. Valid values: 4, 6."
  type        = string
  default     = null
}

variable "replicas_per_master" {
  description = "Amount of replicas to create per master for this Redis Cache. Changing this forces a new resource to be created. (Premium only)"
  type        = number
  default     = null
}

variable "replicas_per_primary" {
  description = "Amount of replicas to create per primary for this Redis Cache. Changing this forces a new resource to be created. (Premium only)"
  type        = number
  default     = null
}

variable "shard_count" {
  description = "Only available when using the Premium SKU. The number of Shards to create on the Redis Cluster."
  type        = number
  default     = null
}

variable "subnet_id" {
  description = "Only available when using the Premium SKU. The ID of the Subnet within which the Redis Cache should be deployed. (Premium only)"
  type        = string
  default     = null
}

variable "private_static_ip_address" {
  description = "The Static IP Address to assign to the Redis Cache when hosted inside the Virtual Network."
  type        = string
  default     = null
}

variable "zones" {
  description = "Specifies a list of Availability Zones in which this Redis Cache should be located. Changing this forces a new Redis Cache to be created."
  type        = list(string)
  default     = null
}

variable "tenant_settings" {
  description = "A mapping of tenant settings to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "redis_configuration" {
  description = "Optional Redis configuration block."
  type = object({
    aof_backup_enabled                    = optional(bool, null)
    aof_storage_connection_string_0       = optional(string, null)
    aof_storage_connection_string_1       = optional(string, null)
    authentication_enabled                = optional(bool, null)
    active_directory_authentication_enabled = optional(bool, null)
    data_persistence_authentication_method = optional(string, null)
    maxfragmentationmemory_reserved       = optional(number, null)
    maxmemory_delta                       = optional(number, null)
    maxmemory_policy                      = optional(string, null)
    maxmemory_reserved                    = optional(number, null)
    notify_keyspace_events                = optional(string, null)
    rdb_backup_enabled                    = optional(bool, null)
    rdb_backup_frequency                  = optional(number, null)
    rdb_backup_max_snapshot_count         = optional(number, null)
    rdb_storage_connection_string         = optional(string, null)
    storage_account_subscription_id       = optional(string, null)
  })
  default = null
}

variable "patch_schedules" {
  description = "List of patch schedule blocks."
  type = list(object({
    day_of_week        = string
    start_hour_utc     = optional(number, null)
    maintenance_window = optional(string, null)
  }))
  default = []
}

variable "identity" {
  description = "Optional identity block."
  type = object({
    type         = string
    identity_ids = optional(list(string), [])
  })
  default = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
