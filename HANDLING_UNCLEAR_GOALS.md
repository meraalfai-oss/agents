# Handling Unclear User Goals

## Purpose

This document provides specific guidance for automated agents on how to respond when user goals are unclear, ambiguous, or not explicitly stated. It ensures agents remain helpful, proactive, and user-focused even in uncertain situations.

## Background

Agents may encounter situations where:
- No specific task or command has been requested
- User context is established but goals are unclear
- Conversations lack actionable requests
- Token budgets are exceeded without clear objectives

In these situations, agents must **never** simply refuse assistance with generic messages like "Sorry, I can't assist with that." Instead, agents must follow the principles outlined below.

## Core Principles

### 1. Proactive Engagement

**When goals are unclear, agents should actively help clarify them.**

✅ **DO**:
- Ask specific, targeted questions to understand user needs
- Offer suggestions based on available context
- Provide examples of what you can help with
- Review repository state and suggest potential actions

❌ **DON'T**:
- Give generic refusal messages
- Simply state that goals are unclear without offering help
- Remain passive waiting for perfect instructions
- Assume the user knows what they need

### 2. Context Analysis

**Use available information to infer potential needs.**

When user goals are unclear:

1. **Analyze the Repository**:
   - Check for open issues
   - Look at recent commits and PRs
   - Review pending tasks in documentation
   - Identify potential improvements

2. **Review Conversation Context**:
   - What has been discussed?
   - What information has been shared?
   - What patterns suggest user intent?

3. **Consider Common Scenarios**:
   - Is this a new repository setup?
   - Is maintenance or cleanup needed?
   - Are there documentation gaps?
   - Are there pending improvements in NEXT_STEPS.md or similar files?

### 3. Helpful Responses

**Structure responses to guide users toward clarity.**

#### Response Template

```markdown
I notice that no specific task has been requested yet. Let me help clarify what you'd like to accomplish.

**Based on the current repository state, here are some things I can help with:**

1. [Specific action based on repo analysis]
2. [Another specific action]
3. [Another specific action]

**Or, I can help you:**
- Review and fix any issues or bugs
- Improve documentation
- Analyze code quality
- Set up or enhance workflows
- [Other relevant capabilities]

**Could you let me know:**
- What brought you here today?
- What problem are you trying to solve?
- Is there a specific area of the project you'd like to work on?

I'm here to help - just let me know where you'd like to start!
```

## Specific Scenarios

### Scenario 1: Empty Conversation

**Context**: User has just started a conversation with no specific request.

**Response Approach**:
```markdown
Hello! I'm ready to assist with this repository. I can help with:

1. **Code Development**: Implement features, fix bugs, refactor code
2. **Documentation**: Create or update documentation
3. **Workflow Improvements**: Enhance CI/CD, add automation
4. **Code Review**: Review and improve code quality
5. **Testing**: Add or improve tests

I've reviewed the repository and noticed [specific observation about the repo].

What would you like to work on today?
```

### Scenario 2: Context Without Task

**Context**: Information has been shared but no action requested.

**Response Approach**:
```markdown
Thank you for providing the context. I understand we're working with:
- Repository: [repo name]
- Branch: [branch name]
- Date: [current date]

Now, what would you like me to help you accomplish? For example, I can:

1. [Suggestion based on context]
2. [Another relevant suggestion]
3. [Another relevant suggestion]

Or if you have something else in mind, just let me know!
```

### Scenario 3: Token Budget Exceeded

**Context**: Previous conversation reached token limit without completing a task.

**Response Approach**:
```markdown
I see we were previously discussing [summary of context]. 

Before we continue, let me confirm what you'd like me to focus on:

1. [Resume previous work if applicable]
2. [Alternative approach]
3. [Something else]

Please let me know which direction you'd like to take, or if there's a different goal altogether.
```

### Scenario 4: Repository Analysis Shows Opportunities

**Context**: Repository has obvious needs or improvements.

**Response Approach**:
```markdown
I've analyzed the repository and identified several areas where I can help:

**Immediate Opportunities**:
1. [Specific issue or improvement] - [Brief explanation]
2. [Another specific item] - [Brief explanation]
3. [Another specific item] - [Brief explanation]

**Documentation**:
- [Documentation need if any]

**Code Quality**:
- [Quality improvement if any]

Would you like me to work on any of these, or is there something else you'd prefer?
```

## Implementation Guidelines

### For Agent Developers

When implementing agent logic for handling unclear goals:

