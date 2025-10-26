# Agent Operational Guidelines

## Overview

This document provides detailed operational guidelines for all agents working within this repository. These guidelines implement and extend the principles outlined in the [AGENT_CODE_OF_CONDUCT.md](../../AGENT_CODE_OF_CONDUCT.md).

## Agent Types and Responsibilities

### 1. Code Review Agents
**Purpose**: Review code changes for quality, security, and compliance

**Responsibilities**:
- Validate code style and conventions
- Identify potential bugs and security issues
- Ensure test coverage is adequate
- Check documentation completeness
- Verify compliance with code of conduct

**Key Metrics**:
- Code quality score
- Security vulnerability count
- Test coverage percentage
- Documentation completeness

### 2. Deployment Agents
**Purpose**: Manage deployment processes and infrastructure

**Responsibilities**:
- Execute deployment workflows
- Validate deployment configurations
- Monitor deployment health
- Rollback on failures
- Update deployment documentation

**Key Metrics**:
- Deployment success rate
- Deployment duration
- Rollback frequency
- Infrastructure health

### 3. Testing Agents
**Purpose**: Execute and manage automated testing

**Responsibilities**:
- Run unit, integration, and e2e tests
- Generate test reports
- Identify flaky tests
- Maintain test infrastructure
- Report test failures

**Key Metrics**:
- Test pass rate
- Test execution time
- Coverage percentage
- Flakiness index

### 4. Documentation Agents
**Purpose**: Maintain and update documentation

**Responsibilities**:
- Generate API documentation
- Update README files
- Maintain changelog
- Create usage examples
- Verify documentation accuracy

**Key Metrics**:
- Documentation coverage
- Freshness score
- Accuracy rating
- User satisfaction

### 5. Security Agents
**Purpose**: Monitor and enforce security standards

**Responsibilities**:
- Scan for vulnerabilities
- Validate dependencies
- Enforce access controls
- Monitor security alerts
- Generate security reports

**Key Metrics**:
- Vulnerability count by severity
- Dependency health score
- Security compliance percentage
- Time to remediation

## Standard Operating Procedures

### Starting a Task

```yaml
1. Read and understand the task:
   - Parse requirements thoroughly
   - Identify success criteria
   - Note any constraints or dependencies

2. Assess the environment:
   - Check repository state
   - Review recent changes
   - Identify potential conflicts

3. Plan the approach:
   - Design minimal-change strategy
   - Identify affected components
   - Determine testing requirements
   - Document the plan

4. Seek approval (if required):
   - Present plan to stakeholders
   - Address concerns
   - Obtain necessary permissions
```

### During Task Execution

```yaml
1. Make incremental changes:
   - One logical change at a time
   - Test after each change
   - Commit frequently with clear messages

2. Maintain transparency:
   - Log all actions taken
   - Report progress regularly
   - Communicate blockers immediately

3. Handle errors gracefully:
   - Detect errors early
   - Log error details
   - Attempt recovery
   - Report unrecoverable issues

4. Respect resource limits:
   - Monitor compute usage
   - Optimize for efficiency
   - Clean up temporary resources
```

### Completing a Task

```yaml
1. Verify completion:
   - All requirements met
   - Tests passing
   - Documentation updated
   - No regressions introduced

2. Clean up:
   - Remove temporary files
   - Close unused resources
   - Archive logs appropriately

3. Document outcomes:
   - Update changelog
   - Record learnings
   - Note any technical debt

4. Report completion:
   - Summarize work done
   - Highlight any issues
   - Provide metrics
   - Request review if needed
```

## Tool Usage Guidelines

### Approved Tools

The following tools are approved for use in this repository:

#### Development Tools
- **Git**: Version control operations
- **GitHub CLI**: GitHub API interactions
- **Linters**: Code quality validation (language-specific)
- **Formatters**: Code style enforcement

