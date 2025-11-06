# Code Review Skill

Perform comprehensive code reviews following industry best practices.

## Review Checklist

### 1. Code Quality
- [ ] Follows coding standards and style guide
- [ ] No code duplication (DRY principle)
- [ ] Functions are small and focused (SRP)
- [ ] Meaningful variable and function names
- [ ] Appropriate use of comments (why, not what)
- [ ] No magic numbers or strings
- [ ] Proper error handling

### 2. Architecture & Design
- [ ] SOLID principles applied
- [ ] Appropriate design patterns used
- [ ] Separation of concerns
- [ ] Dependency injection where appropriate
- [ ] No circular dependencies
- [ ] Interfaces used for abstraction
- [ ] Proper layering/modularity

### 3. Security
- [ ] No hardcoded secrets or credentials
- [ ] Input validation and sanitization
- [ ] SQL injection prevention
- [ ] XSS prevention
- [ ] CSRF protection where needed
- [ ] Proper authentication/authorization
- [ ] Secure data transmission
- [ ] No sensitive data in logs

### 4. Performance
- [ ] Efficient algorithms and data structures
- [ ] No N+1 queries
- [ ] Proper indexing for database queries
- [ ] Caching implemented where appropriate
- [ ] No unnecessary computations
- [ ] Lazy loading where appropriate
- [ ] Resource cleanup (connections, files)

### 5. Testing
- [ ] Unit tests present and passing
- [ ] Integration tests where needed
- [ ] Test coverage is adequate (>80% for critical paths)
- [ ] Edge cases tested
- [ ] Error conditions tested
- [ ] Tests are maintainable
- [ ] No flaky tests

### 6. Error Handling
- [ ] All errors properly caught and handled
- [ ] Meaningful error messages
- [ ] Proper logging at appropriate levels
- [ ] No swallowed exceptions
- [ ] Graceful degradation
- [ ] Retry logic where appropriate

### 7. Documentation
- [ ] README updated if needed
- [ ] API documentation present
- [ ] Complex logic explained
- [ ] Public APIs documented
- [ ] Breaking changes noted
- [ ] Migration guide if needed

### 8. Dependencies
- [ ] No unnecessary dependencies
- [ ] Dependencies are up to date
- [ ] No known vulnerabilities
- [ ] License compatibility checked
- [ ] Bundle size impact considered

### 9. Database
- [ ] Migrations are reversible
- [ ] Indexes on foreign keys
- [ ] No missing indexes for queries
- [ ] Proper transaction handling
- [ ] Connection pooling used
- [ ] Data validation at DB level

### 10. API Design
- [ ] RESTful principles followed
- [ ] Consistent naming conventions
- [ ] Proper HTTP methods and status codes
- [ ] Versioning strategy in place
- [ ] Rate limiting considered
- [ ] Pagination for list endpoints

## Review Process

1. **Understand the Context**
   - Read the PR/commit description
   - Understand what problem is being solved
   - Review linked issues/tickets

2. **High-Level Review**
   - Check overall architecture
   - Verify design decisions
   - Look for major issues

3. **Detailed Review**
   - Go through code line by line
   - Check against checklist above
   - Note issues by severity

4. **Security Review**
   - Look for security vulnerabilities
   - Check authentication/authorization
   - Verify input validation

5. **Performance Review**
   - Look for performance issues
   - Check database queries
   - Review caching strategy

6. **Test Review**
   - Verify test coverage
   - Check test quality
   - Run tests locally

7. **Provide Feedback**
   - Categorize by severity: Critical, Major, Minor, Suggestion
   - Be specific and constructive
   - Provide examples or alternatives
   - Acknowledge good practices

## Severity Levels

**Critical**: Must be fixed before merge
- Security vulnerabilities
- Data loss scenarios
- Breaking changes without migration
- Production-breaking bugs

**Major**: Should be fixed before merge
- Performance issues
- Architectural violations
- Missing error handling
- Inadequate test coverage

**Minor**: Can be fixed later
- Code style issues
- Missing comments
- Minor refactoring opportunities

**Suggestion**: Optional improvements
- Alternative approaches
- Future enhancements
- Code organization ideas

## Example Review Comments

### Good Comments
✅ "Consider using a Map instead of nested loops here for O(1) lookups. Current implementation is O(n²) which could be slow with large datasets."

✅ "This endpoint is missing authentication. Should we add the @RequireAuth decorator?"

✅ "Great use of the strategy pattern here! This makes adding new payment methods much easier."

### Bad Comments
❌ "This is wrong."
❌ "Why did you do it this way?"
❌ "I would have done X instead."

## Automated Checks

Run these before manual review:
```bash
# Linting
npm run lint

# Type checking
npm run type-check

# Tests
npm run test

# Security scan
npm audit

# Code coverage
npm run test:coverage
```

## Focus Areas by Language

### JavaScript/TypeScript
- Proper use of async/await
- No console.log in production
- TypeScript types used correctly
- React hooks rules followed

### Python
- PEP 8 compliance
- Type hints used
- Virtual environment used
- Requirements.txt updated

### Go
- Error handling (don't ignore errors)
- Proper defer usage
- Channel and goroutine safety
- Context usage for cancellation

### Rust
- Ownership rules followed
- No unsafe blocks without justification
- Error handling with Result/Option
- Lifetime annotations correct

## Post-Review

After review is complete:
- Mark as approved if all critical/major issues resolved
- Request changes if issues remain
- Follow up on suggested improvements
- Document any technical debt created
