# Terraform native tests for examples/main.tf
# These tests validate the example configuration for the Azure Redis Cache module

# Test 1: Validate basic example configuration with standard settings
run "validate_basic_example_configuration" {
  command = plan

  variables {
    environment         = "dev"
    region              = "westeurope"
    resource_group_name = "rg-example"
    redis_cache_name                = "app"
    redis_cache_capacity            = 1
    redis_cache_family              = "C"
    redis_cache_tier                = "Standard"
    redis_cache_enable_non_ssl_port = false
    redis_cache_minimum_tls_version = "1.2"
    redis_cache_maxmemory_reserved  = 50
    redis_cache_maxmemory_delta     = 50
    redis_cache_maxmemory_policy    = "allkeys-lru"
    default_tags = {
      environment = "dev"
      project     = "example"
    }
  }

  # Validate that the Redis cache name follows the expected pattern
  assert {
    condition     = azurerm_redis_cache.main.name == "dev-app-westeurope-redis"
    error_message = "Redis cache name should follow the pattern: <environment>-<redis_cache_name>-<region>-redis"
  }

  # Validate SKU configuration
  assert {
    condition     = azurerm_redis_cache.main.sku_name == "Standard"
    error_message = "SKU should be Standard as specified in variables"
  }

  # Validate capacity
  assert {
    condition     = azurerm_redis_cache.main.capacity == 1
    error_message = "Capacity should be 1 as specified in variables"
  }

  # Validate family
  assert {
    condition     = azurerm_redis_cache.main.family == "C"
    error_message = "Family should be C for Standard SKU"
  }

  # Validate TLS version
  assert {
    condition     = azurerm_redis_cache.main.minimum_tls_version == "1.2"
    error_message = "TLS version should be 1.2 for security"
  }

  # Validate non-SSL port is disabled
  assert {
    condition     = azurerm_redis_cache.main.non_ssl_port_enabled == false
    error_message = "Non-SSL port should be disabled for security"
  }

  # Validate resource group name
  assert {
    condition     = azurerm_redis_cache.main.resource_group_name == "rg-example"
    error_message = "Resource group should match the specified name"
  }

  # Validate tags are applied
  assert {
    condition     = azurerm_redis_cache.main.tags["environment"] == "dev"
    error_message = "Environment tag should be set to 'dev'"
  }

  assert {
    condition     = azurerm_redis_cache.main.tags["project"] == "example"
    error_message = "Project tag should be set to 'example'"
  }
}

# Test 2: Validate Premium SKU configuration
run "validate_premium_sku_configuration" {
  command = plan

  variables {
    environment         = "prod"
    region              = "eastus"
    resource_group_name = "rg-prod"
    redis_cache_name                = "cache"
    redis_cache_capacity            = 2
    redis_cache_family              = "P"
    redis_cache_tier                = "Premium"
    redis_cache_enable_non_ssl_port = false
    redis_cache_minimum_tls_version = "1.2"
    redis_cache_maxmemory_reserved  = 100
    redis_cache_maxmemory_delta     = 100
    redis_cache_maxmemory_policy    = "volatile-lru"
    default_tags = {
      environment = "prod"
      tier        = "premium"
    }
  }

  # Validate Premium SKU is applied
  assert {
    condition     = azurerm_redis_cache.main.sku_name == "Premium"
    error_message = "SKU should be Premium as specified"
  }

  # Validate Premium family
  assert {
    condition     = azurerm_redis_cache.main.family == "P"
    error_message = "Family should be P for Premium SKU"
  }

  # Validate capacity for Premium
  assert {
    condition     = azurerm_redis_cache.main.capacity == 2
    error_message = "Capacity should be 2 for Premium SKU"
  }

  # Validate naming convention for different environment
  assert {
    condition     = azurerm_redis_cache.main.name == "prod-cache-eastus-redis"
    error_message = "Redis cache name should follow pattern for prod environment"
  }

  # Validate maxmemory policy
  assert {
    condition     = azurerm_redis_cache.main.redis_configuration[0].maxmemory_policy == "volatile-lru"
    error_message = "Maxmemory policy should be volatile-lru as specified"
  }
}

# Test 3: Validate Basic SKU configuration
run "validate_basic_sku_configuration" {
  command = plan

  variables {
    environment         = "test"
    region              = "northeurope"
    resource_group_name = "rg-test"
    redis_cache_name                = "testcache"
    redis_cache_capacity            = 0
    redis_cache_family              = "C"
    redis_cache_tier                = "Basic"
    redis_cache_enable_non_ssl_port = false
    redis_cache_minimum_tls_version = "1.2"
    redis_cache_maxmemory_reserved  = 10
    redis_cache_maxmemory_delta     = 2
    redis_cache_maxmemory_policy    = "allkeys-lru"
    default_tags = {
      environment = "test"
      cost_center = "engineering"
    }
  }

  # Validate Basic SKU
  assert {
    condition     = azurerm_redis_cache.main.sku_name == "Basic"
    error_message = "SKU should be Basic as specified"
  }

  # Validate minimum capacity
  assert {
    condition     = azurerm_redis_cache.main.capacity == 0
    error_message = "Capacity should be 0 (250MB) for Basic SKU"
  }

  # Validate naming for test environment
  assert {
    condition     = azurerm_redis_cache.main.name == "test-testcache-northeurope-redis"
    error_message = "Redis cache name should include test environment"
  }
}

