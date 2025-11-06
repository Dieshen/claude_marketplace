#!/bin/bash
# Pre-Commit Quality Gate Hook
# Runs linting, type checking, and tests before allowing commit

set -e

echo "🔍 Running Pre-Commit Quality Gate..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track overall status
FAILED=0

# Function to run check and track failure
run_check() {
    local name=$1
    local command=$2
    
    echo -e "\n${YELLOW}Running $name...${NC}"
    if eval "$command"; then
        echo -e "${GREEN}✓ $name passed${NC}"
    else
        echo -e "${RED}✗ $name failed${NC}"
        FAILED=1
    fi
}

# Detect project type
if [ -f "package.json" ]; then
    PROJECT_TYPE="node"
elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
    PROJECT_TYPE="python"
elif [ -f "go.mod" ]; then
    PROJECT_TYPE="go"
elif [ -f "Cargo.toml" ]; then
    PROJECT_TYPE="rust"
else
    echo -e "${YELLOW}⚠ Unknown project type, skipping language-specific checks${NC}"
    PROJECT_TYPE="unknown"
fi

# Node.js/TypeScript checks
if [ "$PROJECT_TYPE" = "node" ]; then
    # Linting
    if grep -q "\"lint\"" package.json; then
        run_check "ESLint" "npm run lint"
    fi
    
    # Type checking
    if grep -q "\"type-check\"" package.json; then
        run_check "Type Checking" "npm run type-check"
    elif [ -f "tsconfig.json" ]; then
        run_check "TypeScript" "npx tsc --noEmit"
    fi
    
    # Tests
    if grep -q "\"test\"" package.json; then
        run_check "Tests" "npm run test"
    fi
    
    # Check for console.log in production code
    if git diff --cached --name-only | grep -E '\.(ts|tsx|js|jsx)$' | xargs grep -n "console\.log" 2>/dev/null; then
        echo -e "${YELLOW}⚠ Warning: console.log statements found${NC}"
    fi
fi

# Python checks
if [ "$PROJECT_TYPE" = "python" ]; then
    # Black formatting
    if command -v black &> /dev/null; then
        run_check "Black Formatting" "black --check ."
    fi
    
    # Flake8 linting
    if command -v flake8 &> /dev/null; then
        run_check "Flake8" "flake8 ."
    fi
    
    # mypy type checking
    if command -v mypy &> /dev/null; then
        run_check "mypy" "mypy ."
    fi
    
    # pytest
    if command -v pytest &> /dev/null; then
        run_check "pytest" "pytest"
    fi
fi

# Go checks
if [ "$PROJECT_TYPE" = "go" ]; then
    run_check "go fmt" "test -z \$(gofmt -l .)"
    run_check "go vet" "go vet ./..."
    run_check "go test" "go test ./..."
    
    # golangci-lint if available
    if command -v golangci-lint &> /dev/null; then
        run_check "golangci-lint" "golangci-lint run"
    fi
fi

# Rust checks
if [ "$PROJECT_TYPE" = "rust" ]; then
    run_check "cargo fmt" "cargo fmt -- --check"
    run_check "cargo clippy" "cargo clippy -- -D warnings"
    run_check "cargo test" "cargo test"
fi

# Check for secrets/API keys
echo -e "\n${YELLOW}Checking for secrets...${NC}"
if git diff --cached | grep -iE "(api[_-]?key|password|secret|token|private[_-]?key)" | grep -vE "(example|sample|test|mock)"; then
    echo -e "${RED}✗ Potential secrets found in commit${NC}"
    echo "Please remove sensitive data before committing"
    FAILED=1
else
    echo -e "${GREEN}✓ No secrets detected${NC}"
fi

# Check commit message
COMMIT_MSG_FILE=".git/COMMIT_EDITMSG"
if [ -f "$COMMIT_MSG_FILE" ]; then
    COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")
    if [ ${#COMMIT_MSG} -lt 10 ]; then
        echo -e "${YELLOW}⚠ Commit message seems short${NC}"
    fi
fi

# Summary
echo -e "\n${'=%.0s' {1..50}}"
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All quality checks passed!${NC}"
    echo "Commit allowed to proceed."
    exit 0
else
    echo -e "${RED}✗ Quality gate failed${NC}"
    echo "Please fix the issues above before committing."
    echo "To bypass (not recommended): git commit --no-verify"
    exit 1
fi
