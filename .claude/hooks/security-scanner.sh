#!/bin/bash
# Security Scanner Hook
# Scans code for vulnerabilities and security issues

echo "🔒 Running Security Scan..."

ISSUES_FOUND=0

# Check for hardcoded secrets
echo "Checking for secrets..."
if git diff --cached | grep -iE "(password|api[_-]?key|secret|token|private[_-]?key)\s*=\s*['\"]" | grep -v "example\|sample\|test"; then
    echo "⚠ Potential hardcoded secrets found"
    ISSUES_FOUND=1
fi

# Node.js security
if [ -f "package.json" ]; then
    echo "Running npm audit..."
    npm audit --audit-level=high || ISSUES_FOUND=1
fi

# Python security
if [ -f "requirements.txt" ]; then
    echo "Running safety check..."
    if command -v safety &> /dev/null; then
        safety check || ISSUES_FOUND=1
    fi
fi

# Check for common security issues
echo "Checking for security anti-patterns..."

# SQL injection patterns
if git diff --cached | grep -E "execute.*\+|query.*\+|SELECT.*\+"; then
    echo "⚠ Potential SQL injection vulnerability"
    ISSUES_FOUND=1
fi

# XSS patterns
if git diff --cached | grep -E "innerHTML|dangerouslySetInnerHTML" | grep -v "sanitize"; then
    echo "⚠ Potential XSS vulnerability"
    ISSUES_FOUND=1
fi

if [ $ISSUES_FOUND -eq 0 ]; then
    echo "✓ No security issues found"
    exit 0
else
    echo "⚠ Security issues detected - please review"
    exit 1
fi
