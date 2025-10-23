#!/bin/bash

# Import script for production-ready folder from ymera_y repository
# This script imports content from a private GitHub repository using authentication

set -e

# Configuration
SOURCE_REPO="https://github.com/ymera-mfm/ymera_y.git"
SOURCE_BRANCH="copilot/extract-production-ready-folder"
TARGET_DIR="production-ready"
TEMP_DIR="/tmp/import_temp_$$"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_message() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

# Function to cleanup on exit
cleanup() {
    if [ -d "$TEMP_DIR" ]; then
        print_message "$YELLOW" "Cleaning up temporary directory..."
        rm -rf "$TEMP_DIR"
    fi
}

trap cleanup EXIT

# Check if GitHub token is provided
if [ -z "$GITHUB_TOKEN" ] && [ -z "$1" ]; then
    print_message "$RED" "Error: GitHub token not provided."
    echo ""
    echo "Usage: $0 [GITHUB_TOKEN]"
    echo ""
    echo "Or set the GITHUB_TOKEN environment variable:"
    echo "  export GITHUB_TOKEN=your_token_here"
    echo "  $0"
    echo ""
    echo "To create a GitHub token:"
    echo "  1. Go to https://github.com/settings/tokens"
    echo "  2. Generate a new token with 'repo' scope"
    echo "  3. Copy the token and use it with this script"
    exit 1
fi

# Use token from argument or environment
TOKEN="${1:-$GITHUB_TOKEN}"

print_message "$GREEN" "Starting import process..."
print_message "$YELLOW" "Source: $SOURCE_REPO (branch: $SOURCE_BRANCH)"
print_message "$YELLOW" "Target: $TARGET_DIR/"

# Create temporary directory
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Clone the repository with authentication
print_message "$YELLOW" "Cloning source repository..."
# Temporarily disable exit on error for the clone command
set +e
CLONE_OUTPUT=$(git clone --depth 1 --branch "$SOURCE_BRANCH" "https://oauth2:${TOKEN}@github.com/ymera-mfm/ymera_y.git" source_repo 2>&1)
CLONE_EXIT=$?
set -e

# Display output without token
echo "$CLONE_OUTPUT" | grep -v "oauth2"

if [ $CLONE_EXIT -eq 0 ] && [ -d "source_repo/.git" ]; then
    print_message "$GREEN" "✓ Repository cloned successfully"
else
    print_message "$RED" "✗ Failed to clone repository"
    if echo "$CLONE_OUTPUT" | grep -q "Invalid username or token"; then
        print_message "$RED" "  - Token is invalid or has been revoked"
        print_message "$RED" "  - If you posted the token publicly, GitHub automatically revoked it"
        print_message "$RED" "  - Generate a new token at https://github.com/settings/tokens"
    fi
    print_message "$RED" "Please check:"
    print_message "$RED" "  - The token has 'repo' scope"
    print_message "$RED" "  - You have access to the repository"
    print_message "$RED" "  - The branch '$SOURCE_BRANCH' exists"
    exit 1
fi

# Go back to the original repository
cd "$OLDPWD"

# Create target directory if it doesn't exist
if [ -d "$TARGET_DIR" ]; then
    print_message "$YELLOW" "Warning: Target directory '$TARGET_DIR' already exists"
    read -p "Do you want to overwrite it? (yes/no): " confirm
    if [ "$confirm" != "yes" ]; then
        print_message "$RED" "Import cancelled"
        exit 1
    fi
    rm -rf "$TARGET_DIR"
fi

# Copy the contents
print_message "$YELLOW" "Copying files..."
mkdir -p "$TARGET_DIR"

# Check if there's a specific production-ready folder in the source
if [ -d "$TEMP_DIR/source_repo/production-ready" ]; then
    cp -r "$TEMP_DIR/source_repo/production-ready/"* "$TARGET_DIR/"
    print_message "$GREEN" "✓ Copied from production-ready folder"
elif [ -d "$TEMP_DIR/source_repo" ]; then
    # Copy everything except .git directory
    cp -r "$TEMP_DIR/source_repo/"* "$TARGET_DIR/" 2>/dev/null || true
    cp -r "$TEMP_DIR/source_repo/".??* "$TARGET_DIR/" 2>/dev/null || true
    rm -rf "$TARGET_DIR/.git"
    print_message "$GREEN" "✓ Copied entire repository content"
fi

# Summary
print_message "$GREEN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_message "$GREEN" "Import completed successfully!"
print_message "$GREEN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
print_message "$YELLOW" "Imported files:"
ls -la "$TARGET_DIR"
echo ""
print_message "$YELLOW" "Next steps:"
echo "  1. Review the imported files in '$TARGET_DIR'"
echo "  2. Stage changes: git add $TARGET_DIR"
echo "  3. Commit changes: git commit -m 'Import production-ready folder'"
echo "  4. Push changes: git push"