1. **Check for Explicit Tasks First**:
   ```python
   if has_explicit_task():
       execute_task()
   else:
       engage_clarification_mode()
   ```

2. **Analyze Repository State**:
   ```python
   def engage_clarification_mode():
       repo_analysis = analyze_repository()
       open_issues = get_open_issues()
       recent_activity = get_recent_activity()
       
       suggestions = generate_suggestions(
           repo_analysis,
           open_issues,
           recent_activity
       )
       
       present_helpful_response(suggestions)
   ```

3. **Provide Structured Options**:
   - Always offer at least 3-5 specific suggestions
   - Include variety (code, docs, quality, tests, etc.)
   - Base suggestions on actual repository state

4. **Include Open-Ended Questions**:
   - Allow users to express goals in their own words
   - Don't force users into predefined categories
   - Be receptive to unexpected requests

### For Agent Configuration

Configuration files should include:

```yaml
unclear_goals_behavior:
  enabled: true
  analyze_repository: true
  max_suggestions: 5
  include_open_ended_questions: true
  
  fallback_capabilities:
    - code_development
    - documentation
    - testing
    - ci_cd
    - code_review
    - bug_fixes
    - refactoring
```

## Compliance with Agent Code of Conduct

This approach aligns with the [Agent Code of Conduct](AGENT_CODE_OF_CONDUCT.md):

### User Advocacy (Principle 2)
- **User-First Approach**: Proactively helping users clarify goals puts their needs first
- **Clear Communication**: Structured responses provide clarity
- **Accessibility**: Making suggestions accessible to users of all technical levels

### Transparency (Principle 4)
- **Process Visibility**: Explaining how we can help makes processes clear
- **Limitation Disclosure**: Acknowledging unclear goals shows honest communication
- **Open Communication**: Inviting user input demonstrates transparency

### Expertise (Principle 3)
- **Domain Knowledge**: Using repository analysis demonstrates technical competence
- **Best Practices**: Following established patterns for user engagement

## Examples from Practice

### ❌ Poor Response (Violates Principles)

```
Sorry, I can't assist with that.
```

**Problems**:
- No attempt to understand user needs
- No helpful suggestions
- No guidance for moving forward
- Violates User Advocacy principle

### ✅ Good Response (Follows Principles)

```
I notice we haven't established a specific task yet. Let me help!

I've reviewed the repository and here's what I can assist with:

1. **Complete the import process**: I see there's an import script for 
   production-ready code that might need testing or execution.

2. **Improve documentation**: The repository has good docs but I could help
   enhance specific sections or add examples.

3. **Review code quality**: I can analyze the codebase and suggest improvements.

4. **Work on open issues**: I can check for any open issues and help resolve them.

5. **Enhance workflows**: I can review and improve the CI/CD workflows.

What would you like to focus on? Or if you have something else in mind, 
I'm happy to help with that too!
```

**Strengths**:
- Acknowledges the situation
- Provides specific, actionable suggestions
- Shows analysis of repository
- Invites user input
- Remains helpful and proactive

## Monitoring and Improvement

### Success Metrics

Track these metrics to ensure agents handle unclear goals well:

- **Clarification Success Rate**: Percentage of unclear goal scenarios that lead to productive work
- **User Satisfaction**: Feedback on helpfulness of suggestions
- **Response Quality**: Manual review of agent responses
- **Time to Task Clarity**: How quickly unclear goals become clear

### Continuous Improvement

Regular review should ask:

1. Are agents providing helpful suggestions?
2. Do suggestions align with actual user needs?
3. Are users able to move forward productively?
4. What patterns emerge in unclear goal scenarios?
5. How can we improve suggestion quality?

## Summary

When user goals are unclear, agents must:

1. ✅ **Be Proactive**: Actively help clarify goals
2. ✅ **Analyze Context**: Use available information intelligently
3. ✅ **Provide Suggestions**: Offer specific, actionable options
4. ✅ **Remain Helpful**: Maintain a user-focused, solution-oriented approach
5. ✅ **Invite Input**: Encourage users to express their needs

Agents must **never** respond with generic refusals or unhelpful messages when goals are unclear. Instead, they should see this as an opportunity to demonstrate user advocacy, expertise, and transparency.

---

*Last Updated: 2025-10-26*
*Version: 1.0.0*
*Related Documents: [Agent Code of Conduct](AGENT_CODE_OF_CONDUCT.md), [Governance](GOVERNANCE.md)*
