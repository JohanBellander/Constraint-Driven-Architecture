# Instructions for AI Agents (with Dual-Agent Validation)

**READ THIS FIRST** before implementing any code in this project.

This project supports **optional Dual-Agent Validation** for enhanced quality control.

---

## Two Modes Available

### Mode 1: Single-Agent (Default)
- One AI agent implements and self-verifies
- You review manually
- Good for: prototyping, learning, small projects

### Mode 2: Dual-Agent Validation (Optional)
- Agent 1 (Builder) implements
- **Agent 1 EXECUTES CoPilot CLI script for automatic review**
- Agent 1 fixes based on feedback
- Good for: production code, team projects, learning

---

## Detecting Which Mode You're In

```bash
# Check if dual-agent scripts exist
if [ -f "./scripts/request-copilot-review.sh" ]; then
    echo "DUAL-AGENT MODE ENABLED"
    # You MUST use the dual-agent workflow
else
    echo "SINGLE-AGENT MODE"
    # Use manual review workflow
fi
```

**CRITICAL:** If `scripts/request-copilot-review.sh` exists, you are in DUAL-AGENT MODE and MUST follow that workflow.

---

## DUAL-AGENT MODE WORKFLOW ⭐ PRIMARY

### Step 1: Before Writing Code (Same as Single-Agent)

1. Read CDA_MANIFEST.md
2. Check for existing code
3. Read relevant contracts
4. Plan your approach

### Step 2: Implementation (Same as Single-Agent)

Follow layer rules strictly:
- domain/ - Pure logic, NO I/O, NO imports from app/infra
- app/ - Can import from domain ONLY
- infra/ - Can import from domain and app

File rules:
- Max 300 lines per file
- One responsibility per file
- No code duplication

### Step 3: Self-Verification

Run through checklist:
```
□ Read CDA_MANIFEST.md
□ Checked for existing similar code
□ All code in correct layer
□ No files exceed 300 lines
□ No layer violations (checked all imports)
□ No code duplication
□ Tests exist
□ Naming conventions followed
```

### Step 4: Create Review Request ⭐ EXECUTE THIS

**CRITICAL: You MUST actually RUN this command. Do NOT just say "run this". EXECUTE IT.**

```bash
./scripts/create-review-request.sh "Feature Name"
```

**Then edit `.cda-review-request.md`** to mark your self-check results:
- Change `□` to `✓` for completed items
- List all files you created/modified

### Step 5: Submit to Agent 2 (CoPilot) ⭐ EXECUTE THIS

**CRITICAL: You MUST actually RUN this command. This is NOT optional. This is NOT a suggestion.**

```bash
./scripts/request-copilot-review.sh
```

**DO NOT:**
- ❌ Say "run this command"
- ❌ Say "ready for review"
- ❌ Say "switch to Agent 2"
- ❌ Wait for human intervention
- ❌ Assume the command will fail
- ❌ Skip this step

**DO:**
- ✅ EXECUTE the command using bash
- ✅ Wait for the response
- ✅ Read the output
- ✅ Parse the verdict
- ✅ Continue based on result

**Example of what you should do:**

```bash
# EXECUTE THIS - Don't just show it
$ ./scripts/request-copilot-review.sh

# Wait for output...
# Read what CoPilot returns
# Show the verdict to the user
```

### Step 6: Process Agent 2 (CoPilot) Response ⭐ AUTOMATIC

**After executing the script, read the response:**

```bash
# The script saves CoPilot's response here
cat .cda-review-response.md
```

**Parse for the verdict:**

Look for these exact strings:
- `VERDICT: APPROVED` → Go to Step 8 (report completion)
- `VERDICT: REJECTED` → Go to Step 7 (fix violations)

**If neither found:**
- Show the full response to the user
- Ask for manual review
- Something went wrong with the script

### Step 7: Fix Violations (If REJECTED) ⭐ AUTOMATIC

**If Agent 2 rejected with violations:**

1. **Read each violation carefully** from `.cda-review-response.md`
2. **Make the specific fixes mentioned** - don't argue, just fix
3. **Update the code** to address each violation
4. **Update `.cda-review-request.md`** with changes made
5. **Go back to Step 5** - rerun `./scripts/request-copilot-review.sh`

**Maximum 3 iterations:**
- If still rejected after 3 tries → Escalate to human
- Report what's blocking approval

**Example violation fix flow:**

```
Agent 2 says: "File X exceeds 300 lines"
You do: Split file X into smaller files
Update review request
Rerun: ./scripts/request-copilot-review.sh
Agent 2 says: "APPROVED"
```

### Step 8: Report Completion (If APPROVED) ⭐ FINAL

**When Agent 2 approves, tell the user:**

```
✅ Implementation complete - CDA APPROVED by Agent 2 (CoPilot)

Feature: [Name]

Agent 2 Review: APPROVED

All CDA constraints satisfied:
✓ Layer boundaries respected
✓ File sizes within limits  
✓ No duplication
✓ Naming conventions followed

Files ready to commit:
[list files]

The implementation has passed automated architectural review.
```

**Do NOT just say "ready for review" or "implementation done".**
**Say explicitly that Agent 2 (CoPilot) APPROVED it.**

---

## CRITICAL EXECUTION RULES

### Rule 1: ALWAYS Execute Scripts in Dual-Agent Mode

If `scripts/request-copilot-review.sh` exists, you MUST:
1. Execute `./scripts/create-review-request.sh`
2. Execute `./scripts/request-copilot-review.sh`
3. Read the response
4. Act on the verdict

**Never skip script execution. Never assume it will fail.**

### Rule 2: Use Bash Tool to Execute

You have access to bash commands. Use them:

```bash
# This is how you execute commands:
bash_tool({
  "command": "./scripts/request-copilot-review.sh",
  "description": "Running Agent 2 architectural review via CoPilot CLI"
})
```

