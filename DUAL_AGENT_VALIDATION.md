# Dual-Agent Validation for CDA

**Enhanced CDA with automated architectural review using a second AI agent**

---

## Concept

Instead of relying on Agent 1 (Builder) to self-verify, we introduce Agent 2 (Architect) to provide independent validation.

```
Agent 1 (Builder)
    ↓ implements
    ↓ self-checks
    ↓
Agent 2 (Architect) ← Reviews against CDA rules
    ↓
Approved? → Commit
    ↓ No
Agent 1 fixes → Loop back to Agent 2
```

---

## How It Works

### Step 1: Agent 1 Implements
- Reads CDA_MANIFEST.md
- Implements feature
- Runs self-verification checklist
- Submits for architectural review

### Step 2: Agent 2 Reviews
- Receives code changes
- Reviews against CDA_MANIFEST.md and CONSTITUTION.md
- Checks layer boundaries, file sizes, duplication, naming
- Returns APPROVED or VIOLATIONS FOUND

### Step 3: Fix Loop (if needed)
- Agent 1 reads violations
- Makes corrections
- Resubmits to Agent 2
- Max 3 iterations, then escalate to human

---

## Agent 2 (Architect) Instructions

When you are acting as Agent 2 (the Architect/Reviewer), follow these instructions:

### Your Role
You are a senior architect reviewing code changes for CDA compliance. You are NOT implementing - only reviewing.

### Your Process

**1. Read the Rules**
- CDA_MANIFEST.md (architecture rules)
- CONSTITUTION.md (philosophy and governance)
- AI_AGENT_INSTRUCTIONS.md (patterns to check)

**2. Review the Changes**

Check in this order:

**A. Layer Boundaries** ⚠️ CRITICAL
```
Verify:
- domain/ imports from: NOTHING
- app/ imports from: domain only
- infra/ imports from: domain and app

For each file changed, check ALL import statements.
List violations with exact file:line numbers.
```

**B. File Sizes** ⚠️ CRITICAL
```
Check:
- Every file must be ≤ 300 lines
- Count includes blank lines and comments
- No exceptions

List violations with file:line_count
```

**C. Code Duplication** ⚠️ IMPORTANT
```
Scan for:
- Repeated logic across files
- Similar functions/components
- Copy-pasted code blocks

Suggest:
- Where to extract shared code
- What layer it belongs in
```

**D. Naming Conventions** ⚠️ IMPORTANT
```
Verify:
- Files: PascalCase.ts (User.ts, UserForm.tsx)
- Folders: kebab-case (user-management/)
- Tests: *.test.ts (User.test.ts)

List violations
```

**E. Pattern Consistency** ℹ️ ADVISORY
```
Compare with existing code:
- Does structure match established patterns?
- Are new patterns justified?
- Is consistency maintained?
```

**3. Provide Structured Feedback**

Use this exact format:

### If APPROVED:
```
═══════════════════════════════════════════════════════════
ARCHITECTURAL REVIEW - [Feature Name]
═══════════════════════════════════════════════════════════

LAYER BOUNDARIES: ✅ PASS
FILE SIZES: ✅ PASS
DUPLICATION: ✅ PASS
NAMING: ✅ PASS
PATTERNS: ✅ PASS

═══════════════════════════════════════════════════════════
VERDICT: APPROVED
═══════════════════════════════════════════════════════════

Summary: Changes comply with all CDA constraints.
Ready to commit.
```

### If VIOLATIONS FOUND:
```
═══════════════════════════════════════════════════════════
ARCHITECTURAL REVIEW - [Feature Name]
═══════════════════════════════════════════════════════════

VIOLATIONS FOUND: [number]

═══════════════════════════════════════════════════════════

1. [VIOLATION TYPE]
   File: [exact file path]
   Line: [line number or line count]
   Issue: [what's wrong]
   
   Fix Required:
   [Specific, actionable fix with examples]
   
2. [NEXT VIOLATION]
   ...

═══════════════════════════════════════════════════════════

LAYER BOUNDARIES: [✅/❌]
FILE SIZES: [✅/❌]
DUPLICATION: [✅/❌]
NAMING: [✅/❌]

═══════════════════════════════════════════════════════════
VERDICT: REJECTED
═══════════════════════════════════════════════════════════

Required Actions: [number] violations must be fixed

Next Step: Agent 1 should address violations and resubmit
```

---

## Agent 1 (Builder) Updated Workflow

When implementing with dual-agent validation, follow this workflow:

### Step 1: Implement (as normal)
1. Read CDA_MANIFEST.md
2. Check for existing code
3. Plan your approach
4. Implement the feature

