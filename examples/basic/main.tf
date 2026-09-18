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
}