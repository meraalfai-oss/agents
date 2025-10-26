# agents

This repository contains agent configurations and production-ready code.

## 🚀 Quick Start

**Need to import now?** See [QUICK_START.md](QUICK_START.md) for the fastest method.

**Need help?** See [IMPORT_GUIDE.md](IMPORT_GUIDE.md) for detailed instructions and troubleshooting.

## 📋 Governance and Guidelines

This repository operates under a comprehensive governance framework:

- **[Code of Conduct](CODE_OF_CONDUCT.md)** - Community standards and behavior expectations
- **[Agent Code of Conduct](AGENT_CODE_OF_CONDUCT.md)** - Principles for automated agent operations
- **[Governance](GOVERNANCE.md)** - Repository governance structure and policies
- **[Tools Documentation](TOOLS.md)** - Comprehensive guide to all repository tools
- **[Agent Guidelines](.github/agents/agent-guidelines.md)** - Detailed operational procedures for agents
- **[Handling Unclear Goals](HANDLING_UNCLEAR_GOALS.md)** - Guide for agents when user goals are unclear

All contributors and automated agents must adhere to these guidelines to ensure quality, security, and accountability.

## Importing Production-Ready Folder

To import the production-ready folder from the ymera_y repository, follow these steps:

### Prerequisites

1. You need a GitHub Personal Access Token (PAT) with `repo` scope
2. The token must have access to the private repository `ymera-mfm/ymera_y`

### Creating a GitHub Token

1. Go to [GitHub Settings > Personal Access Tokens](https://github.com/settings/tokens)
2. Click "Generate new token" (classic)
3. Give it a descriptive name (e.g., "Import ymera_y production-ready")
4. Select the `repo` scope (full control of private repositories)
5. Click "Generate token"
6. **Copy the token immediately** (you won't be able to see it again)

### Running the Import

#### Method 1: With Token as Argument

```bash
./import.sh YOUR_GITHUB_TOKEN
```

#### Method 2: With Environment Variable

```bash
export GITHUB_TOKEN=YOUR_GITHUB_TOKEN
./import.sh
```

### What the Script Does

1. Validates that a GitHub token is provided
2. Clones the source repository (`ymera-mfm/ymera_y`) from branch `copilot/extract-production-ready-folder`
3. Extracts the production-ready content
4. Copies it to the `production-ready/` directory in this repository
5. Provides instructions for committing the changes

### Troubleshooting

If the import fails, use the diagnostic script:

```bash
./diagnose.sh YOUR_GITHUB_TOKEN
```

This will check:

- **Token Permissions**: Ensure your token has the `repo` scope
- **Repository Access**: Verify you have access to `ymera-mfm/ymera_y`
- **Branch Exists**: Confirm the branch `copilot/extract-production-ready-folder` exists
- **Token Expiration**: Check if your token has expired
- **Network Connectivity**: Verify GitHub is reachable
- **Authentication**: Test if the token works

### After Import

Once the import is complete:

```bash
# Review the imported files
ls -la production-ready/

# Stage the changes
git add production-ready/

# Commit the changes
git commit -m "Import production-ready folder from ymera_y"

# Push to your branch
git push
```

## Alternative: Manual Import

If the script doesn't work, you can manually import:

```bash
# Clone the source repository
git clone --depth 1 --branch copilot/extract-production-ready-folder \
  https://oauth2:YOUR_TOKEN@github.com/ymera-mfm/ymera_y.git /tmp/ymera_source

# Copy the content
mkdir -p production-ready
cp -r /tmp/ymera_source/production-ready/* ./production-ready/ || \
  cp -r /tmp/ymera_source/* ./production-ready/

# Remove .git directory if copied
rm -rf production-ready/.git

# Clean up
rm -rf /tmp/ymera_source

# Commit changes
git add production-ready/
git commit -m "Import production-ready folder from ymera_y"
git push
```