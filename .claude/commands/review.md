# Code Review Workflow

Perform a comprehensive code review on the current changes.

## Process

1. Analyze git diff for all staged changes
2. Check code quality against best practices
3. Identify security vulnerabilities
4. Verify test coverage
5. Check for performance issues
6. Provide detailed feedback with severity levels

## Review Checklist

- [ ] Code follows style guide
- [ ] No security vulnerabilities
- [ ] Proper error handling
- [ ] Tests are present and passing
- [ ] No performance anti-patterns
- [ ] Documentation is updated
- [ ] No hardcoded secrets

## Output Format

Provide feedback categorized by:
- **Critical**: Must fix before merge
- **Major**: Should fix before merge
- **Minor**: Can fix later
- **Suggestion**: Optional improvements

For each issue, provide:
- Location (file:line)
- Description of the issue
- Suggested fix
- Code example if applicable
