<!-- BEGIN_TF_DOCS -->
#### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.4 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.0.1 |

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.0.1 |

#### Resources

| Name | Type |
|------|------|
| [azurerm_redis_cache.main](https://registry.terraform.io/providers/hashicorp/azurerm/4.0.1/docs/resources/redis_cache) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/4.0.1/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/4.0.1/docs/data-sources/resource_group) | data source |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | A mapping of tags to assign to the resource. | `map(any)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name (e.g., dev, prod) used for resource naming. | `string` | `"dev"` | no |
| <a name="input_redis_cache_capacity"></a> [redis\_cache\_capacity](#input\_redis\_cache\_capacity) | The size of the Redis cache to deploy. Valid values for a SKU family of C (Basic/Standard) are 0, 1, 2, 3, 4, 5, 6, and for P (Premium) family are 1, 2, 3, 4. | `string` | `"2"` | no |
| <a name="input_redis_cache_enable_non_ssl_port"></a> [redis\_cache\_enable\_non\_ssl\_port](#input\_redis\_cache\_enable\_non\_ssl\_port) | Whether to enable the non-SSL port (6379). Disabled by default. | `string` | `"false"` | no |
| <a name="input_redis_cache_family"></a> [redis\_cache\_family](#input\_redis\_cache\_family) | The SKU family/pricing group to use. Valid values are C (for Basic/Standard SKU family) and P (for Premium). | `string` | `"C"` | no |
| <a name="input_redis_cache_maxmemory_delta"></a> [redis\_cache\_maxmemory\_delta](#input\_redis\_cache\_maxmemory\_delta) | The max-memory delta for the Redis instance in megabytes. | `string` | `"2"` | no |
| <a name="input_redis_cache_maxmemory_policy"></a> [redis\_cache\_maxmemory\_policy](#input\_redis\_cache\_maxmemory\_policy) | The policy that Redis will use to select items to remove when maxmemory is reached. Default is 'allkeys-lru'. | `string` | `"allkeys-lru"` | no |
| <a name="input_redis_cache_maxmemory_reserved"></a> [redis\_cache\_maxmemory\_reserved](#input\_redis\_cache\_maxmemory\_reserved) | The value in megabytes reserved for non-cache usage (e.g., for failover). | `string` | `"10"` | no |
| <a name="input_redis_cache_minimum_tls_version"></a> [redis\_cache\_minimum\_tls\_version](#input\_redis\_cache\_minimum\_tls\_version) | The minimum TLS version to support. Defaults to 1.2. | `string` | `"1.2"` | no |
| <a name="input_redis_cache_name"></a> [redis\_cache\_name](#input\_redis\_cache\_name) | The name of the Redis instance. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_redis_cache_tier"></a> [redis\_cache\_tier](#input\_redis\_cache\_tier) | The SKU tier of Redis to use. Possible values are Basic, Standard, and Premium. | `string` | `"Standard"` | no |
| <a name="input_region"></a> [region](#input\_region) | The Azure region where the resources will be deployed. | `string` | `"weu"` | no |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | Specifies the supported Azure location where the resource group exists. Changing this forces a new resource to be created. | `string` | `"West Europe"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the Redis instance. Changing this forces a new resource to be created. | `string` | n/a | yes |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_hostname"></a> [hostname](#output\_hostname) | The Hostname of the Redis Instance |
| <a name="output_id"></a> [id](#output\_id) | The Route ID. |
| <a name="output_redis_cache_port"></a> [redis\_cache\_port](#output\_redis\_cache\_port) | The non-SSL Port of the Redis Instance |
| <a name="output_redis_cache_primary_access_key"></a> [redis\_cache\_primary\_access\_key](#output\_redis\_cache\_primary\_access\_key) | The Primary Access Key for the Redis Instance |
| <a name="output_redis_cache_primary_connection_string"></a> [redis\_cache\_primary\_connection\_string](#output\_redis\_cache\_primary\_connection\_string) | The primary connection string of the Redis Instance. |
| <a name="output_redis_cache_secondary_access_key"></a> [redis\_cache\_secondary\_access\_key](#output\_redis\_cache\_secondary\_access\_key) | The Secondary Access Key for the Redis Instance |
| <a name="output_redis_cache_secondary_connection_string"></a> [redis\_cache\_secondary\_connection\_string](#output\_redis\_cache\_secondary\_connection\_string) | The secondary connection string of the Redis Instance. |
| <a name="output_redis_cache_ssl_port"></a> [redis\_cache\_ssl\_port](#output\_redis\_cache\_ssl\_port) | The SSL Port of the Redis Instance |
<!-- END_TF_DOCS -->