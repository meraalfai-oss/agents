# Repository Tools Documentation

## Overview

This document provides a comprehensive guide to all tools available in this repository, their purpose, configuration, and usage guidelines.

## Tool Categories

### 1. Version Control Tools

#### Git
**Purpose**: Distributed version control system
**Status**: ✅ Active and Required
**Configuration**: `.gitignore`

**Usage**:
```bash
# Common operations
git status              # Check repository status
git add <files>         # Stage changes
git commit -m "msg"     # Commit changes
git push               # Push to remote
git pull               # Pull from remote
```

**Guidelines**:
- Use meaningful commit messages
- Commit frequently with logical changes
- Always pull before starting new work
- Use branches for features

#### GitHub CLI (gh)
**Purpose**: Command-line interface for GitHub
**Status**: ✅ Active and Recommended
**Configuration**: GitHub authentication

**Usage**:
```bash
# PR operations
gh pr create           # Create pull request
gh pr list            # List pull requests
gh pr view <number>   # View PR details

# Issue operations
gh issue create       # Create issue
gh issue list         # List issues
```

### 2. Import and Deployment Tools

#### import.sh
**Purpose**: Import production-ready content from ymera_y repository
**Status**: ✅ Active - Project Specific
**Location**: `/import.sh`
**Permissions**: Executable

**Usage**:
```bash
# Method 1: With token as argument
./import.sh YOUR_GITHUB_TOKEN

# Method 2: With environment variable
export GITHUB_TOKEN=YOUR_GITHUB_TOKEN
./import.sh
```

**Configuration**:
```bash
SOURCE_REPO="https://github.com/ymera-mfm/ymera_y.git"
SOURCE_BRANCH="copilot/extract-production-ready-folder"
TARGET_DIR="production-ready"
```

**Features**:
- Validates GitHub token
- Clones source repository
- Extracts production-ready content
- Provides clear error messages
- Automatic cleanup

**When to Use**:
- Initial repository setup
- Importing updates from source repository
- Syncing production-ready content

#### diagnose.sh
**Purpose**: Diagnostic tool for import issues
**Status**: ✅ Active - Project Specific
**Location**: `/diagnose.sh`
**Permissions**: Executable

**Usage**:
```bash
./diagnose.sh YOUR_GITHUB_TOKEN
```

**Checks Performed**:
1. Token format validation
2. Token permissions verification
3. Network connectivity to GitHub
4. Repository access validation
5. Branch existence confirmation
6. Authentication status

**When to Use**:
- Import script fails
- Authentication issues
- Troubleshooting access problems
- Verifying token setup

#### validate-docs.sh
**Purpose**: Documentation structure validation tool
**Status**: ✅ Active - Project Specific
**Location**: `/validate-docs.sh`
**Permissions**: Executable

**Usage**:
```bash
./validate-docs.sh
```

**Checks Performed**:
1. Verifies all required documentation files exist
2. Validates key links between documentation files
3. Ensures README links to main entry points (FAQ, Getting Started, Quick Start)
4. Reports any missing files or broken link patterns

**When to Use**:
- After adding or updating documentation
- Before committing documentation changes
- As part of documentation review process
- To ensure documentation completeness

**Exit Codes**:
- `0`: All checks passed
- `1`: One or more validation issues found

### 3. CI/CD and Automation Tools

#### GitHub Actions
**Purpose**: Automated workflows and CI/CD
**Status**: ✅ Active and Required
**Configuration**: `.github/workflows/`

**Active Workflows**:

##### import-production-ready.yml
**Purpose**: Automated import of production-ready content
**Trigger**: Manual workflow dispatch
**Configuration**:
```yaml
inputs:
  source_branch:
    default: 'copilot/extract-production-ready-folder'
  target_directory:
    default: 'production-ready'
```

**Secrets Required**:
- `YMERA_IMPORT_TOKEN`: GitHub PAT with repo scope

**Features**:
- Automatic cloning of source repository
- Secure token handling
- Automatic commit and push
- Detailed logging and summary

**When to Use**:
- Scheduled imports
- Automated updates
- CI/CD integration

##### agent-compliance.yml
**Purpose**: Verify agent compliance with code of conduct
**Trigger**: PR events, push to main/develop
**Status**: ✅ Active and Required

**Checks Performed**:
1. Code of conduct file existence
2. Secret scanning in changes
3. Change scope validation
4. Documentation updates
5. .gitignore protection
6. Test file presence

