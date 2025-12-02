#!/bin/bash
# Terraform Syntax and Format Validation Test Script
# Tests the examples/main.tf file for proper syntax, formatting, and best practices

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
EXAMPLE_DIR="$REPO_ROOT/examples"
EXAMPLE_FILE="$EXAMPLE_DIR/main.tf"

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

echo "=========================================="
echo "Terraform Syntax Validation Tests"
echo "=========================================="
echo ""

# Test 1: Example file exists
echo "Running Test 1: Example file exists"
if [ -f "$EXAMPLE_FILE" ]; then
    test_result "Example file exists" 0 ""
else
    test_result "Example file exists" 1 "File not found at $EXAMPLE_FILE"
    exit 1
fi

# Test 2: File is not empty
echo "Running Test 2: File is not empty"
if [ -s "$EXAMPLE_FILE" ]; then
    test_result "File is not empty" 0 ""
else
    test_result "File is not empty" 1 "Example file is empty"
    exit 1
fi

# Test 3: Valid Terraform syntax
echo "Running Test 3: Valid Terraform syntax"
cd "$EXAMPLE_DIR"
if terraform fmt -check -diff "$EXAMPLE_FILE" > /dev/null 2>&1; then
    test_result "Terraform formatting correct" 0 ""
else
    test_result "Terraform formatting correct" 1 "File needs formatting (run: terraform fmt)"
fi

# Test 4: Module block present
echo "Running Test 4: Module block present"
if grep -q '^module ' "$EXAMPLE_FILE"; then
    test_result "Module block present" 0 ""
else
    test_result "Module block present" 1 "No module block found"
fi

# Test 5: Module source specified
echo "Running Test 5: Module source specified"
if grep -q 'source.*=.*"' "$EXAMPLE_FILE"; then
    test_result "Module source specified" 0 ""
else
    test_result "Module source specified" 1 "Module source not specified"
fi

# Test 6: All required variables present
echo "Running Test 6: Required variables present"
required_vars=("environment" "region" "resource_group_name" "redis_cache_name")
missing_vars=()

for var in "${required_vars[@]}"; do
    if ! grep -q "$var" "$EXAMPLE_FILE"; then
        missing_vars+=("$var")
    fi
done

