# Import Flow Diagram

## Overview

This document illustrates the flow of importing the production-ready folder from the ymera_y repository.

## Method 1: Command-Line Import Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                        USER STARTS IMPORT                        │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                   ./import.sh YOUR_TOKEN                         │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Validate Token                              │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │ • Check if token provided                                 │  │
│  │ • Validate token format                                   │  │
│  └───────────────────────────────────────────────────────────┘  │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                        ┌────────┴────────┐
                        │                 │
                    [VALID]           [INVALID]
                        │                 │
                        │                 ▼
                        │      ┌──────────────────────┐
                        │      │  Show Error Message  │
                        │      │  Display Usage Help  │
                        │      │      EXIT(1)         │
                        │      └──────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Clone Source Repository                       │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │ git clone --depth 1 --branch copilot/...                 │  │
│  │   https://oauth2:TOKEN@github.com/ymera-mfm/ymera_y.git  │  │
│  └───────────────────────────────────────────────────────────┘  │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                        ┌────────┴────────┐
                        │                 │
                   [SUCCESS]           [FAILED]
                        │                 │
                        │                 ▼
                        │      ┌──────────────────────┐
                        │      │  Show Error Message  │
                        │      │  • Check token scope │
                        │      │  • Check access      │
                        │      │  • Check branch      │
                        │      │      EXIT(1)         │
                        │      └──────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Copy Production-Ready Files                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │ If /production-ready/ folder exists:                      │  │
│  │   → Copy its contents                                     │  │
│  │ Else:                                                     │  │
│  │   → Copy entire repository (excluding .git)               │  │
│  └───────────────────────────────────────────────────────────┘  │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Display Import Summary                        │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │ • List imported files                                     │  │
│  │ • Show next steps                                         │  │
│  │ • Suggest git commands                                    │  │
│  └───────────────────────────────────────────────────────────┘  │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                    User Commits Changes                          │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │ git add production-ready/                                 │  │
│  │ git commit -m "Import production-ready folder"            │  │
│  │ git push                                                  │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## Method 2: GitHub Actions Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                  User Navigates to Actions Tab                   │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│             Select "Import Production-Ready Folder"              │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Click "Run workflow"                        │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │ Optional: Configure                                       │  │
│  │ • Source branch (default: copilot/extract-...)            │  │
│  │ • Target directory (default: production-ready)            │  │
│  └───────────────────────────────────────────────────────────┘  │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Workflow Starts Running                       │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                  Check YMERA_IMPORT_TOKEN Secret                 │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                        ┌────────┴────────┐
                        │                 │
                    [EXISTS]        [NOT FOUND]
                        │                 │
                        │                 ▼
                        │      ┌──────────────────────┐
                        │      │  Workflow Fails      │
                        │      │  Show Error:         │
                        │      │  Add secret first    │
                        │      └──────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Clone Source Repository                       │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                        ┌────────┴────────┐
                        │                 │
                   [SUCCESS]           [FAILED]
                        │                 │
                        │                 ▼
                        │      ┌──────────────────────┐
                        │      │  Workflow Fails      │
                        │      │  Show diagnostics    │
                        │      └──────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Copy Files to Target Directory                │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Configure Git & Commit                      │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │ git config user.name "github-actions[bot]"                │  │
│  │ git config user.email "..."                               │  │
│  │ git add production-ready/                                 │  │
│  │ git commit -m "Import production-ready folder..."         │  │
│  └───────────────────────────────────────────────────────────┘  │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Push Changes to GitHub                      │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Display Workflow Summary                      │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │ ✅ Import completed successfully                          │  │
│  │ • Source repository                                       │  │
│  │ • Branch used                                             │  │
│  │ • Target directory                                        │  │
│  │ • List of imported files                                  │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## Diagnostic Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                   ./diagnose.sh YOUR_TOKEN                       │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│  CHECK 1: Token Provided                                         │
│  ✓ Token provided                                                │
│  ✓ Format validation                                             │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│  CHECK 2: Network Connectivity                                   │
│  ✓ Can reach github.com                                          │
│  ✓ Can connect to GitHub API                                     │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│  CHECK 3: Token Authentication                                   │
│  ✓ Test with public repo (octocat/Hello-World)                   │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│  CHECK 4: Source Repository Access                               │
│  ✓ Can access ymera-mfm/ymera_y                                  │
│  ✓ Branch exists                                                 │
│  ✓ Count files in repository                                     │
│  ✓ Check for production-ready folder                             │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│  CHECK 5: Git Configuration                                      │
│  ✓ Git user.name configured                                      │
│  ✓ Git user.email configured                                     │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│  CHECK 6: Local Repository Status                                │
│  ✓ In a git repository                                           │
│  ✓ Current branch                                                │
│  ✓ Check production-ready folder status                          │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Display Summary                             │
│  • All checks passed → Ready to import                           │
│  • Some failed → Show specific issues and fixes                  │
└─────────────────────────────────────────────────────────────────┘
```

## Error Recovery Paths

### Token Issues
```
Token Problem → Check token scopes → Regenerate with 'repo' → Retry
```

### Access Issues
```
No Access → Request collaborator access → Owner grants access → Retry
```

### Branch Issues
```
Branch Not Found → Check branch name → Use correct branch → Retry
```

### Network Issues
```
Network Problem → Check connectivity → Use VPN/proxy → Retry
```

## Best Practices

1. **Always run diagnostics first** if you encounter issues
2. **Use GitHub Actions** for automated, hands-free imports
3. **Keep tokens secure** - never commit them
4. **Verify imports** before deleting source
5. **Document custom configurations** for team members