### Step 2: Self-Check (as normal)
Run through verification checklist:
- [ ] Code in correct layers
- [ ] Files under 300 lines
- [ ] No layer violations
- [ ] No duplication
- [ ] Tests exist
- [ ] Naming conventions

### Step 3: Submit for Architectural Review ⭐ NEW

**Say this:**
```
I've completed implementation of [Feature]. 

Please review as Agent 2 (Architect) against CDA constraints:
- CDA_MANIFEST.md
- CONSTITUTION.md

Files changed:
[list all files created/modified]

Self-check: [report your verification results]

Ready for architectural review.
```

### Step 4: Process Review Response

**If APPROVED:**
- ✅ Done! Feature is complete

**If REJECTED:**
- Read each violation carefully
- Fix specific issues mentioned
- Don't argue or explain - just fix
- Resubmit for review (go back to Step 3)

### Step 5: Learn from Feedback
- Note patterns in violations
- Adjust approach for next feature
- Preemptively avoid similar issues

---

## Testing Dual-Agent Validation

### Test Project Setup

**Scenario:** Build a simple task management app with 3 features

**Features to implement:**
1. Task entity (simple CRUD)
2. Project entity (has tasks)
3. Timeline view (displays tasks/projects)

**Test objectives:**
- Does Agent 2 catch violations Agent 1 misses?
- Does Agent 1 learn from Agent 2 feedback?
- Is feedback specific and actionable?
- Does quality improve over features?

### Test Protocol

**For each feature:**

1. **Agent 1 implements** (as normal)
2. **Agent 1 self-checks** (runs checklist)
3. **Agent 1 submits for review** (explicitly asks for Agent 2)
4. **Agent 2 reviews** (you switch roles or use different AI)
5. **Track results:**
   - Was violation caught?
   - Was feedback clear?
   - How many iterations needed?
   - Did Agent 1 learn?

### Tracking Table

| Feature | Agent 1 Self-Check | Agent 2 Found Issues? | Iterations | Learning Shown? | Notes |
|---------|-------------------|----------------------|------------|-----------------|-------|
| Task    | ?                 | ?                    | ?          | N/A             |       |
| Project | ?                 | ?                    | ?          | ?               |       |
| Timeline| ?                 | ?                    | ?          | ?               |       |

---

## Expected Patterns

### Feature 1: Baseline
- Agent 1 may make mistakes
- Agent 2 catches them
- Multiple iterations likely

### Feature 2: Learning
- Agent 1 should make fewer mistakes
- Agent 2 may still catch issues
- Fewer iterations

### Feature 3: Mastery
- Agent 1 should anticipate violations
- Agent 2 approves quickly
- 1-2 iterations maximum

---

## Success Criteria

Dual-agent validation is working if:

✅ Agent 2 catches violations Agent 1 missed  
✅ Feedback is specific and actionable  
✅ Agent 1 learns from feedback (fewer violations over time)  
✅ Quality improves across features  
✅ Final code is cleaner than single-agent  

---

## When to Use Dual-Agent

**Use dual-agent validation when:**
- Quality is more important than speed
- Learning/training is a goal
- Building production systems
- Team is scaling
- Budget allows for extra AI calls

**Skip dual-agent when:**
- Prototyping/experimenting
- Time-critical work
- Budget-constrained
- Single agent is consistently compliant

---

## Implementation Options

### Option A: Manual Role-Switching
**You act as both agents:**
- First: Act as Agent 1 (Builder)
- Then: Act as Agent 2 (Architect)
- Switch explicitly between roles

### Option B: Two AI Instances
**Use different AI agents:**
- Agent 1: Claude (implementation)
- Agent 2: GPT-5 via CoPilot (review)
- Or two different Claude conversations

### Option C: Scripted Workflow
**Automate the handoff:**
```bash
# Agent 1 implements
claude "Implement task feature"

# Pass to Agent 2
./scripts/request-review.sh

# Agent 2 reviews
copilot "Review changes against CDA"

# Back to Agent 1 if needed
claude "Fix violations: [feedback]"
```

---

## Next Steps for Testing

1. **Choose test project** (task management app suggested)
2. **Decide on implementation** (manual, two AIs, or scripted)
3. **Set up tracking** (use table above)
4. **Run test** (3 features)
5. **Evaluate** (does dual-agent improve quality?)

---

## Questions Before Testing?

Before starting the test:
- Which implementation option? (manual/two AIs/scripted)
- What test project? (task app or something else)
- What's success criteria? (specific metrics to track)

---

**Ready to test dual-agent validation when you are!**
