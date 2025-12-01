#!/bin/bash
# Variable Validation Test Script
# Tests that variable values in examples/main.tf are valid and follow best practices

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
EXAMPLE_FILE="$REPO_ROOT/examples/main.tf"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

TESTS_PASSED=0
TESTS_FAILED=0

# Test result tracking
test_result() {
    local test_name="$1"
    local result="$2"
    local message="$3"
    
    if [ "$result" -eq 0 ]; then
        echo -e "${GREEN}✓${NC} PASS: $test_name"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗${NC} FAIL: $test_name"
        echo -e "  ${YELLOW}$message${NC}"
        ((TESTS_FAILED++))
    fi
}

# Extract variable value from file
get_variable_value() {
    local var_name="$1"
    grep -E "^[[:space:]]*${var_name}[[:space:]]*=" "$EXAMPLE_FILE" | head -1 | sed -E 's/.*=[[:space:]]*"?([^"[:space:]]+)"?.*/\1/' | tr -d '"'
}

echo "=========================================="
echo "Variable Validation Tests"
echo "=========================================="
echo ""

# Test 1: Environment variable has valid value
echo "Running Test 1: Environment variable validation"
environment=$(get_variable_value "environment")
valid_environments=("dev" "test" "staging" "prod" "production" "qa")

if [[ " ${valid_environments[*]} " =~ " ${environment} " ]]; then
    test_result "Environment value is valid" 0 ""
else
    test_result "Environment value is valid" 1 "Environment '$environment' should be one of: ${valid_environments[*]}"
fi

# Test 2: Region is a valid Azure region format
echo "Running Test 2: Region format validation"
region=$(get_variable_value "region")

# Check if region looks like a valid Azure region (no spaces, lowercase)
if [[ "$region" =~ ^[a-z]+$ ]]; then
    test_result "Region format valid" 0 ""
else
    test_result "Region format valid" 1 "Region should be lowercase without spaces (e.g., 'westeurope')"
fi

# Test 3: Resource group name follows naming convention
echo "Running Test 3: Resource group naming convention"
rg_name=$(get_variable_value "resource_group_name")

if [[ "$rg_name" =~ ^rg- ]]; then
    test_result "Resource group naming convention" 0 ""
else
    test_result "Resource group naming convention" 1 "Resource group should start with 'rg-' prefix"
fi

# Test 4: Redis cache name is not too long
echo "Running Test 4: Redis cache name length"
cache_name=$(get_variable_value "redis_cache_name")