#### Testing Tools
- **pytest**: Python testing framework
- **Jest**: JavaScript testing framework
- **Coverage.py**: Python coverage analysis
- **Playwright**: Browser automation and testing

#### Security Tools
- **CodeQL**: Static security analysis
- **Dependency scanners**: Vulnerability detection
- **Secret scanners**: Credential leak prevention

#### Documentation Tools
- **Markdown**: Documentation format
- **Sphinx**: Python documentation generator
- **JSDoc**: JavaScript documentation

### Tool Configuration

All tools must be properly configured:

```yaml
Location: Repository root or .github/
Format: Standard configuration files
Validation: Must pass configuration validation
Documentation: Usage documented in TOOLS.md
```

### Adding New Tools

To add a new tool:

1. **Justify the need**: Explain what problem it solves
2. **Research alternatives**: Compare with existing tools
3. **Assess compatibility**: Ensure it works with current stack
4. **Test integration**: Verify it doesn't break existing workflows
5. **Document usage**: Add to TOOLS.md with examples
6. **Update CI/CD**: Integrate into automated workflows

### Removing Tools

To remove a tool:

1. **Verify non-usage**: Confirm no active dependencies
2. **Assess impact**: Check if removal affects workflows
3. **Plan migration**: If needed, migrate to alternatives
4. **Update documentation**: Remove from all docs
5. **Clean configuration**: Delete config files
6. **Update dependencies**: Remove from package files

## Workflow Integration

### CI/CD Pipeline

Agents must integrate with the CI/CD pipeline:

```yaml
Stages:
  1. Pre-commit:
     - Linting
     - Formatting
     - Secret scanning

  2. Build:
     - Compile/build code
     - Generate artifacts
     - Validate builds

  3. Test:
     - Unit tests
     - Integration tests
     - E2E tests
     - Security tests

  4. Quality Gates:
     - Code coverage threshold
     - Security compliance
     - Performance benchmarks

  5. Deploy:
     - Staging deployment
     - Production deployment (if approved)
     - Post-deployment validation
```

### Pull Request Workflow

```yaml
1. PR Creation:
   - Automated checks trigger
   - Compliance validation
   - Initial review

2. Review Process:
   - Code review by agents
   - Human review (if required)
   - Address feedback

3. Approval:
   - All checks pass
   - Required approvals obtained
   - Conflicts resolved

4. Merge:
   - Automated merge (if configured)
   - Post-merge validation
   - Deployment triggered
```

## Error Handling and Recovery

### Error Detection

Agents must detect:
- Syntax errors
- Runtime errors
- Logic errors
- Integration failures
- Security violations
- Performance degradations

### Error Response

```yaml
1. Immediate Actions:
   - Log error details
   - Halt problematic operations
   - Notify stakeholders

2. Analysis:
   - Identify root cause
   - Assess impact
   - Determine severity

3. Resolution:
   - Apply fix if known
   - Rollback if necessary
   - Escalate if needed

4. Prevention:
   - Update validation rules
   - Add test cases
   - Document lessons learned
```

## Communication Protocols

### Status Updates

```yaml
Frequency: 
  - After each major step
  - Every 5 minutes for long operations
  - Immediately upon errors

Format:
  - Clear, concise messages
  - Include relevant context
  - Provide actionable information

Channels:
  - PR comments
  - Issue updates
  - Logs
  - Notifications (for critical events)
```

### Reporting

```yaml
Types:
  1. Progress Reports:
     - What was completed
     - What's in progress
     - What's remaining

  2. Error Reports:
     - Error description
     - Impact assessment
     - Proposed resolution

  3. Completion Reports:
     - Summary of changes
     - Test results
     - Metrics and statistics

  4. Security Reports:
     - Vulnerabilities found
     - Remediation status
     - Compliance verification
```

## Quality Assurance

### Code Quality Standards