if [ ${#missing_vars[@]} -eq 0 ]; then
    test_result "All required variables present" 0 ""
else
    test_result "All required variables present" 1 "Missing variables: ${missing_vars[*]}"
fi

# Test 7: No hardcoded secrets
echo "Running Test 7: No hardcoded secrets"
secret_patterns=("password" "secret" "key.*=.*\"[A-Za-z0-9+/=]{20,}\"")
found_secrets=()

for pattern in "${secret_patterns[@]}"; do
    if grep -iE "$pattern" "$EXAMPLE_FILE" > /dev/null 2>&1; then
        found_secrets+=("$pattern")
    fi
done

if [ ${#found_secrets[@]} -eq 0 ]; then
    test_result "No hardcoded secrets" 0 ""
else
    test_result "No hardcoded secrets" 1 "Potential secrets found matching patterns: ${found_secrets[*]}"
fi

# Test 8: Proper indentation
echo "Running Test 8: Proper indentation"
# Check if file uses consistent indentation (2 spaces)
if awk '/^[[:space:]]+[^[:space:]]/ { if (match($0, /^[[:space:]]+/)) { spaces = RLENGTH; if (spaces % 2 != 0) exit 1 } }' "$EXAMPLE_FILE"; then
    test_result "Consistent indentation" 0 ""
else
    test_result "Consistent indentation" 1 "Indentation is not consistent (should use 2 spaces)"
fi

# Test 9: No trailing whitespace
echo "Running Test 9: No trailing whitespace"
if ! grep -E ' +$' "$EXAMPLE_FILE" > /dev/null 2>&1; then
    test_result "No trailing whitespace" 0 ""
else
    test_result "No trailing whitespace" 1 "Trailing whitespace found"
fi

# Test 10: File ends with newline
echo "Running Test 10: File ends with newline"
if [ -n "$(tail -c 1 "$EXAMPLE_FILE")" ]; then
    test_result "File ends with newline" 1 "File should end with a newline"
else
    test_result "File ends with newline" 0 ""
fi

# Test 11: No duplicate variables
echo "Running Test 11: No duplicate variable assignments"
duplicate_vars=$(grep -E '^[[:space:]]+(environment|region|resource_group_name|redis_cache_name|redis_cache_capacity|redis_cache_family|redis_cache_tier)[[:space:]]*=' "$EXAMPLE_FILE" | sort | uniq -d)
if [ -z "$duplicate_vars" ]; then
    test_result "No duplicate variables" 0 ""
else
    test_result "No duplicate variables" 1 "Duplicate variables found: $duplicate_vars"
fi

# Test 12: Boolean values properly formatted
echo "Running Test 12: Boolean values properly formatted"
if grep -E 'redis_cache_enable_non_ssl_port[[:space:]]*=' "$EXAMPLE_FILE" | grep -qE '(true|false)'; then
    test_result "Boolean values properly formatted" 0 ""
else
    if grep -q 'redis_cache_enable_non_ssl_port' "$EXAMPLE_FILE"; then
        test_result "Boolean values properly formatted" 1 "Boolean should be true or false (not string)"
    else
        test_result "Boolean values properly formatted" 0 ""  # Variable not used
    fi
fi

# Test 13: Numeric values not quoted
echo "Running Test 13: Numeric values not quoted"
if grep -E 'redis_cache_capacity[[:space:]]*=[[:space:]]*"[0-9]+"' "$EXAMPLE_FILE" > /dev/null 2>&1; then
    test_result "Numeric values not quoted" 1 "Numeric values should not be quoted"
else
    test_result "Numeric values not quoted" 0 ""
fi

# Test 14: String values properly quoted
echo "Running Test 14: String values properly quoted"
string_vars=("environment" "region" "redis_cache_name" "redis_cache_tier" "redis_cache_family")
unquoted_strings=()

for var in "${string_vars[@]}"; do
    if grep -E "^[[:space:]]+${var}[[:space:]]*=[[:space:]]*[a-zA-Z]" "$EXAMPLE_FILE" > /dev/null 2>&1; then
        unquoted_strings+=("$var")
    fi
done

if [ ${#unquoted_strings[@]} -eq 0 ]; then
    test_result "String values properly quoted" 0 ""
else
    test_result "String values properly quoted" 1 "Unquoted strings found: ${unquoted_strings[*]}"
fi

# Test 15: Tags block properly formatted
echo "Running Test 15: Tags block properly formatted"
if grep -q 'default_tags' "$EXAMPLE_FILE"; then
    if grep -A 3 'default_tags' "$EXAMPLE_FILE" | grep -q '{'; then
        test_result "Tags block properly formatted" 0 ""
    else
        test_result "Tags block properly formatted" 1 "Tags should be a map/object"
    fi
else
    test_result "Tags block present" 1 "No tags block found"
fi

# Test 16: Memory configuration values are numeric
echo "Running Test 16: Memory configuration values are numeric"
memory_vars=("redis_cache_maxmemory_reserved" "redis_cache_maxmemory_delta")
invalid_memory=()

for var in "${memory_vars[@]}"; do
    if grep -q "$var" "$EXAMPLE_FILE"; then
        if ! grep -E "${var}[[:space:]]*=[[:space:]]*[0-9]+" "$EXAMPLE_FILE" > /dev/null 2>&1; then
            invalid_memory+=("$var")
        fi
    fi
done

if [ ${#invalid_memory[@]} -eq 0 ]; then
    test_result "Memory values are numeric" 0 ""
else
    test_result "Memory values are numeric" 1 "Non-numeric memory values: ${invalid_memory[*]}"
fi

# Test 17: Valid eviction policy
echo "Running Test 17: Valid eviction policy"
if grep -q 'redis_cache_maxmemory_policy' "$EXAMPLE_FILE"; then
    policy=$(grep 'redis_cache_maxmemory_policy' "$EXAMPLE_FILE" | grep -oE '"[a-z-]+"' | tr -d '"')
    valid_policies=("volatile-lru" "allkeys-lru" "volatile-lfu" "allkeys-lfu" "volatile-random" "allkeys-random" "volatile-ttl" "noeviction")
    
    if [[ " ${valid_policies[*]} " =~ " ${policy} " ]]; then
        test_result "Valid eviction policy" 0 ""
    else
        test_result "Valid eviction policy" 1 "Invalid policy: $policy"
    fi
else
    test_result "Eviction policy specified" 1 "No eviction policy found"
fi

# Test 18: TLS version is secure
echo "Running Test 18: Secure TLS version"
if grep -q 'redis_cache_minimum_tls_version' "$EXAMPLE_FILE"; then
    if grep -E 'redis_cache_minimum_tls_version[[:space:]]*=[[:space:]]*"1\.[2-3]"' "$EXAMPLE_FILE" > /dev/null 2>&1; then
        test_result "Secure TLS version (1.2 or 1.3)" 0 ""
    else
        test_result "Secure TLS version (1.2 or 1.3)" 1 "TLS version should be 1.2 or higher"
    fi
else
    test_result "TLS version specified" 1 "No TLS version specified"
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