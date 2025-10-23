# Import Guide: Production-Ready Folder from ymera_y

This guide provides multiple methods to import the production-ready folder from the `ymera-mfm/ymera_y` repository.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Method 1: Using the Import Script (Recommended)](#method-1-using-the-import-script-recommended)
3. [Method 2: Using GitHub Actions Workflow](#method-2-using-github-actions-workflow)
4. [Method 3: Manual Import](#method-3-manual-import)
5. [Troubleshooting](#troubleshooting)

## Prerequisites

### GitHub Personal Access Token (PAT)

You need a GitHub token with the following characteristics:

- **Scope**: `repo` (full control of private repositories)
- **Access**: Must have read access to `ymera-mfm/ymera_y` repository
- **Type**: Classic token (not fine-grained)

### Creating a GitHub Token

1. Navigate to [GitHub Settings > Personal Access Tokens](https://github.com/settings/tokens)
2. Click **"Generate new token"** > **"Generate new token (classic)"**
3. Configure the token:
   - **Note**: `ymera_y import token` (or any descriptive name)
   - **Expiration**: Choose an appropriate expiration period
   - **Scopes**: Check `repo` (this includes all sub-scopes)
4. Click **"Generate token"**
5. **Important**: Copy the token immediately - you won't see it again!

## Method 1: Using the Import Script (Recommended)

This is the fastest method for local imports.

### Step 1: Run the Import Script

```bash
# Option A: Pass token as argument
./import.sh ghp_your_token_here

# Option B: Use environment variable
export GITHUB_TOKEN=ghp_your_token_here
./import.sh
```

### Step 2: Review Imported Files

```bash
ls -la production-ready/
```

### Step 3: Commit Changes

```bash
git add production-ready/
git commit -m "Import production-ready folder from ymera_y"
git push
```

## Method 2: Using GitHub Actions Workflow

This method uses GitHub Actions and is ideal for automated or repeated imports.

### Step 1: Add Token as Repository Secret

1. Go to your repository on GitHub
2. Navigate to **Settings** > **Secrets and variables** > **Actions**
3. Click **"New repository secret"**
4. Configure the secret:
   - **Name**: `YMERA_IMPORT_TOKEN`
   - **Secret**: Paste your GitHub token
5. Click **"Add secret"**

### Step 2: Trigger the Workflow

1. Go to **Actions** tab in your repository
2. Select **"Import Production-Ready Folder"** workflow
3. Click **"Run workflow"**
4. Configure options (or use defaults):
   - **Source branch**: `copilot/extract-production-ready-folder` (default)
   - **Target directory**: `production-ready` (default)
5. Click **"Run workflow"**

### Step 3: Monitor Progress

- The workflow will automatically:
  - Clone the source repository
  - Copy the production-ready content
  - Commit and push the changes
  - Display a summary of imported files

## Method 3: Manual Import

If automated methods fail, you can import manually.

### Step 1: Clone Source Repository

```bash
# Replace YOUR_TOKEN with your actual GitHub token
cd /tmp
git clone --depth 1 --branch copilot/extract-production-ready-folder \
  https://oauth2:YOUR_TOKEN@github.com/ymera-mfm/ymera_y.git ymera_source
```

### Step 2: Copy Files

```bash
# Go back to your repository
cd /home/runner/work/agents/agents

# Create target directory
mkdir -p production-ready

# Copy from production-ready folder if it exists
if [ -d /tmp/ymera_source/production-ready ]; then
  cp -r /tmp/ymera_source/production-ready/* ./production-ready/
else
  # Otherwise copy everything
  cp -r /tmp/ymera_source/* ./production-ready/
  rm -rf ./production-ready/.git
fi
```

### Step 3: Clean Up and Commit

```bash
# Remove temporary directory
rm -rf /tmp/ymera_source

# Stage changes
git add production-ready/

# Commit
git commit -m "Import production-ready folder from ymera_y"

# Push
git push
```

## Troubleshooting

### Error: "Failed to clone repository"

**Possible causes:**
- Token doesn't have `repo` scope
- Token doesn't have access to `ymera-mfm/ymera_y`
- Token has expired
- Branch name is incorrect

**Solutions:**
1. Verify token scopes at [GitHub Tokens](https://github.com/settings/tokens)
2. Ensure you're a collaborator on `ymera-mfm/ymera_y`
3. Check if the branch exists: `copilot/extract-production-ready-folder`
4. Generate a new token if expired

### Error: "404 Not Found"

**Possible causes:**
- Repository is private and token lacks access
- Repository or branch doesn't exist
- Token has been revoked

**Solutions:**
1. Verify repository exists: https://github.com/ymera-mfm/ymera_y
2. Check your access permissions
3. Confirm the branch name is correct

### Error: "YMERA_IMPORT_TOKEN secret is not configured"

**Solution:**
Add the token as a repository secret (see Method 2, Step 1)

### Error: "Permission denied"

**Possible causes:**
- Token doesn't have write access to target repository
- Branch protection rules prevent direct pushes

**Solutions:**
1. Ensure you have write access to this repository
2. Check branch protection rules
3. Consider creating a pull request instead

### Import Script Not Executable

**Solution:**
```bash
chmod +x import.sh
```

### No Files Imported

**Possible causes:**
- Source repository/branch is empty
- Incorrect branch name
- Path issues

**Solutions:**
1. Verify the source repository has content
2. Check the branch name
3. Try manual import to diagnose

## Verifying the Import

After import, verify the content:

```bash
# Check directory structure
tree production-ready/  # or ls -R production-ready/

# Check file count
find production-ready -type f | wc -l

# View specific files
cat production-ready/README.md  # adjust path as needed
```

## Security Notes

⚠️ **Important Security Considerations:**

1. **Never commit tokens to the repository**
2. **Use repository secrets for GitHub Actions**
3. **Set appropriate token expiration dates**
4. **Revoke tokens after use if they're temporary**
5. **Use minimal required scopes**

## Getting Help

If you continue to experience issues:

1. Check the Actions tab for workflow run details
2. Review the repository's issue tracker
3. Ensure you have the latest version of the import script
4. Contact repository administrators for access issues

## Additional Resources

- [GitHub Personal Access Tokens Documentation](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
- [GitHub Actions Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [Git Authentication](https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage)
