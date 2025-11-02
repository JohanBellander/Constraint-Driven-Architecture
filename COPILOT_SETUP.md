# Setting Up GitHub CoPilot CLI for Dual-Agent Validation

**Complete guide to setting up Agent 2 (Architect) using GitHub CoPilot CLI**

---

## What is This?

GitHub CoPilot CLI allows you to invoke AI (GPT-4/5) from the command line. We use it as **Agent 2 (Architect)** to automatically review code changes against CDA constraints.

```
Agent 1 (Claude/ChatGPT) → Implements → Submits
                                          ↓
Agent 2 (CoPilot CLI)     ← Reviews    ← Changes
                                          ↓
Agent 1                   ← Fixes      ← Violations
```

---

## Prerequisites

1. **GitHub Account** with CoPilot subscription
   - Individual ($10/month) or Enterprise
   - Includes CoPilot CLI access

2. **GitHub CLI** (gh) installed
   - macOS: `brew install gh`
   - Windows: `winget install GitHub.cli`
   - Linux: See https://github.com/cli/cli#installation

3. **Node.js** (for running scripts)
   - Version 16+ recommended
   - Install from https://nodejs.org/

---

## Installation Steps

### Step 1: Install GitHub CLI

```bash
# macOS
brew install gh

# Windows (PowerShell as Admin)
winget install GitHub.cli

# Linux (Debian/Ubuntu)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
```

**Verify installation:**
```bash
gh --version
# Should show: gh version 2.x.x or higher
```

### Step 2: Authenticate with GitHub

```bash
gh auth login
```

**Follow the prompts:**
1. Choose: `GitHub.com`
2. Choose: `HTTPS`
3. Authenticate: `Login with a web browser`
4. Copy the code shown
5. Press Enter to open browser
6. Paste code and authorize

**Verify authentication:**
```bash
gh auth status
# Should show: Logged in to github.com as [your-username]
```

### Step 3: Install CoPilot CLI Extension

```bash
gh extension install github/gh-copilot
```

**Verify installation:**
```bash
gh copilot --version
# Should show version info
```

### Step 4: Test CoPilot CLI

```bash
gh copilot suggest "How do I list files in bash?"
```

**You should see:**
- AI-generated bash command suggestions
- If this works, CoPilot CLI is ready!

---

## Project Setup

### Step 1: Add Review Script to Your Project

Create `scripts/request-copilot-review.sh`:

```bash
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

# Call CoPilot with the prompt
copilot --model gpt-5 -p "$PROMPT"

# Save response
copilot --model gpt-5 -p "$PROMPT" > .cda-review-response.md 2>&1

echo ""
echo "✅ Review complete. Results saved to .cda-review-response.md"
echo ""
echo "Next steps:"
echo "  - If APPROVED: commit your changes"
echo "  - If REJECTED: fix violations and resubmit"
```

**Make it executable:**
```bash
chmod +x scripts/request-copilot-review.sh
```

### Step 2: Add Helper Scripts

Create `scripts/create-review-request.sh`:

```bash
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
```

**Make it executable:**
```bash
chmod +x scripts/create-review-request.sh
```

### Step 3: Add to .gitignore

Add these files to `.gitignore`:

```
# CDA Review files (temporary)
.cda-review-request.md
.cda-review-response.md
.cda-review-prompt.txt
```

---

## Usage Workflow

### Agent 1 (Builder) Workflow:

**1. Implement Feature**
```bash
# Code as normal following CDA_MANIFEST.md
```

**2. Create Review Request**
```bash
./scripts/create-review-request.sh "User Authentication"
```

**3. Edit Review Request**
```bash
# Open .cda-review-request.md
# Fill in self-check checkboxes
# Update file list if needed
```

**4. Request Review**
```bash
./scripts/request-copilot-review.sh
```

**5. Read Review Response**
```bash
cat .cda-review-response.md
```

**6. If APPROVED → Commit**
```bash
git add .
git commit -m "feat: add user authentication (CDA approved)"
```

**7. If REJECTED → Fix and Resubmit**
```bash
# Fix the violations listed
# Update .cda-review-request.md
# Run ./scripts/request-copilot-review.sh again
```

---

## Example Session

