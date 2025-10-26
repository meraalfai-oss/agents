# Contributing to agents

Thank you for your interest in contributing to this repository! This document provides guidelines for contributing to ensure a smooth and effective collaboration process.

## 📋 Before You Start

Please read and understand the following documents:

- **[Code of Conduct](CODE_OF_CONDUCT.md)** - Community standards and behavior expectations
- **[Agent Code of Conduct](AGENT_CODE_OF_CONDUCT.md)** - Guidelines for automated agents
- **[Governance](GOVERNANCE.md)** - Repository governance structure and decision-making processes
- **[Tools Documentation](TOOLS.md)** - Guide to repository tools and their usage

All contributors, whether human or automated agents, must adhere to these guidelines.

## 🚀 Getting Started

### Prerequisites

1. A GitHub account
2. Git installed locally
3. Familiarity with Git workflows (branching, pull requests, etc.)
4. Understanding of the repository's purpose and structure

### Setting Up Your Development Environment

1. **Fork the repository** (if you're an external contributor)
   ```bash
   # Fork via GitHub UI, then clone your fork
   git clone https://github.com/YOUR_USERNAME/agents.git
   cd agents
   ```

2. **Clone the repository** (if you're a collaborator)
   ```bash
   git clone https://github.com/meraalfai-oss/agents.git
   cd agents
   ```

3. **Set up remote upstream** (for forks)
   ```bash
   git remote add upstream https://github.com/meraalfai-oss/agents.git
   ```

4. **Keep your fork synchronized**
   ```bash
   git fetch upstream
   git checkout main
   git merge upstream/main
   ```

## 🔄 Contribution Process

### 1. Choose Your Contribution Type

#### Standard Changes
- Bug fixes
- Documentation improvements
- Minor feature additions
- Tool configuration updates

**Process**: 
- Timeline: 2-5 business days
- Requires: 1 maintainer approval
- Review: Standard PR review

#### Significant Changes
- Major features
- Breaking changes
- Governance updates
- Architecture changes

**Process**:
- Timeline: 2-4 weeks
- Requires: 2+ maintainer approvals
- Review: RFC process, thorough review, testing

### 2. Create a Branch

Use descriptive branch names following this pattern:
```bash
# For features
git checkout -b feature/description

# For bug fixes
git checkout -b fix/description

# For documentation
git checkout -b docs/description

# For automated agents (Copilot, etc.)
git checkout -b copilot/description
```

### 3. Make Your Changes

Follow these principles:

#### Minimal Changes
- Make the smallest possible changes to achieve your goal
- Don't refactor unrelated code
- Keep changes focused and atomic

#### Quality Standards
- Follow existing code style and conventions
- Add tests for new functionality
- Update documentation as needed
- Ensure all tests pass
- No linting errors

#### Security
- Never commit secrets or credentials
- Scan for vulnerabilities
- Follow secure coding practices
- Validate all inputs

### 4. Commit Your Changes

Write clear, descriptive commit messages:

```bash
# Good commit message format
git commit -m "Add feature: brief description

- Detailed point about what changed
- Another detail about implementation
- Reference to related issue: #123"
```

**Commit Message Guidelines**:
- Use imperative mood ("Add feature" not "Added feature")
- Keep first line under 72 characters
- Provide context in the body if needed
- Reference related issues or PRs

### 5. Push Your Changes

```bash
git push origin your-branch-name
```

### 6. Create a Pull Request

1. Go to the repository on GitHub
2. Click "New Pull Request"
3. Select your branch
4. Fill out the PR template (if provided)
5. Provide a clear description:
   - What changes were made
   - Why they were needed
   - How they were tested
   - Any breaking changes or special considerations

#### PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix (non-breaking change)
- [ ] New feature (non-breaking change)
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tests added/updated
- [ ] All tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No secrets committed
- [ ] Changes are minimal and focused
```

### 7. Respond to Review Feedback

- Address all comments and suggestions
- Ask for clarification if needed
- Update your PR with requested changes
- Re-request review after making changes

## 🧪 Testing Guidelines

### Test Coverage Requirements
- Minimum 80% line coverage for new code
- 100% coverage for critical paths
- All public APIs must be tested

### Test Types
- **Unit tests**: Test individual functions/methods
- **Integration tests**: Test component interactions
- **E2E tests**: Test complete workflows (where applicable)

### Running Tests
```bash
# Add specific test commands once testing framework is configured
# Example for Python:
# pytest tests/

# Example for JavaScript:
# npm test
```

## 📝 Documentation Guidelines

### When to Update Documentation
- Adding new features or tools
- Changing existing functionality
- Updating configuration
- Adding dependencies

### Documentation Standards
- Use clear, concise language
- Include examples where appropriate
- Keep formatting consistent
- Update README.md for significant changes
- Update TOOLS.md for tool changes

## 🔒 Security Guidelines

### Security Best Practices
- Never commit secrets, tokens, or credentials
- Use `.env` files with `.gitignore` for local secrets
- Use repository secrets for CI/CD credentials
- Report security vulnerabilities privately
- Follow the principle of least privilege

### Reporting Security Issues
If you discover a security vulnerability:
1. **Do NOT** open a public issue
2. Use GitHub's security advisory feature
3. Or email the maintainers privately
4. Provide detailed information about the vulnerability
5. Wait for acknowledgment before public disclosure

## 🤝 Code Review Process

### For Reviewers
- Review within 2 business days
- Be constructive and respectful
- Focus on code quality, security, and maintainability
- Check for compliance with guidelines
- Verify tests and documentation

### For Contributors
- Be open to feedback
- Don't take criticism personally
- Ask questions if you don't understand feedback
- Make requested changes promptly
- Thank reviewers for their time

## 🤖 Automated Agent Contributions

If you're an automated agent (like GitHub Copilot):

1. **Follow the Agent Code of Conduct**
   - Read [AGENT_CODE_OF_CONDUCT.md](AGENT_CODE_OF_CONDUCT.md)
   - Adhere to all principles and guidelines

2. **Use Proper Branch Naming**
   - Format: `copilot/descriptive-name`
   - Include the agent type in the branch name

3. **Provide Detailed Context**
   - Explain reasoning for changes
   - Document decision-making process
   - Include relevant metrics

4. **Comply with Automated Checks**
   - Ensure all CI/CD checks pass
   - Address compliance workflow feedback
   - Fix any security vulnerabilities

5. **Follow Agent Guidelines**
   - Read [.github/agents/agent-guidelines.md](.github/agents/agent-guidelines.md)
   - Follow standard operating procedures
   - Report progress transparently

## 📊 Quality Gates

All contributions must pass:

- ✅ Linting (no errors)
- ✅ Tests (all passing, minimum 80% coverage)
- ✅ Security scan (no vulnerabilities)
- ✅ Code review (required approvals)
- ✅ Documentation (updated as needed)
- ✅ Compliance checks (via agent-compliance.yml)

## 🎯 Best Practices

### Do's ✅
- Keep changes small and focused
- Write clear commit messages
- Add tests for new functionality
- Update documentation
- Follow existing code style
- Ask questions when unsure
- Be respectful and professional

### Don'ts ❌
- Don't commit large binary files
- Don't include unrelated changes
- Don't commit secrets or credentials
- Don't break existing functionality
- Don't skip tests
- Don't ignore review feedback
- Don't violate the Code of Conduct

## 🆘 Getting Help

### Resources
- **Documentation**: Check the repository docs first
- **Issues**: Search existing issues for similar problems
- **Discussions**: Use GitHub Discussions for questions
- **Tools**: See [TOOLS.md](TOOLS.md) for tool usage help

### Asking for Help
When asking for help:
1. Search existing issues/discussions first
2. Provide context and details
3. Include error messages or logs
4. Describe what you've already tried
5. Be patient and respectful

## 🎉 Recognition

We value all contributions! Contributors will be:
- Acknowledged in release notes
- Listed in the project's contributor graph
- Appreciated in PR comments
- Part of our growing community

## 📞 Contact

- **Issues**: For bug reports and feature requests
- **Discussions**: For questions and community interaction
- **Security**: Use GitHub security advisory for vulnerabilities
- **Email**: [Contact maintainers for sensitive matters]

## 📜 License

By contributing to this repository, you agree that your contributions will be licensed under the same license as the project (see [LICENSE](LICENSE)).

## 🔄 Keeping Up to Date

This document may be updated periodically. Contributors should:
- Check for updates before starting new work
- Follow the latest guidelines
- Suggest improvements via pull requests

---

**Thank you for contributing to the agents repository! Together, we're building something great.** 🚀

*Last Updated: 2025-10-26*
*Version: 1.0.0*