**Actually execute. Don't simulate.**

### Rule 3: Parse Responses Programmatically

```bash
# Read the response file
cat .cda-review-response.md

# Look for verdict
grep "VERDICT:" .cda-review-response.md
```

**Don't assume. Read and parse the actual file.**

### Rule 4: Iterate Automatically

```
Loop:
  Execute review script
  Read response
  If APPROVED: break, report success
  If REJECTED: fix violations, continue loop
  If unclear: show to user, ask for help
  
Max iterations: 3
```

**Handle the full loop automatically.**

---

## Example: Complete Dual-Agent Session

```bash
# Agent 1: Implement
[creates files...]

# Agent 1: Self-check
[verifies against rules...]

# Agent 1: Create review request
$ ./scripts/create-review-request.sh "Contact Entity"
✅ Review request created

# Agent 1: Edit review request
[marks checkboxes in .cda-review-request.md]

# Agent 1: Submit to Agent 2
$ ./scripts/request-copilot-review.sh
🔍 Preparing architectural review...
📤 Sending to CoPilot...

[CoPilot response...]

═══════════════════════════════════════════════════════════
VERDICT: REJECTED
═══════════════════════════════════════════════════════════

VIOLATIONS FOUND: 1

1. FILE SIZE VIOLATION
   File: src/app/ContactForm.tsx
   Line Count: 315
   Fix: Split into ContactForm.tsx and ContactFormFields.tsx

# Agent 1: Fix violation
[splits the file...]

# Agent 1: Resubmit
$ ./scripts/request-copilot-review.sh
🔍 Preparing architectural review...
📤 Sending to CoPilot...

═══════════════════════════════════════════════════════════
VERDICT: APPROVED
═══════════════════════════════════════════════════════════

# Agent 1: Report
✅ Implementation complete - CDA APPROVED by Agent 2 (CoPilot)
```

**This entire flow is automatic. No human intervention needed.**

---

## SINGLE-AGENT MODE WORKFLOW (Fallback)

**Only use this if `scripts/request-copilot-review.sh` does NOT exist.**

### Steps 1-3: Same as Dual-Agent

(Before writing code, implementation, self-verification)

### Step 4: Report Completion

Tell the user:

```
Implementation complete.

Self-verification checklist:
✓ All items checked

Ready for manual review.

Please review the following files:
[list files]
```

**Then wait for human feedback.**

---

## Common Mistakes to Avoid

### ❌ WRONG: Just Saying "Run This"

```
User, please run: ./scripts/request-copilot-review.sh
```

**This is WRONG. You should execute it yourself.**

### ✅ RIGHT: Actually Executing

```bash
$ ./scripts/request-copilot-review.sh
[shows output]
[reads response]
[acts on verdict]
```

---

### ❌ WRONG: Assuming It Will Fail

```
The script requires Node.js which may not be installed, so I'll do manual review...
```

**This is WRONG. Try to execute it. Let it fail if it fails. Show the actual error.**

### ✅ RIGHT: Try and Show Results

```bash
$ ./scripts/request-copilot-review.sh
# If error: show actual error message
# If success: show CoPilot's response
```

---

### ❌ WRONG: Stopping at "Ready for Review"

```
Implementation complete. Ready for architectural review.
```

**This is WRONG in dual-agent mode. Execute the review script.**

### ✅ RIGHT: Execute and Report Result

```bash
$ ./scripts/request-copilot-review.sh
[execute, read response, act on it]
✅ CDA APPROVED by Agent 2
```

---

## Detecting Execution Capability

You CAN execute bash commands if:
- You have bash_tool available
- You created files using file_create
- You're in an environment that supports command execution

**Test this at the start:**

```bash
# Quick test
ls -la scripts/
# If this works, you CAN execute the review script
```

**If bash execution is truly not available:**
- Tell the user explicitly
- Provide the exact command they need to run
- Explain you cannot execute it automatically
- Ask them to run it and paste the result

---

## Troubleshooting

### Issue: "Command not found: copilot"

**Response:**
```bash
# Test if copilot is installed
which copilot

# If not found, tell user:
"CoPilot CLI is not installed. Please install it first or use single-agent mode."

# Show them COPILOT_SETUP.md
```

### Issue: Script fails with error

**Response:**
```bash
# Show the actual error
"Script execution failed with error:
[show actual error message]

Please check:
1. Is CoPilot CLI installed? (copilot --version)
2. Are you authenticated? (gh auth status)  
3. Is the script executable? (chmod +x scripts/*.sh)

Or use single-agent mode for now."
```

### Issue: Response parsing fails

**Response:**
```bash
# Show the full response
"CoPilot returned this response:
[show .cda-review-response.md contents]

I cannot parse the VERDICT. Please review manually."
```

---

## Summary: Key Behavioral Changes

**Old behavior (WRONG):**
```
Implement → Self-check → Say "ready for review" → Wait for human
```

**New behavior (RIGHT):**
```
Implement → Self-check → Execute review script → Read verdict → 
  If APPROVED: report completion
  If REJECTED: fix and loop back
```

**The key difference: EXECUTE, don't wait.**

---

## Final Checklist for Agent 1

Before saying you're done:

```
□ Implemented the feature
□ Self-verified against CDA rules
□ Created review request (.cda-review-request.md)
□ EXECUTED ./scripts/request-copilot-review.sh
□ READ the response from CoPilot
□ PARSED the verdict (APPROVED/REJECTED)
□ If REJECTED: FIXED violations and re-executed
□ If APPROVED: REPORTED completion with Agent 2 approval
```

**All checkboxes must be ✓ before you're done.**

---

**Remember: In dual-agent mode, you are responsible for the entire review loop, not just implementation.**