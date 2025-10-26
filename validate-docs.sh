#!/bin/bash

# Documentation Validation Script
# This script verifies that all documentation files exist and are properly linked

echo "=== Documentation Structure Validation ==="
echo ""

# Core documentation files that must exist
REQUIRED_FILES=(
    "README.md"
    "GETTING_STARTED.md"
    "FAQ.md"
    "QUICK_START.md"
    "IMPORT_GUIDE.md"
    "CONTRIBUTING.md"
    "CODE_OF_CONDUCT.md"
    "AGENT_CODE_OF_CONDUCT.md"
    "GOVERNANCE.md"
    "TOOLS.md"
    "CHANGELOG.md"
)

# Function to check if a file links to another
check_link() {
    local source_file=$1
    local target_file=$2
    local description=$3
    
    if grep -q "$target_file" "$source_file"; then
        echo "  ✓ $description"
        return 0
    else
        echo "  ✗ $description"
        return 1
    fi
}

# Check if required files exist
echo "Checking required documentation files..."
VALIDATION_ERRORS=0

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✓ $file"
    else
        echo "  ✗ $file MISSING"
        VALIDATION_ERRORS=$((VALIDATION_ERRORS + 1))
    fi
done

echo ""

# Check for broken internal links (basic check)
echo "Checking for common link patterns..."

# Check README links to key files
check_link "README.md" "GETTING_STARTED.md" "README links to GETTING_STARTED" || VALIDATION_ERRORS=$((VALIDATION_ERRORS + 1))
check_link "README.md" "FAQ.md" "README links to FAQ" || VALIDATION_ERRORS=$((VALIDATION_ERRORS + 1))
check_link "README.md" "QUICK_START.md" "README links to QUICK_START" || VALIDATION_ERRORS=$((VALIDATION_ERRORS + 1))

echo ""

# Summary
if [ $VALIDATION_ERRORS -eq 0 ]; then
    echo "=== All documentation checks passed! ==="
    exit 0
else
    echo "=== Documentation validation failed with $VALIDATION_ERRORS issues ==="
    exit 1
fi
