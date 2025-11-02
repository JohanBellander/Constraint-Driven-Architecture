#!/bin/bash
# CDA Architectural Review via GitHub CoPilot CLI

set -e

echo "🔍 Preparing architectural review request..."

# Check if review request file exists
if [ ! -f ".cda-review-request.md" ]; then
    echo "❌ Error: .cda-review-request.md not found"
    echo "   Agent 1 should create this file before requesting review"
    exit 1
fi

# Build the review prompt
PROMPT=$(cat << 'EOF'
You are Agent 2 (Architect) - a senior architect reviewing code changes for CDA (Constraint-Driven Architecture) compliance.

# Your Role
Review code changes against explicit architectural constraints. Be objective, specific, and helpful.

# Rules to Enforce

## From CDA_MANIFEST.md:
EOF
)

# Append CDA rules
PROMPT="$PROMPT
$(cat CDA_MANIFEST.md)
"

# Append constitution
PROMPT="$PROMPT

## From CONSTITUTION.md:
$(cat CONSTITUTION.md)
"

# Append the review request
PROMPT="$PROMPT

## Review Request:
$(cat .cda-review-request.md)
"

# Append review instructions
PROMPT="$PROMPT

# Your Review Process

Check in this order:

1. LAYER BOUNDARIES (CRITICAL)
   - domain/ imports: NOTHING from src/
   - app/ imports: ONLY from domain/
   - infra/ imports: from domain/ and app/
   
   For each file, verify all import statements.

2. FILE SIZES (CRITICAL)
   - Every file must be ≤ 300 lines
   - No exceptions
   
   Count lines for each file listed.

3. CODE DUPLICATION (IMPORTANT)
   - Scan for repeated logic
   - Suggest extraction if found

4. NAMING CONVENTIONS (IMPORTANT)
   - Files: PascalCase
   - Folders: kebab-case
   - Tests: *.test.ts

5. PATTERNS (ADVISORY)
   - Consistency with existing code

# Output Format

If NO violations:
═══════════════════════════════════════════════════════════
CDA ARCHITECTURAL REVIEW
═══════════════════════════════════════════════════════════

Feature: [name]

LAYER BOUNDARIES: ✅ PASS
FILE SIZES: ✅ PASS
DUPLICATION: ✅ PASS
NAMING: ✅ PASS
PATTERNS: ✅ PASS

═══════════════════════════════════════════════════════════
VERDICT: APPROVED
═══════════════════════════════════════════════════════════

Summary: All CDA constraints satisfied. Ready to commit.

If violations found:
═══════════════════════════════════════════════════════════
CDA ARCHITECTURAL REVIEW
═══════════════════════════════════════════════════════════

Feature: [name]

VIOLATIONS FOUND: [count]

───────────────────────────────────────────────────────────

1. [TYPE] VIOLATION
   File: [path]
   Line: [number]
   
   Issue: [description]
   
   Fix Required: [specific steps]

═══════════════════════════════════════════════════════════
VERDICT: REJECTED
═══════════════════════════════════════════════════════════

Required Actions: [count] violations must be fixed.

# Be Specific
- Always include file:line
- Explain WHY it's a violation
- Show HOW to fix it with examples
- One violation = one numbered item

Now review the code changes.
EOF
"

# Save prompt to temp file for debugging (optional)
echo "$PROMPT" > .cda-review-prompt.txt

echo "📤 Sending to GitHub CoPilot for review..."
echo ""

# Call CoPilot with the prompt using the correct command
copilot --model gpt-5 -p "$PROMPT"

# Save response
copilot --model gpt-5 -p "$PROMPT" > .cda-review-response.md 2>&1

echo ""
echo "✅ Review complete. Results saved to .cda-review-response.md"
echo ""
echo "Next steps:"
echo "  - If APPROVED: commit your changes"
echo "  - If REJECTED: fix violations and resubmit"