if [ ${#cache_name} -le 20 ]; then
    test_result "Redis cache name length acceptable" 0 ""
else
    test_result "Redis cache name length acceptable" 1 "Cache name should be 20 characters or less (current: ${#cache_name})"
fi

# Test 5: Redis cache name contains only valid characters
echo "Running Test 5: Redis cache name characters"
if [[ "$cache_name" =~ ^[a-zA-Z0-9-]+$ ]]; then
    test_result "Redis cache name uses valid characters" 0 ""
else
    test_result "Redis cache name uses valid characters" 1 "Cache name should only contain alphanumeric characters and hyphens"
fi

# Test 6: Capacity is within valid range
echo "Running Test 6: Capacity value validation"
capacity=$(get_variable_value "redis_cache_capacity")
family=$(get_variable_value "redis_cache_family")

if [ "$family" = "C" ]; then
    if [ "$capacity" -ge 0 ] && [ "$capacity" -le 6 ]; then
        test_result "Capacity valid for C family (0-6)" 0 ""
    else
        test_result "Capacity valid for C family (0-6)" 1 "Capacity $capacity is out of range for family C (0-6)"
    fi
elif [ "$family" = "P" ]; then
    if [ "$capacity" -ge 1 ] && [ "$capacity" -le 4 ]; then
        test_result "Capacity valid for P family (1-4)" 0 ""
    else
        test_result "Capacity valid for P family (1-4)" 1 "Capacity $capacity is out of range for family P (1-4)"
    fi
else
    test_result "Valid SKU family" 1 "Family should be C or P, got: $family"
fi

# Test 7: SKU tier matches family
echo "Running Test 7: SKU tier matches family"
tier=$(get_variable_value "redis_cache_tier")

if [ "$family" = "C" ]; then
    if [[ "$tier" = "Basic" || "$tier" = "Standard" ]]; then
        test_result "Tier matches C family" 0 ""
    else
        test_result "Tier matches C family" 1 "C family should use Basic or Standard tier, got: $tier"
    fi
elif [ "$family" = "P" ]; then
    if [ "$tier" = "Premium" ]; then
        test_result "Tier matches P family" 0 ""
    else
        test_result "Tier matches P family" 1 "P family should use Premium tier, got: $tier"
    fi
fi

# Test 8: Non-SSL port is disabled (security best practice)
echo "Running Test 8: Non-SSL port disabled"
non_ssl=$(get_variable_value "redis_cache_enable_non_ssl_port")

if [ "$non_ssl" = "false" ]; then
    test_result "Non-SSL port disabled (secure)" 0 ""
else
    test_result "Non-SSL port disabled (secure)" 1 "Non-SSL port should be disabled for security"
fi

# Test 9: TLS version is 1.2 or higher
echo "Running Test 9: Minimum TLS version"
tls_version=$(get_variable_value "redis_cache_minimum_tls_version")

if [[ "$tls_version" = "1.2" || "$tls_version" = "1.3" ]]; then
    test_result "TLS version is 1.2 or higher" 0 ""
else
    test_result "TLS version is 1.2 or higher" 1 "TLS version should be 1.2 or 1.3, got: $tls_version"
fi

# Test 10: Memory reserved is reasonable
echo "Running Test 10: Memory reserved value"
mem_reserved=$(get_variable_value "redis_cache_maxmemory_reserved")

if [ "$mem_reserved" -ge 2 ] && [ "$mem_reserved" -le 1000 ]; then
    test_result "Memory reserved in reasonable range" 0 ""
else
    test_result "Memory reserved in reasonable range" 1 "Memory reserved should be between 2-1000 MB, got: $mem_reserved"
fi

# Test 11: Memory delta is reasonable
echo "Running Test 11: Memory delta value"
mem_delta=$(get_variable_value "redis_cache_maxmemory_delta")

if [ "$mem_delta" -ge 2 ] && [ "$mem_delta" -le 1000 ]; then
    test_result "Memory delta in reasonable range" 0 ""
else
    test_result "Memory delta in reasonable range" 1 "Memory delta should be between 2-1000 MB, got: $mem_delta"
fi

# Test 12: Memory policy is valid
echo "Running Test 12: Memory eviction policy"
mem_policy=$(get_variable_value "redis_cache_maxmemory_policy")
valid_policies=("volatile-lru" "allkeys-lru" "volatile-lfu" "allkeys-lfu" "volatile-random" "allkeys-random" "volatile-ttl" "noeviction")

if [[ " ${valid_policies[*]} " =~ " ${mem_policy} " ]]; then
    test_result "Valid eviction policy" 0 ""
else
    test_result "Valid eviction policy" 1 "Policy '$mem_policy' is not valid. Valid policies: ${valid_policies[*]}"
fi

# Test 13: Tags are present
echo "Running Test 13: Tags presence"
if grep -q "default_tags" "$EXAMPLE_FILE"; then
    test_result "Tags block present" 0 ""
else
    test_result "Tags block present" 1 "Tags should be specified for resource tracking"
fi

# Test 14: Environment tag matches environment variable
echo "Running Test 14: Environment tag consistency"
if grep -A 5 "default_tags" "$EXAMPLE_FILE" | grep -q "environment.*=.*\"$environment\""; then
    test_result "Environment tag matches variable" 0 ""
else
    test_result "Environment tag matches variable" 1 "Environment tag should match environment variable"
fi

# Test 15: At least 2 tags present
echo "Running Test 15: Minimum tags count"
tags_count=$(grep -A 10 "default_tags" "$EXAMPLE_FILE" | grep -E '^\s+[a-z_]+\s*=' | wc -l)

if [ "$tags_count" -ge 2 ]; then
    test_result "Minimum 2 tags present" 0 ""
else
    test_result "Minimum 2 tags present" 1 "At least 2 tags should be specified (found: $tags_count)"
fi

# Test 16: Memory reserved and delta are equal or close
echo "Running Test 16: Memory reserved and delta relationship"
mem_reserved=$(get_variable_value "redis_cache_maxmemory_reserved")
mem_delta=$(get_variable_value "redis_cache_maxmemory_delta")

# They should typically be equal for Standard/Premium or within 20% of each other
if [ "$mem_reserved" -eq "$mem_delta" ]; then
    test_result "Memory reserved equals delta" 0 ""
else
    # Calculate percentage difference
    diff=$((mem_reserved - mem_delta))
    diff=${diff#-}  # absolute value
    percent=$((diff * 100 / mem_reserved))
    
    if [ "$percent" -le 20 ]; then
        test_result "Memory values within acceptable range" 0 ""
    else
        test_result "Memory values within acceptable range" 1 "Reserved and delta should be equal or within 20% (difference: $percent%)"
    fi
fi

# Test 17: Naming will be unique (checks pattern components)
echo "Running Test 17: Naming uniqueness potential"
# Construct the expected name
expected_name="${environment}-${cache_name}-${region}-redis"

if [ ${#expected_name} -le 63 ]; then
    test_result "Generated name within Azure limits (63 chars)" 0 ""
else
    test_result "Generated name within Azure limits (63 chars)" 1 "Generated name '$expected_name' exceeds 63 characters"
fi

# Test 18: Appropriate tier for use case
echo "Running Test 18: Tier appropriate for environment"
if [ "$environment" = "prod" ] || [ "$environment" = "production" ]; then
    if [[ "$tier" = "Standard" || "$tier" = "Premium" ]]; then
        test_result "Production uses Standard or Premium tier" 0 ""
    else
        test_result "Production uses Standard or Premium tier" 1 "Production should use Standard or Premium tier, not Basic"
    fi
else
    test_result "Non-production tier acceptable" 0 ""
fi

# Summary
echo ""
echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo -e "Tests Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests Failed: ${RED}$TESTS_FAILED${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed.${NC}"
    exit 1
fi