```yaml
Requirements:
  - Follows language-specific style guide
  - No linting errors
  - Adequate commenting
  - Proper error handling
  - Efficient algorithms

Validation:
  - Automated linting
  - Code review by agents
  - Peer review (if configured)
  - Static analysis
```

### Testing Standards

```yaml
Coverage:
  - Minimum 80% line coverage
  - 100% critical path coverage
  - All public APIs tested

Types:
  - Unit tests for functions
  - Integration tests for modules
  - E2E tests for workflows
  - Security tests for vulnerabilities

Quality:
  - Tests must be deterministic
  - Clear test names
  - Isolated test cases
  - Fast execution
```

### Security Standards

```yaml
Requirements:
  - No hardcoded secrets
  - Input validation
  - Output encoding
  - Secure dependencies
  - Access control enforcement

Validation:
  - Security scanning (CodeQL)
  - Dependency scanning
  - Secret scanning
  - Manual security review (for critical changes)
```

## Collaboration Between Agents

### Coordination Mechanisms

```yaml
1. Shared State:
   - Use version control for state
   - Document state changes
   - Lock resources during operations

2. Communication:
   - Use standardized messages
   - Respect operation boundaries
   - Coordinate timing of operations

3. Conflict Resolution:
   - First-come-first-served for resources
   - Priority-based for critical operations
   - Escalation for deadlocks
```

### Best Practices

- **Avoid simultaneous edits**: Coordinate file access
- **Share context**: Document operations in progress
- **Respect roles**: Each agent stays in its domain
- **Learn from others**: Observe and adapt successful patterns
- **Provide feedback**: Report issues with other agents' outputs

## Monitoring and Metrics

### Key Performance Indicators

```yaml
Efficiency:
  - Task completion time
  - Resource utilization
  - Error rate

Quality:
  - Code quality score
  - Test coverage
  - Security compliance

Impact:
  - User satisfaction
  - Deployment frequency
  - Time to recovery
```

### Continuous Improvement

```yaml
Process:
  1. Collect metrics continuously
  2. Analyze trends weekly
  3. Identify improvement opportunities
  4. Implement changes
  5. Measure impact
  6. Iterate
```

## Compliance Checklist

Before completing any task, verify:

- [ ] Code of conduct principles followed
- [ ] Minimal changes principle applied
- [ ] All tests passing
- [ ] Documentation updated
- [ ] Security scan completed
- [ ] No secrets committed
- [ ] Compliance checks passed
- [ ] Changes reviewed
- [ ] Metrics within acceptable ranges
- [ ] Cleanup completed

## Emergency Procedures

### Critical Failures

```yaml
Actions:
  1. Immediate rollback
  2. Alert all stakeholders
  3. Disable failing component
  4. Investigate root cause
  5. Implement fix
  6. Verify resolution
  7. Post-mortem analysis
```

### Security Incidents

```yaml
Actions:
  1. Contain the incident
  2. Assess impact
  3. Notify security team
  4. Remediate vulnerability
  5. Verify fix
  6. Update security policies
  7. Document incident
```

## Support and Escalation

### When to Escalate

- Unable to resolve issue within reasonable time
- Security vulnerabilities beyond agent capability
- Breaking changes required
- Conflicting requirements
- Resource constraints preventing completion

### Escalation Process

```yaml
1. Document the issue:
   - Clear description
   - Steps taken so far
   - Impact assessment

2. Identify appropriate escalation path:
   - Technical issues → Senior engineers
   - Security issues → Security team
   - Policy questions → Repository maintainers

3. Provide context:
   - Relevant logs
   - Error messages
   - Environment details

4. Follow up:
   - Monitor escalation status
   - Provide additional information as requested
   - Implement resolution once provided
```

## Conclusion

These guidelines ensure consistent, high-quality agent operations across the repository. All agents must internalize and follow these guidelines to maintain the trust and effectiveness of our automated systems.

---

*Last Updated: 2025-10-26*
*Version: 1.0.0*
*Maintained by: Repository Governance Team*
