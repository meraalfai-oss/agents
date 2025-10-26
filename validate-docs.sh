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

# Check if required files exist
echo "Checking required documentation files..."
MISSING_FILES=0

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✓ $file"
    else
        echo "  ✗ $file MISSING"
        MISSING_FILES=$((MISSING_FILES + 1))
    fi
done

echo ""

# Check for broken internal links (basic check)
echo "Checking for common link patterns..."

# Check README links to key files
if grep -q "GETTING_STARTED.md" README.md; then
    echo "  ✓ README links to GETTING_STARTED"
else
    echo "  ✗ README missing link to GETTING_STARTED"
    MISSING_FILES=$((MISSING_FILES + 1))
fi

if grep -q "FAQ.md" README.md; then
    echo "  ✓ README links to FAQ"
else
    echo "  ✗ README missing link to FAQ"
    MISSING_FILES=$((MISSING_FILES + 1))
fi

if grep -q "QUICK_START.md" README.md; then
    echo "  ✓ README links to QUICK_START"
else
    echo "  ✗ README missing link to QUICK_START"
    MISSING_FILES=$((MISSING_FILES + 1))
fi

echo ""

# Summary
if [ $MISSING_FILES -eq 0 ]; then
    echo "=== All documentation checks passed! ==="
    exit 0
else
    echo "=== Documentation validation failed with $MISSING_FILES issues ==="
    exit 1
fi
