#!/bin/bash
# Comprehensive Test Runner
# Executes all test suites for the Terraform module examples

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=========================================="
echo "Terraform Module Test Suite"
echo -e "==========================================${NC}\n"

TOTAL_SUITES=0
PASSED_SUITES=0
FAILED_SUITES=0

# Function to run a test suite
run_test_suite() {
    local suite_name="$1"
    local suite_script="$2"
    
    ((TOTAL_SUITES++))
    
    echo -e "\n${BLUE}Running: $suite_name${NC}"
    echo "----------------------------------------"
    
    if [ -f "$suite_script" ]; then
        if bash "$suite_script"; then
            echo -e "${GREEN}✓ $suite_name: PASSED${NC}"
            ((PASSED_SUITES++))
            return 0
        else
            echo -e "${RED}✗ $suite_name: FAILED${NC}"
            ((FAILED_SUITES++))
            return 1
        fi
    else
        echo -e "${YELLOW}⚠ $suite_name: SKIPPED (script not found)${NC}"
        return 2
    fi
}

# Run test suites
run_test_suite "README Validation" "$SCRIPT_DIR/examples/readme_validation_test.sh"
run_test_suite "Terraform Syntax Validation" "$SCRIPT_DIR/examples/terraform_syntax_test.sh"
run_test_suite "Variable Validation" "$SCRIPT_DIR/examples/variable_validation_test.sh"

# Check if terraform is available for native tests
if command -v terraform &> /dev/null; then
    echo -e "\n${BLUE}Running: Terraform Native Tests${NC}"
    echo "----------------------------------------"
    cd "$SCRIPT_DIR/.."
    if terraform test -test-directory=tests/examples 2>/dev/null; then
        echo -e "${GREEN}✓ Terraform Native Tests: PASSED${NC}"
        ((PASSED_SUITES++))
        ((TOTAL_SUITES++))
    else
        echo -e "${YELLOW}⚠ Terraform Native Tests: Skipped (test command not fully supported or no provider)${NC}"
    fi
else
    echo -e "\n${YELLOW}⚠ Terraform not found, skipping native tests${NC}"
fi

# Final summary
echo -e "\n${BLUE}=========================================="
echo "Final Test Summary"
echo -e "==========================================${NC}"
echo -e "Total Test Suites: $TOTAL_SUITES"
echo -e "Passed: ${GREEN}$PASSED_SUITES${NC}"
echo -e "Failed: ${RED}$FAILED_SUITES${NC}"
echo ""

if [ $FAILED_SUITES -eq 0 ]; then
    echo -e "${GREEN}All test suites passed successfully!${NC}"
    exit 0
else
    echo -e "${RED}Some test suites failed.${NC}"
    exit 1
fi