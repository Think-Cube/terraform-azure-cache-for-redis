# Test Suite for Terraform Azure Redis Cache Module

This directory contains comprehensive tests for the example configurations in the `examples/` directory.

## Test Structure

### 1. Terraform Native Tests (`examples/example_validation.tftest.hcl`)

Uses Terraform's built-in testing framework (available in Terraform 1.6.0+) to validate:
- Module configuration with different SKU tiers (Basic, Standard, Premium)
- Naming conventions and resource naming patterns
- Memory configuration settings
- TLS version enforcement
- Tag application and consistency
- Capacity constraints for different SKU families
- Eviction policy configurations
- Region variations
- Security settings (non-SSL port, TLS versions)

**Run with:**
```bash
terraform test -test-directory=tests/examples
```

### 2. README Validation Tests (`examples/readme_validation_test.sh`)

Validates the `examples/README.md` file for:
- File existence and non-empty content
- Required sections (Description, Features, Use Cases, Notes)
- Code block syntax correctness
- Module source reference accuracy
- Required variables documentation
- Security best practices mention
- SKU options documentation
- Naming convention explanation
- Prerequisites documentation
- Internal consistency
- Markdown formatting
- Realistic configuration values
- Secure TLS recommendations
- Tagging examples

**Run with:**
```bash
./tests/examples/readme_validation_test.sh
```

### 3. Terraform Syntax Tests (`examples/terraform_syntax_test.sh`)

Validates the `examples/main.tf` file for:
- File existence and content
- Terraform formatting compliance
- Module block presence and correctness
- Required variables presence
- Absence of hardcoded secrets
- Proper indentation (2 spaces)
- No trailing whitespace
- Newline at end of file
- No duplicate variable assignments
- Proper boolean formatting
- Correct numeric value formatting
- String value quoting
- Tags block formatting
- Memory configuration value types
- Valid eviction policies
- Secure TLS versions

**Run with:**
```bash
./tests/examples/terraform_syntax_test.sh
```

### 4. Variable Validation Tests (`examples/variable_validation_test.sh`)

Validates variable values in `examples/main.tf` for:
- Valid environment values (dev, test, staging, prod)
- Azure region format validation
- Resource group naming conventions
- Redis cache name length and character constraints
- Capacity ranges for SKU families (C: 0-6, P: 1-4)
- SKU tier and family compatibility
- Security settings (non-SSL port disabled, TLS 1.2+)
- Memory configuration reasonableness
- Valid eviction policies
- Tag presence and consistency
- Minimum tag count (at least 2)
- Memory reserved/delta relationship
- Generated name length within Azure limits
- Appropriate tier for environment

**Run with:**
```bash
./tests/examples/variable_validation_test.sh
```

## Running All Tests

Execute all test suites at once:

```bash
./tests/run_all_tests.sh
```

This runner script will:
1. Execute all shell-based validation tests
2. Run Terraform native tests (if Terraform is available)
3. Provide a comprehensive summary of all test results

## Test Coverage

These tests provide comprehensive coverage for:

- **Configuration Validation**: Ensures example configurations are syntactically correct
- **Best Practices**: Enforces security and operational best practices
- **Documentation Quality**: Validates that documentation is complete and accurate
- **Variable Constraints**: Checks that variable values are within valid ranges
- **Naming Conventions**: Validates resource naming patterns
- **Security Posture**: Ensures secure defaults (TLS 1.2+, non-SSL ports disabled)
- **SKU Compatibility**: Validates tier/family/capacity combinations
- **Tag Management**: Ensures proper tagging for resource management

## Requirements

- **Terraform**: Version 1.6.3 or higher (for native tests)
- **Bash**: Version 4.0 or higher
- **Common Unix tools**: grep, awk, sed, find

## CI/CD Integration

These tests can be integrated into your CI/CD pipeline:

```yaml
# Example Azure Pipelines integration
- script: |
    cd tests
    ./run_all_tests.sh
  displayName: 'Run Example Tests'
```

## Adding New Tests

When adding new tests:

1. **For Terraform native tests**: Add new `run` blocks to `example_validation.tftest.hcl`
2. **For validation tests**: Add test functions to the appropriate shell script
3. **Update this README**: Document the new test coverage

## Test Philosophy

These tests follow a "bias for action" approach:
- Comprehensive coverage of happy paths, edge cases, and failure conditions
- Validation of security best practices
- Enforcement of naming conventions and organizational standards
- Documentation quality assurance
- Configuration correctness validation

## Troubleshooting

If tests fail:

1. **Check the error message**: Tests provide specific details about failures
2. **Review the file**: Use the line numbers provided in error messages
3. **Run individual test suites**: Isolate the failing test for easier debugging
4. **Validate Terraform installation**: Ensure Terraform version is 1.6.3+

## License

These tests are part of the terraform-azure-cache-for-redis module and follow the same license.