```bash
# Agent 1 implements
$ git add src/domain/user/
$ git add src/app/users/
$ git add src/infra/user-api.ts

# Create review request
$ ./scripts/create-review-request.sh "User Management"
✅ Review request created: .cda-review-request.md

# Edit and check boxes
$ nano .cda-review-request.md

# Request review from Agent 2 (CoPilot)
$ ./scripts/request-copilot-review.sh

🔍 Preparing architectural review request...
📤 Sending to GitHub CoPilot for review...

═══════════════════════════════════════════════════════════
CDA ARCHITECTURAL REVIEW
═══════════════════════════════════════════════════════════

Feature: User Management

VIOLATIONS FOUND: 1

───────────────────────────────────────────────────────────

1. FILE SIZE VIOLATION
   File: src/app/users/UserForm.tsx
   Line Count: 315
   Limit: 300
   
   Issue: Form component exceeds maximum file size.
   
   Fix Required: Split into UserForm.tsx (main, ~150 lines)
   and UserFormFields.tsx (fields, ~150 lines)

═══════════════════════════════════════════════════════════
VERDICT: REJECTED
═══════════════════════════════════════════════════════════

Required Actions: 1 violation must be fixed.

✅ Review complete. Results saved to .cda-review-response.md

# Fix the violation
$ # ... split UserForm.tsx ...

# Resubmit
$ ./scripts/request-copilot-review.sh

═══════════════════════════════════════════════════════════
CDA ARCHITECTURAL REVIEW
═══════════════════════════════════════════════════════════

Feature: User Management

LAYER BOUNDARIES: ✅ PASS
FILE SIZES: ✅ PASS
DUPLICATION: ✅ PASS
NAMING: ✅ PASS
PATTERNS: ✅ PASS

═══════════════════════════════════════════════════════════
VERDICT: APPROVED
═══════════════════════════════════════════════════════════

✅ Review complete. Ready to commit!

# Commit
$ git commit -m "feat: add user management (CDA approved)"
```

---

## Troubleshooting

### Issue: `gh: command not found`

**Solution:**
```bash
# Reinstall GitHub CLI
# macOS
brew install gh

# Verify
which gh
```

### Issue: `gh: not logged in`

**Solution:**
```bash
gh auth login
# Follow prompts
```

### Issue: `gh copilot: command not found`

**Solution:**
```bash
# Install CoPilot extension
gh extension install github/gh-copilot

# Verify
gh copilot --version
```

### Issue: CoPilot subscription required

**Solution:**
- Sign up for GitHub CoPilot at https://github.com/features/copilot
- Individual: $10/month
- Need GitHub account

### Issue: Review script permission denied

**Solution:**
```bash
chmod +x scripts/request-copilot-review.sh
chmod +x scripts/create-review-request.sh
```

### Issue: CoPilot API rate limits

**Solution:**
- Wait a few minutes between reviews
- CoPilot has rate limits
- If hitting limits frequently, batch multiple changes

---

## Cost Considerations

**GitHub CoPilot Subscription:**
- Individual: $10/month
- Includes CLI access
- Unlimited suggestions (with rate limits)

**Per Review:**
- No additional per-use cost
- Included in subscription
- Each review is one API call

**Compared to Manual Review:**
- Instant feedback vs waiting for human
- Consistent application of rules
- Worth it for production code

---

## Alternatives if CoPilot Not Available

### Option 1: Use ChatGPT/Claude Web Interface
```bash
# Export review request
cat .cda-review-request.md

# Copy/paste into ChatGPT or Claude
# Manually copy response back
```

### Option 2: Manual Review
```bash
# Review yourself using CDA_MANIFEST.md
# Check off the verification list
# Skip automated Agent 2
```

### Option 3: Script with Other AI APIs
```bash
# Use OpenAI API directly
# Use Anthropic API
# Requires API key and scripting
```

---

## Testing the Setup

### Quick Test

```bash
# Test CoPilot CLI works
gh copilot suggest "list files"

# Should show bash commands
# If this works, you're ready!
```

### Full Test with CDA Review

```bash
# Create a test file
mkdir -p src/domain/test
echo "export class Test {}" > src/domain/test/Test.ts

# Create review request
./scripts/create-review-request.sh "Test Feature"

# Request review
./scripts/request-copilot-review.sh

# Should get an architectural review response
```

---

## Next Steps

1. ✅ Install GitHub CLI
2. ✅ Authenticate with GitHub
3. ✅ Install CoPilot CLI extension
4. ✅ Add scripts to your project
5. ✅ Test with a simple feature
6. ✅ Start using dual-agent validation!

---

**You're now ready to use CoPilot as Agent 2 (Architect) for automated CDA reviews!**

For usage examples and workflows, see `DUAL_AGENT_VALIDATION.md`
