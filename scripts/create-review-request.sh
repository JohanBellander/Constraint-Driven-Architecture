#!/bin/bash
# Helper script to create review request file

FEATURE_NAME=$1

if [ -z "$FEATURE_NAME" ]; then
    echo "Usage: ./scripts/create-review-request.sh <feature-name>"
    exit 1
fi

# Get list of changed files
CHANGED_FILES=$(git diff --name-only HEAD)

cat > .cda-review-request.md << EOF
# Architectural Review Request

## Feature: $FEATURE_NAME

## Files Changed:
$CHANGED_FILES

## Self-Check Results:
□ Code in correct layers
□ All files under 300 lines
□ No layer violations (checked all imports)
□ No duplication detected
□ Tests added for domain layer
□ Naming conventions followed

## Ready for architectural review.
EOF

echo "✅ Review request created: .cda-review-request.md"
echo "   Edit the self-check results, then run:"
echo "   ./scripts/request-copilot-review.sh"