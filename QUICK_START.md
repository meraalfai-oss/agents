# Quick Start: Import Production-Ready Folder

## 🚀 Fastest Method (Local)

```bash
# 1. Get your GitHub token from https://github.com/settings/tokens
#    (Must have 'repo' scope and access to ymera-mfm/ymera_y)

# 2. Run the import script
./import.sh YOUR_GITHUB_TOKEN

# 3. Commit and push
git add production-ready/
git commit -m "Import production-ready folder"
git push
```

## 🤖 GitHub Actions Method (Automated)

### One-Time Setup
1. Go to **Settings** > **Secrets and variables** > **Actions**
2. Add secret: Name = `YMERA_IMPORT_TOKEN`, Value = your GitHub token

### Run Import
1. Go to **Actions** tab
2. Select **"Import Production-Ready Folder"**
3. Click **"Run workflow"**

Done! The workflow will automatically import and commit.

## ❓ Need Help?

See [IMPORT_GUIDE.md](IMPORT_GUIDE.md) for detailed instructions and troubleshooting.

## 🔐 Creating a GitHub Token

1. Visit: https://github.com/settings/tokens
2. Click: **"Generate new token (classic)"**
3. Name: `ymera_y import`
4. Scope: Check `repo`
5. Generate and copy the token

**⚠️ Important**: Never commit the token to the repository!