**Output**: Compliance summary in workflow summary

### 4. Quality Assurance Tools

#### Linters
**Purpose**: Code quality and style enforcement
**Status**: ⚠️ To Be Configured
**Recommendation**: Configure based on project languages

**Suggested Linters**:

**For Python**:
```bash
# Install
pip install pylint flake8 black

# Configuration files
# .pylintrc
# .flake8
# pyproject.toml (for black)

# Usage
pylint **/*.py
flake8 .
black --check .
```

**For JavaScript/TypeScript**:
```bash
# Install
npm install --save-dev eslint prettier

# Configuration files
# .eslintrc.json
# .prettierrc

# Usage
npx eslint .
npx prettier --check .
```

#### Code Formatters
**Purpose**: Automatic code formatting
**Status**: ⚠️ To Be Configured

**Recommendations**:
- Python: `black`, `isort`
- JavaScript/TypeScript: `prettier`
- Shell: `shfmt`

### 5. Security Tools

#### Secret Scanning
**Purpose**: Detect exposed secrets and credentials
**Status**: ✅ Active in agent-compliance.yml
**Method**: Regex pattern matching

**Patterns Detected**:
- API keys
- Passwords
- Tokens
- AWS credentials
- Private keys

**Configuration**: See `.github/workflows/agent-compliance.yml`

#### Dependency Scanning
**Purpose**: Identify vulnerable dependencies
**Status**: ⚠️ Recommended for Addition

**Suggested Tools**:

**For Python**:
```bash
# Safety
pip install safety
safety check

# Bandit (security linter)
pip install bandit
bandit -r .
```

**For JavaScript**:
```bash
# npm audit
npm audit

# Snyk
npm install -g snyk
snyk test
```

#### CodeQL
**Purpose**: Static security analysis
**Status**: 🔴 To Be Configured
**Recommendation**: High Priority

**Setup**:
```yaml
# .github/workflows/codeql.yml
name: CodeQL Analysis
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]
  schedule:
    - cron: '0 0 * * 0'  # Weekly

jobs:
  analyze:
    runs-on: ubuntu-latest
    permissions:
      security-events: write
    steps:
      - uses: actions/checkout@v4
      - uses: github/codeql-action/init@v2
        with:
          languages: python, javascript  # Adjust as needed
      - uses: github/codeql-action/analyze@v2
```

### 6. Testing Tools

#### Testing Framework
**Status**: ⚠️ To Be Configured Based on Content

**For Python Projects**:
```bash
# pytest
pip install pytest pytest-cov

# Configuration: pytest.ini or pyproject.toml
[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
addopts = "--cov=. --cov-report=html --cov-report=term"
```

**For JavaScript Projects**:
```bash
# Jest
npm install --save-dev jest

# Configuration: jest.config.js
module.exports = {
  testEnvironment: 'node',
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80
    }
  }
};
```

#### Coverage Tools
**Purpose**: Measure test coverage
**Status**: ⚠️ To Be Configured

**Recommendations**:
- Python: `coverage.py`, `pytest-cov`
- JavaScript: `istanbul`, `jest`

### 7. Documentation Tools

#### Markdown
**Purpose**: Documentation format
**Status**: ✅ Active
**Files**: All `.md` files

**Style Guidelines**:
- Use ATX-style headers (`#`)
- Include table of contents for long documents
- Use code blocks with language specification
- Include examples for complex concepts

#### Documentation Linter
**Status**: ⚠️ Recommended for Addition

**Suggested Tool**:
```bash
# markdownlint
npm install -g markdownlint-cli

# Configuration: .markdownlint.json
{
  "default": true,
  "MD013": false,  # Line length
  "MD033": false   # Inline HTML
}

# Usage
markdownlint '**/*.md'
```

### 8. Project Management Tools

#### Issue Templates
**Status**: 🔴 To Be Added
**Location**: `.github/ISSUE_TEMPLATE/`

**Recommended Templates**:
1. Bug Report
2. Feature Request
3. Documentation Update
4. Security Vulnerability

#### Pull Request Template
**Status**: 🔴 To Be Added
**Location**: `.github/pull_request_template.md`

**Should Include**:
- Description of changes
- Related issues
- Testing performed
- Checklist for reviewers
- Screenshots (if UI changes)

## Tool Configuration Status

