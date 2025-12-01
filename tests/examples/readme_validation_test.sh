#!/bin/bash
# README Validation Test Script
# Tests the examples/README.md file for correctness, consistency, and best practices

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
README_PATH="$REPO_ROOT/examples/README.md"

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
echo "README Validation Tests"
echo "=========================================="
echo ""

# Test 1: README file exists
echo "Running Test 1: README file exists"
if [ -f "$README_PATH" ]; then
    test_result "README file exists" 0 ""
else
    test_result "README file exists" 1 "File not found at $README_PATH"
    exit 1
fi

# Test 2: README is not empty
echo "Running Test 2: README is not empty"
if [ -s "$README_PATH" ]; then
    test_result "README is not empty" 0 ""
else
    test_result "README is not empty" 1 "README file is empty"
fi

# Test 3: README contains required sections
echo "Running Test 3: Required sections present"
required_sections=("# Terraform Azure Redis Cache Module" "## Description" "## Features" "## Typical Use Cases" "## Notes")
missing_sections=()

for section in "${required_sections[@]}"; do
    if ! grep -q "$section" "$README_PATH"; then
        missing_sections+=("$section")
    fi
done

if [ ${#missing_sections[@]} -eq 0 ]; then
    test_result "All required sections present" 0 ""
else
    test_result "All required sections present" 1 "Missing sections: ${missing_sections[*]}"
fi

# Test 4: Code block syntax is correct
echo "Running Test 4: Code block syntax validation"
if grep -q '```' "$README_PATH"; then
    # Count opening and closing code blocks
    opening_blocks=$(grep -c '^```' "$README_PATH" || true)
    if [ $((opening_blocks % 2)) -eq 0 ]; then
        test_result "Code block syntax correct" 0 ""
    else
        test_result "Code block syntax correct" 1 "Unmatched code block delimiters (found $opening_blocks)"
    fi
else
    test_result "Code block syntax correct" 1 "No code blocks found in README"
fi

# Test 5: Example code contains module source reference
echo "Running Test 5: Module source reference present"
if grep -q 'source = "./terraform-azure-cache-for-redis"' "$README_PATH"; then
    test_result "Module source reference present" 0 ""
else
    test_result "Module source reference present" 1 "Module source reference not found or incorrect"
fi

# Test 6: Example contains all required variables
echo "Running Test 6: Required variables in example"
required_vars=("environment" "region" "resource_group_name" "redis_cache_name" "redis_cache_capacity" "redis_cache_family" "redis_cache_tier")
missing_vars=()

for var in "${required_vars[@]}"; do
    if ! grep -q "$var" "$README_PATH"; then
        missing_vars+=("$var")
    fi
done

if [ ${#missing_vars[@]} -eq 0 ]; then
    test_result "All required variables in example" 0 ""
else
    test_result "All required variables in example" 1 "Missing variables: ${missing_vars[*]}"
fi

# Test 7: Security best practices mentioned
echo "Running Test 7: Security best practices documented"
security_items=("TLS" "non-SSL" "non_ssl_port")
found_security=false

for item in "${security_items[@]}"; do
    if grep -qi "$item" "$README_PATH"; then
        found_security=true
        break
    fi
done

if [ "$found_security" = true ]; then
    test_result "Security best practices mentioned" 0 ""
else
    test_result "Security best practices mentioned" 1 "No security-related content found"
fi

# Test 8: SKU options documented
echo "Running Test 8: SKU options documented"
if grep -q "Basic" "$README_PATH" && grep -q "Standard" "$README_PATH" && grep -q "Premium" "$README_PATH"; then
    test_result "All SKU options documented" 0 ""
else
    test_result "All SKU options documented" 1 "Not all SKU types (Basic, Standard, Premium) are mentioned"
fi

# Test 9: Naming convention explained
echo "Running Test 9: Naming convention explained"
if grep -q "environment.*redis_cache_name.*region.*redis" "$README_PATH" || grep -q "<environment>-<redis_cache_name>-<region>-redis" "$README_PATH"; then
    test_result "Naming convention explained" 0 ""
else
    test_result "Naming convention explained" 1 "Naming convention pattern not clearly documented"
fi

# Test 10: Resource group requirement mentioned
echo "Running Test 10: Prerequisites documented"
if grep -qi "resource group" "$README_PATH"; then
    test_result "Prerequisites documented" 0 ""
else
    test_result "Prerequisites documented" 1 "Resource group requirement not mentioned"
fi

# Test 11: No broken internal references
echo "Running Test 11: Internal consistency check"
# Check if example in README matches values that make sense
inconsistencies=()

# Check if capacity matches family (C family should have 0-6, P family should have 1-4)
if grep -q 'redis_cache_family.*=.*"C"' "$README_PATH"; then
    capacity=$(grep -o 'redis_cache_capacity.*=.*[0-9]' "$README_PATH" | grep -o '[0-9]' | head -1)
    if [ -n "$capacity" ] && [ "$capacity" -ge 0 ] && [ "$capacity" -le 6 ]; then
        test_result "Capacity matches family constraints" 0 ""
    else
        test_result "Capacity matches family constraints" 1 "Capacity $capacity invalid for C family (should be 0-6)"
    fi
else
    test_result "Capacity matches family constraints" 0 ""  # Skip if not C family
fi

# Test 12: Markdown formatting check
echo "Running Test 12: Markdown formatting"
# Check for common markdown issues
formatting_issues=()

# Check for proper heading hierarchy (no skipped levels)
if grep -E '^####' "$README_PATH" | head -1 | grep -q '^####'; then
    if ! grep -q '^###' "$README_PATH"; then
        formatting_issues+=("Heading hierarchy skip (#### without ###)")
    fi
fi

# Check for trailing spaces (common markdown issue)
if grep -E ' +$' "$README_PATH" > /dev/null 2>&1; then
    formatting_issues+=("Trailing spaces found")
fi

if [ ${#formatting_issues[@]} -eq 0 ]; then
    test_result "Markdown formatting check" 0 ""
else
    test_result "Markdown formatting check" 1 "Issues: ${formatting_issues[*]}"
fi

# Test 13: Configuration values are realistic
echo "Running Test 13: Realistic configuration values"
unrealistic_values=()

# Check memory values are reasonable
if grep -q 'redis_cache_maxmemory_reserved.*=.*50' "$README_PATH"; then
    test_result "Memory configuration realistic" 0 ""
else
    # Just check if some memory config exists
    if grep -q 'redis_cache_maxmemory_reserved' "$README_PATH"; then
        test_result "Memory configuration present" 0 ""
    else
        test_result "Memory configuration present" 1 "No memory configuration found"
    fi
fi

# Test 14: Verify TLS version is secure
echo "Running Test 14: Secure TLS version recommended"
if grep -q 'redis_cache_minimum_tls_version.*=.*"1.2"' "$README_PATH" || grep -q 'redis_cache_minimum_tls_version.*=.*"1.3"' "$README_PATH"; then
    test_result "Secure TLS version recommended" 0 ""
else
    test_result "Secure TLS version recommended" 1 "TLS version should be 1.2 or higher"
fi

# Test 15: Tags example provided
echo "Running Test 15: Tagging example included"
if grep -q 'default_tags' "$README_PATH"; then
    test_result "Tagging example included" 0 ""
else
    test_result "Tagging example included" 1 "No tagging example found"
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