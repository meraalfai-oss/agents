#!/bin/bash

# Diagnostic script for import issues
# This script helps diagnose problems with the import process

# Note: Not using set -e because we expect some commands to fail during diagnostics

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_check() {
    local status=$1
    local message=$2
    if [ "$status" = "ok" ]; then
        echo -e "${GREEN}✓${NC} $message"
    elif [ "$status" = "warn" ]; then
        echo -e "${YELLOW}⚠${NC} $message"
    else
        echo -e "${RED}✗${NC} $message"
    fi
}

print_header "Import Diagnostics"

# Check 1: Token provided
print_header "1. Checking Token"
if [ -z "$1" ] && [ -z "$GITHUB_TOKEN" ]; then
    print_check "fail" "No GitHub token provided"
    echo "  Usage: $0 [TOKEN]"
    echo "  Or set: export GITHUB_TOKEN=your_token"
    exit 1
else
    TOKEN="${1:-$GITHUB_TOKEN}"
    TOKEN_LENGTH=${#TOKEN}
    print_check "ok" "Token provided (length: $TOKEN_LENGTH)"
    
    # Check token format
    if [[ $TOKEN == ghp_* ]] || [[ $TOKEN == github_pat_* ]]; then
        print_check "ok" "Token format looks correct"
    else
        print_check "warn" "Token format may be incorrect (should start with 'ghp_' or 'github_pat_')"
    fi
fi

# Check 2: Network connectivity
print_header "2. Checking Network Connectivity"
if ping -c 1 -W 2 github.com &>/dev/null; then
    print_check "ok" "Can reach github.com"
else
    print_check "warn" "Cannot ping github.com (may be normal)"
fi

if curl -s --connect-timeout 5 https://api.github.com/zen &>/dev/null; then
    print_check "ok" "Can connect to GitHub API"
else
    print_check "fail" "Cannot connect to GitHub API"
fi

# Check 3: Test token authentication
print_header "3. Testing Token Authentication"
TEMP_DIR="/tmp/diagnose_$$"
mkdir -p "$TEMP_DIR"

# Test with a public repository first
echo "Testing authentication with a public repository..."
if git clone --depth 1 "https://oauth2:${TOKEN}@github.com/octocat/Hello-World.git" "$TEMP_DIR/test_public" &>/dev/null; then
    print_check "ok" "Can authenticate with GitHub"
    rm -rf "$TEMP_DIR/test_public"
else
    print_check "fail" "Cannot authenticate with GitHub"
    echo "  This suggests the token may be invalid or expired"
fi

# Check 4: Test access to source repository
print_header "4. Testing Access to Source Repository"
SOURCE_REPO="ymera-mfm/ymera_y"
SOURCE_BRANCH="copilot/extract-production-ready-folder"

echo "Testing access to $SOURCE_REPO..."
CLONE_OUTPUT=$(git clone --depth 1 --branch "$SOURCE_BRANCH" "https://oauth2:${TOKEN}@github.com/$SOURCE_REPO.git" "$TEMP_DIR/test_source" 2>&1)
CLONE_EXIT=$?

if [ $CLONE_EXIT -eq 0 ] && [ -d "$TEMP_DIR/test_source/.git" ]; then
    print_check "ok" "Can access $SOURCE_REPO"
    print_check "ok" "Branch '$SOURCE_BRANCH' exists"
    
    # Check content
    if [ -d "$TEMP_DIR/test_source" ]; then
        FILE_COUNT=$(find "$TEMP_DIR/test_source" -type f ! -path '*/.git/*' | wc -l)
        print_check "ok" "Repository contains $FILE_COUNT files"
        
        if [ -d "$TEMP_DIR/test_source/production-ready" ]; then
            print_check "ok" "Found 'production-ready' folder in source"
        else
            print_check "warn" "No 'production-ready' folder found (will import entire repo)"
        fi
    fi
    
    rm -rf "$TEMP_DIR/test_source"
else
    if echo "$CLONE_OUTPUT" | grep -q "Invalid username or token"; then
        print_check "fail" "Token is invalid or has been revoked"
        echo "  Possible reasons:"
        echo "  - Token doesn't have 'repo' scope"
        echo "  - Token has been revoked (e.g., if posted publicly)"
        echo "  - Generate a new token at https://github.com/settings/tokens"
    elif echo "$CLONE_OUTPUT" | grep -q "404"; then
        print_check "fail" "Repository not found or no access"
        echo "  Possible reasons:"
        echo "  - Repository is private and token lacks access"
        echo "  - Token doesn't have 'repo' scope"
        echo "  - You're not a collaborator on the repository"
    elif echo "$CLONE_OUTPUT" | grep -q "branch"; then
        print_check "fail" "Branch '$SOURCE_BRANCH' not found"
        echo "  Available branches may be different"
    else
        print_check "fail" "Unknown error accessing repository"
        echo "  Error: $(echo "$CLONE_OUTPUT" | grep -v "oauth2" | head -3)"
    fi
fi

# Check 5: Git configuration
print_header "5. Checking Git Configuration"
if git config user.name &>/dev/null; then
    print_check "ok" "Git user.name is configured: $(git config user.name)"
else
    print_check "warn" "Git user.name not configured"
fi

if git config user.email &>/dev/null; then
    print_check "ok" "Git user.email is configured: $(git config user.email)"
else
    print_check "warn" "Git user.email not configured"
fi

# Check 6: Local repository status
print_header "6. Checking Local Repository"
if [ -d ".git" ]; then
    print_check "ok" "In a git repository"
    
    BRANCH=$(git branch --show-current)
    print_check "ok" "Current branch: $BRANCH"
    
    if [ -d "production-ready" ]; then
        print_check "warn" "production-ready folder already exists"
        EXISTING_FILES=$(find production-ready -type f | wc -l)
        echo "  Contains $EXISTING_FILES files"
    else
        print_check "ok" "production-ready folder doesn't exist (ready for import)"
    fi
else
    print_check "fail" "Not in a git repository"
fi

# Cleanup
rm -rf "$TEMP_DIR"

# Summary
print_header "Summary"
echo ""
echo "If all checks passed, you can run the import:"
echo "  ${GREEN}./import.sh${NC} $TOKEN"
echo ""
echo "If there were failures:"
echo "  1. Check token has 'repo' scope"
echo "  2. Verify access to ymera-mfm/ymera_y"
echo "  3. Ensure branch name is correct"
echo "  4. See IMPORT_GUIDE.md for more help"
echo ""