### ✅ Configured and Active
- Git with `.gitignore`
- GitHub Actions (import-production-ready.yml)
- GitHub Actions (agent-compliance.yml)
- Import script (`import.sh`)
- Diagnostic script (`diagnose.sh`)
- Markdown documentation

### ⚠️ Recommended for Configuration
- Language-specific linters (Python, JavaScript)
- Code formatters (black, prettier)
- Testing frameworks (pytest, jest)
- Coverage tools
- Documentation linter (markdownlint)
- Dependency scanners

### 🔴 High Priority Additions
- CodeQL security analysis
- Issue templates
- Pull request template
- Pre-commit hooks
- Automated dependency updates (Dependabot)

## Tool Installation Guide

### Prerequisites

```bash
# Update system
sudo apt-get update

# Install Python and pip
sudo apt-get install python3 python3-pip

# Install Node.js and npm
sudo apt-get install nodejs npm

# Install Git
sudo apt-get install git
```

### Recommended Setup

```bash
# Python tools
pip install pylint flake8 black isort pytest pytest-cov safety bandit

# JavaScript tools
npm install -g eslint prettier markdownlint-cli

# Shell tools
sudo apt-get install shellcheck
```

## Tool Usage Best Practices

### Before Committing

```bash
# 1. Run linters
pylint **/*.py
eslint .

# 2. Run formatters
black .
prettier --write .

# 3. Run tests
pytest
npm test

# 4. Check coverage
pytest --cov=.
npm run test:coverage

# 5. Security scan
safety check
npm audit
```

### In CI/CD Pipeline

```yaml
# Recommended pipeline stages
stages:
  - lint          # Code style and quality
  - security      # Security scanning
  - test          # Unit and integration tests
  - build         # Build artifacts
  - deploy        # Deployment (if applicable)
```

### For Code Review

```bash
# Before requesting review
1. All linters pass
2. All tests pass
3. Coverage threshold met
4. Documentation updated
5. Security scan clean
```

## Tool Maintenance

### Regular Updates

```bash
# Monthly: Update dependencies
pip list --outdated
npm outdated

# Update Python packages
pip install --upgrade <package>

# Update npm packages
npm update

# Update system packages
sudo apt-get upgrade
```

### Quarterly Review

1. Assess tool effectiveness
2. Check for new tools
3. Remove unused tools
4. Update configurations
5. Review security advisories

## Adding New Tools

### Proposal Template

```markdown
## Tool Proposal: [Tool Name]

**Purpose**: [What problem does it solve?]
**Category**: [Linter/Formatter/Security/Testing/etc.]
**Alternatives Considered**: [Other options evaluated]
**Benefits**: [Why this tool?]
**Cost**: [Performance/maintenance overhead]
**Configuration**: [Setup requirements]
**Integration**: [How it fits in workflow]
```

### Approval Process

1. Create issue with proposal
2. Discuss with maintainers
3. Test in isolated branch
4. Document configuration
5. Add to CI/CD if applicable
6. Update this TOOLS.md
7. Announce to team

## Removing Tools

### Deprecation Process

1. Announce deprecation (2 weeks notice)
2. Update documentation
3. Remove from CI/CD
4. Clean up configuration files
5. Update dependencies
6. Archive documentation

## Tool Support

### Getting Help

```bash
# For script tools
./import.sh --help
./diagnose.sh --help

# For CLI tools
git --help
gh --help

# For language tools
pylint --help
eslint --help
```

### Troubleshooting

Common issues and solutions:

**Import fails**:
- Run `./diagnose.sh` first
- Check token permissions
- Verify network connectivity

**Documentation issues**:
- Run `./validate-docs.sh` to check structure
- Verify all required files exist
- Check that links between documents are correct

**Linter errors**:
- Check configuration files
- Update to latest version
- Review error messages

**Test failures**:
- Run locally first
- Check test environment
- Verify dependencies

### Reporting Issues

For tool-related issues:
1. Describe the problem clearly
2. Include error messages
3. List reproduction steps
4. Specify tool version
5. Mention environment details

## Conclusion

This repository uses a combination of standard development tools and custom scripts to maintain code quality, security, and efficiency. Regular review and updates ensure the toolset remains effective and current.

---

*Last Updated: 2025-10-26*
*Version: 1.1.0*
*Tool Count: 16+ configured and recommended*
*Next Review: 2026-01-26*