# Test 4: Validate memory configuration settings
run "validate_memory_configuration" {
  command = plan

  variables {
    environment         = "staging"
    region              = "westus"
    resource_group_name = "rg-staging"
    redis_cache_name                = "api"
    redis_cache_capacity            = 3
    redis_cache_family              = "C"
    redis_cache_tier                = "Standard"
    redis_cache_enable_non_ssl_port = false
    redis_cache_minimum_tls_version = "1.2"
    redis_cache_maxmemory_reserved  = 200
    redis_cache_maxmemory_delta     = 200
    redis_cache_maxmemory_policy    = "allkeys-random"
    default_tags = {
      environment = "staging"
    }
  }

  # Validate maxmemory_reserved
  assert {
    condition     = azurerm_redis_cache.main.redis_configuration[0].maxmemory_reserved == 200
    error_message = "Maxmemory reserved should be 200 MB"
  }

  # Validate maxmemory_delta
  assert {
    condition     = azurerm_redis_cache.main.redis_configuration[0].maxmemory_delta == 200
    error_message = "Maxmemory delta should be 200 MB"
  }

  # Validate maxmemory_policy
  assert {
    condition     = azurerm_redis_cache.main.redis_configuration[0].maxmemory_policy == "allkeys-random"
    error_message = "Maxmemory policy should be allkeys-random"
  }
}

# Test 5: Validate TLS version enforcement
run "validate_tls_1_0_configuration" {
  command = plan

  variables {
    environment         = "legacy"
    region              = "westeurope"
    resource_group_name = "rg-legacy"
    redis_cache_name                = "legacyapp"
    redis_cache_capacity            = 1
    redis_cache_family              = "C"
    redis_cache_tier                = "Standard"
    redis_cache_enable_non_ssl_port = false
    redis_cache_minimum_tls_version = "1.0"
    redis_cache_maxmemory_reserved  = 50
    redis_cache_maxmemory_delta     = 50
    redis_cache_maxmemory_policy    = "allkeys-lru"
    default_tags = {
      environment = "legacy"
    }
  }

  # Validate TLS 1.0 can be set (though not recommended)
  assert {
    condition     = azurerm_redis_cache.main.minimum_tls_version == "1.0"
    error_message = "TLS version should be 1.0 as specified for legacy systems"
  }
}

# Test 6: Validate non-SSL port enabled configuration (edge case)
run "validate_non_ssl_port_enabled" {
  command = plan

  variables {
    environment         = "dev"
    region              = "westeurope"
    resource_group_name = "rg-dev"
    redis_cache_name                = "devtest"
    redis_cache_capacity            = 1
    redis_cache_family              = "C"
    redis_cache_tier                = "Standard"
    redis_cache_enable_non_ssl_port = true
    redis_cache_minimum_tls_version = "1.2"
    redis_cache_maxmemory_reserved  = 50
    redis_cache_maxmemory_delta     = 50
    redis_cache_maxmemory_policy    = "allkeys-lru"
    default_tags = {
      environment = "dev"
    }
  }

  # Validate non-SSL port is enabled when specified
  assert {
    condition     = azurerm_redis_cache.main.non_ssl_port_enabled == true
    error_message = "Non-SSL port should be enabled when specified"
  }
}

# Test 7: Validate different eviction policies
run "validate_noeviction_policy" {
  command = plan

  variables {
    environment         = "prod"
    region              = "westeurope"
    resource_group_name = "rg-prod"
    redis_cache_name                = "cache"
    redis_cache_capacity            = 2
    redis_cache_family              = "C"
    redis_cache_tier                = "Standard"
    redis_cache_enable_non_ssl_port = false
    redis_cache_minimum_tls_version = "1.2"
    redis_cache_maxmemory_reserved  = 100
    redis_cache_maxmemory_delta     = 100
    redis_cache_maxmemory_policy    = "noeviction"
    default_tags = {
      environment = "prod"
    }
  }

  # Validate noeviction policy
  assert {
    condition     = azurerm_redis_cache.main.redis_configuration[0].maxmemory_policy == "noeviction"
    error_message = "Maxmemory policy should be noeviction"
  }
}

# Test 8: Validate volatile-ttl eviction policy
run "validate_volatile_ttl_policy" {
  command = plan

  variables {
    environment         = "prod"
    region              = "westeurope"
    resource_group_name = "rg-prod"
    redis_cache_name                = "sessions"
    redis_cache_capacity            = 1
    redis_cache_family              = "C"
    redis_cache_tier                = "Standard"
    redis_cache_enable_non_ssl_port = false
    redis_cache_minimum_tls_version = "1.2"
    redis_cache_maxmemory_reserved  = 50
    redis_cache_maxmemory_delta     = 50
    redis_cache_maxmemory_policy    = "volatile-ttl"
    default_tags = {
      environment = "prod"
      purpose     = "sessions"
    }
  }

  # Validate volatile-ttl policy
  assert {
    condition     = azurerm_redis_cache.main.redis_configuration[0].maxmemory_policy == "volatile-ttl"
    error_message = "Maxmemory policy should be volatile-ttl for session storage"
  }
}

