# Security Audit Workflow

Perform a comprehensive security audit of the codebase.

## Security Checks

1. **Secrets Detection**
   - Scan for hardcoded API keys
   - Check for passwords in code
   - Identify exposed tokens

2. **Dependency Vulnerabilities**
   - Run npm audit / pip check
   - Check for known CVEs
   - Identify outdated dependencies

3. **Code Security**
   - SQL injection vulnerabilities
   - XSS vulnerabilities
   - CSRF protection
   - Input validation
   - Authentication/authorization issues

4. **Configuration Security**
   - Insecure default configurations
   - Missing security headers
   - Weak encryption settings

5. **Best Practices**
   - Proper error handling
   - Secure session management
   - Password policies
   - Rate limiting

## Output

Provide a security report with:
- Severity rating (Critical, High, Medium, Low)
- Vulnerability description
- Affected files/lines
- Remediation steps
- OWASP/CWE references
