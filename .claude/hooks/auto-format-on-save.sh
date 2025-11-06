#!/bin/bash
# Auto-Format On Save Hook
# Automatically formats code when files are saved

FILE=$1

# Detect file type and format accordingly
case "$FILE" in
    *.ts|*.tsx|*.js|*.jsx)
        if command -v prettier &> /dev/null; then
            prettier --write "$FILE"
        elif command -v eslint &> /dev/null; then
            eslint --fix "$FILE"
        fi
        ;;
    *.py)
        if command -v black &> /dev/null; then
            black "$FILE"
        fi
        if command -v isort &> /dev/null; then
            isort "$FILE"
        fi
        ;;
    *.go)
        gofmt -w "$FILE"
        if command -v goimports &> /dev/null; then
            goimports -w "$FILE"
        fi
        ;;
    *.rs)
        rustfmt "$FILE"
        ;;
    *.json)
        if command -v jq &> /dev/null; then
            jq '.' "$FILE" > "${FILE}.tmp" && mv "${FILE}.tmp" "$FILE"
        fi
        ;;
esac

echo "✓ Formatted: $FILE"