# Test 9: Validate maximum capacity for Standard SKU
run "validate_max_capacity_standard" {
  command = plan

  variables {
    environment         = "prod"
    region              = "westeurope"
    resource_group_name = "rg-prod"
    redis_cache_name                = "bigcache"
    redis_cache_capacity            = 6
    redis_cache_family              = "C"
    redis_cache_tier                = "Standard"
    redis_cache_enable_non_ssl_port = false
    redis_cache_minimum_tls_version = "1.2"
    redis_cache_maxmemory_reserved  = 500
    redis_cache_maxmemory_delta     = 500
    redis_cache_maxmemory_policy    = "allkeys-lru"
    default_tags = {
      environment = "prod"
    }
  }

  # Validate maximum capacity (6 = 53GB for Standard)
  assert {
    condition     = azurerm_redis_cache.main.capacity == 6
    error_message = "Capacity should be 6 (maximum for Standard SKU)"
  }

  # Validate family for large Standard cache
  assert {
    condition     = azurerm_redis_cache.main.family == "C"
    error_message = "Family should be C for Standard SKU"
  }
}

# Test 10: Validate Premium family capacity
run "validate_premium_max_capacity" {
  command = plan

  variables {
    environment         = "prod"
    region              = "westeurope"
    resource_group_name = "rg-prod"
    redis_cache_name                = "enterprise"
    redis_cache_capacity            = 4
    redis_cache_family              = "P"
    redis_cache_tier                = "Premium"
    redis_cache_enable_non_ssl_port = false
    redis_cache_minimum_tls_version = "1.2"
    redis_cache_maxmemory_reserved  = 1000
    redis_cache_maxmemory_delta     = 1000
    redis_cache_maxmemory_policy    = "allkeys-lru"
    default_tags = {
      environment = "prod"
      tier        = "enterprise"
    }
  }

  # Validate Premium capacity
  assert {
    condition     = azurerm_redis_cache.main.capacity == 4
    error_message = "Capacity should be 4 for Premium SKU"
  }

  # Validate Premium family
  assert {
    condition     = azurerm_redis_cache.main.family == "P"
    error_message = "Family should be P for Premium SKU"
  }
}

# Test 11: Validate multiple tags
run "validate_comprehensive_tagging" {
  command = plan

  variables {
    environment         = "prod"
    region              = "westeurope"
    resource_group_name = "rg-prod"
    redis_cache_name                = "app"
    redis_cache_capacity            = 1
    redis_cache_family              = "C"
    redis_cache_tier                = "Standard"
    redis_cache_enable_non_ssl_port = false
    redis_cache_minimum_tls_version = "1.2"
    redis_cache_maxmemory_reserved  = 50
    redis_cache_maxmemory_delta     = 50
    redis_cache_maxmemory_policy    = "allkeys-lru"
    default_tags = {
      environment  = "prod"
      project      = "webapp"
      cost_center  = "engineering"
      owner        = "platform-team"
      compliance   = "hipaa"
    }
  }

  # Validate all tags are applied
  assert {
    condition     = azurerm_redis_cache.main.tags["environment"] == "prod"
    error_message = "Environment tag should be set"
  }

  assert {
    condition     = azurerm_redis_cache.main.tags["project"] == "webapp"
    error_message = "Project tag should be set"
  }

  assert {
    condition     = azurerm_redis_cache.main.tags["cost_center"] == "engineering"
    error_message = "Cost center tag should be set"
  }

  assert {
    condition     = azurerm_redis_cache.main.tags["owner"] == "platform-team"
    error_message = "Owner tag should be set"
  }

  assert {
    condition     = azurerm_redis_cache.main.tags["compliance"] == "hipaa"
    error_message = "Compliance tag should be set"
  }
}

# Test 12: Validate region variations
run "validate_different_regions" {
  command = plan

  variables {
    environment         = "dev"
    region              = "southeastasia"
    resource_group_name = "rg-apac"
    redis_cache_name                = "api"
    redis_cache_capacity            = 1
    redis_cache_family              = "C"
    redis_cache_tier                = "Standard"
    redis_cache_enable_non_ssl_port = false
    redis_cache_minimum_tls_version = "1.2"
    redis_cache_maxmemory_reserved  = 50
    redis_cache_maxmemory_delta     = 50
    redis_cache_maxmemory_policy    = "allkeys-lru"
    default_tags = {
      environment = "dev"
      region      = "apac"
    }
  }

  # Validate naming includes correct region
  assert {
    condition     = azurerm_redis_cache.main.name == "dev-api-southeastasia-redis"
    error_message = "Redis cache name should include southeastasia region"
  }
}