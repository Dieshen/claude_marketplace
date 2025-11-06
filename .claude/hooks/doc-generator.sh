#!/bin/bash
# Documentation Generator Hook
# Automatically generates/updates documentation

echo "📚 Generating Documentation..."

# Generate API docs if OpenAPI spec exists
if [ -f "openapi.yaml" ] || [ -f "swagger.yaml" ]; then
    if command -v redoc-cli &> /dev/null; then
        redoc-cli bundle openapi.yaml -o docs/api.html
        echo "✓ API documentation generated"
    fi
fi

# Update README with API endpoints if available
if [ -f "package.json" ] && command -v swagger-jsdoc &> /dev/null; then
    npx swagger-jsdoc -d swaggerDef.js src/**/*.ts -o openapi.json
    echo "✓ OpenAPI spec generated"
fi

# Generate TypeScript docs
if [ -f "tsconfig.json" ] && command -v typedoc &> /dev/null; then
    typedoc --out docs/api src/
    echo "✓ TypeScript documentation generated"
fi

# Generate Python docs
if [ -f "pyproject.toml" ] && command -v pdoc &> /dev/null; then
    pdoc --html --output-dir docs/ src/
    echo "✓ Python documentation generated"
fi

# Update changelog if conventional commits
if git log -1 --pretty=%B | grep -E "^(feat|fix|docs|style|refactor|perf|test|chore)(\(.+\))?:"; then
    echo "✓ Conventional commit detected"
    # Could auto-update CHANGELOG.md here
fi

echo "✓ Documentation generation complete"
