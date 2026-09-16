# Terraform Module — Azure Cache for Redis

Provisions an `azurerm_redis_cache` with configurable capacity, family, SKU, TLS version, and optional cluster sharding.

## Usage

```hcl
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
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_redis_cache.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_cache) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_capacity"></a> [capacity](#input\_capacity) | The size of the Redis cache to deploy. Valid values for a SKU family of C (Basic/Standard) are 0, 1, 2, 3, 4, 5, 6, and for P (Premium) family are 1, 2, 3, 4. | `number` | `2` | no |
| <a name="input_family"></a> [family](#input\_family) | The SKU family/pricing group to use. Valid values are C (for Basic/Standard SKU family) and P (for Premium). | `string` | `"C"` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | Optional identity block. | <pre>object({<br>    type         = string<br>    identity_ids = optional(list(string), [])<br>  })</pre> | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_minimum_tls_version"></a> [minimum\_tls\_version](#input\_minimum\_tls\_version) | The minimum TLS version. Defaults to 1.2. | `string` | `"1.2"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the Redis instance. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_non_ssl_port_enabled"></a> [non\_ssl\_port\_enabled](#input\_non\_ssl\_port\_enabled) | Enable the non-SSL port (6379). Disabled by default. | `bool` | `false` | no |
| <a name="input_patch_schedules"></a> [patch\_schedules](#input\_patch\_schedules) | List of patch schedule blocks. | <pre>list(object({<br>    day_of_week        = string<br>    start_hour_utc     = optional(number, null)<br>    maintenance_window = optional(string, null)<br>  }))</pre> | `[]` | no |
| <a name="input_private_static_ip_address"></a> [private\_static\_ip\_address](#input\_private\_static\_ip\_address) | The Static IP Address to assign to the Redis Cache when hosted inside the Virtual Network. | `string` | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether or not public network access is allowed for this Redis Cache. | `bool` | `true` | no |
| <a name="input_redis_configuration"></a> [redis\_configuration](#input\_redis\_configuration) | Optional Redis configuration block. | <pre>object({<br>    aof_backup_enabled                    = optional(bool, null)<br>    aof_storage_connection_string_0       = optional(string, null)<br>    aof_storage_connection_string_1       = optional(string, null)<br>    authentication_enabled                = optional(bool, null)<br>    active_directory_authentication_enabled = optional(bool, null)<br>    data_persistence_authentication_method = optional(string, null)<br>    maxfragmentationmemory_reserved       = optional(number, null)<br>    maxmemory_delta                       = optional(number, null)<br>    maxmemory_policy                      = optional(string, null)<br>    maxmemory_reserved                    = optional(number, null)<br>    notify_keyspace_events                = optional(string, null)<br>    rdb_backup_enabled                    = optional(bool, null)<br>    rdb_backup_frequency                  = optional(number, null)<br>    rdb_backup_max_snapshot_count         = optional(number, null)<br>    rdb_storage_connection_string         = optional(string, null)<br>    storage_account_subscription_id       = optional(string, null)<br>  })</pre> | `null` | no |
| <a name="input_redis_version"></a> [redis\_version](#input\_redis\_version) | Redis version. Only major version needed. Valid values: 4, 6. | `string` | `null` | no |
| <a name="input_replicas_per_master"></a> [replicas\_per\_master](#input\_replicas\_per\_master) | Amount of replicas to create per master for this Redis Cache. Changing this forces a new resource to be created. (Premium only) | `number` | `null` | no |
| <a name="input_replicas_per_primary"></a> [replicas\_per\_primary](#input\_replicas\_per\_primary) | Amount of replicas to create per primary for this Redis Cache. Changing this forces a new resource to be created. (Premium only) | `number` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the Redis instance. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_shard_count"></a> [shard\_count](#input\_shard\_count) | Only available when using the Premium SKU. The number of Shards to create on the Redis Cluster. | `number` | `null` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU of Redis to use. Possible values are Basic, Standard and Premium. | `string` | `"Standard"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Only available when using the Premium SKU. The ID of the Subnet within which the Redis Cache should be deployed. (Premium only) | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_tenant_settings"></a> [tenant\_settings](#input\_tenant\_settings) | A mapping of tenant settings to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | Specifies a list of Availability Zones in which this Redis Cache should be located. Changing this forces a new Redis Cache to be created. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hostname"></a> [hostname](#output\_hostname) | The Hostname of the Redis Instance. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Redis Cache. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Redis Cache. |
| <a name="output_port"></a> [port](#output\_port) | The non-SSL Port of the Redis Instance. |
| <a name="output_primary_access_key"></a> [primary\_access\_key](#output\_primary\_access\_key) | The Primary Access Key for the Redis Instance. |
| <a name="output_primary_connection_string"></a> [primary\_connection\_string](#output\_primary\_connection\_string) | The primary connection string of the Redis Instance. |
| <a name="output_redis_configuration"></a> [redis\_configuration](#output\_redis\_configuration) | The Redis configuration of the Redis Instance. |
| <a name="output_secondary_access_key"></a> [secondary\_access\_key](#output\_secondary\_access\_key) | The Secondary Access Key for the Redis Instance. |
| <a name="output_secondary_connection_string"></a> [secondary\_connection\_string](#output\_secondary\_connection\_string) | The secondary connection string of the Redis Instance. |
| <a name="output_ssl_port"></a> [ssl\_port](#output\_ssl\_port) | The SSL Port of the Redis Instance. |
<!-- END_TF_DOCS -->