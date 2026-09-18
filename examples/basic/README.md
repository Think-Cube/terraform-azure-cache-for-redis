# Example: Basic

Minimal working example for `terraform-azure-cache-for-redis`.

```hcl
module "redis" {
  source = "github.com/Think-Cube/terraform-azure-cache-for-redis?ref=v1.0.0"

  name                = "redis-dev-example"
  resource_group_name = "rg-example"
  location            = "West Europe"
  sku_name            = "Standard"
  family              = "C"
  capacity            = 1

  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}```` 

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_redis"></a> [redis](#module\_redis) | github.com/Think-Cube/terraform-azure-cache-for-redis | v1.0.0 |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->