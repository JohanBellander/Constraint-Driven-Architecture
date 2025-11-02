# Project Constitution

**Purpose**: This document defines the governance principles and architectural philosophy for this project.

---

## Core Principles

### 1. Architecture is Enforced, Not Documented
- Rules must be verifiable, not aspirational
- Violations are caught early, not in code review
- Structure is preserved through constraints, not discipline

### 2. Explicit Over Implicit
- Boundaries are clearly defined
- Patterns are documented and discoverable
- No "tribal knowledge" required

### 3. Fast Feedback Loops
- Problems caught immediately, not days later
- Local validation before push
- Agent gets clear, actionable error messages

### 4. Minimize Cognitive Load
- Each file has one clear purpose
- Each layer has strict boundaries
- Dependencies flow in one direction only

---

## Architectural Boundaries

### Layer Dependency Rules

```
┌─────────────────┐
│     Domain      │ ← Pure business logic, no dependencies
└────────┬────────┘
         │
┌────────▼────────┐
│       App       │ ← Can depend on Domain
└────────┬────────┘
         │
┌────────▼────────┐
│      Infra      │ ← Can depend on Domain & App
└─────────────────┘
```

**The Golden Rule**: Dependencies only flow downward (Infra → App → Domain)

**Why?**: 
- Domain logic stays pure and testable
- Business rules independent of infrastructure
- Easy to test without external dependencies
- Clear separation of concerns

---

## Governance Rules

### File Size Cap: 300 Lines
**Why**: Large files are hard to understand and maintain  
**What to do**: Split into multiple focused files  
**Exception**: None - refactor if you hit the limit

### No Code Duplication
**Why**: Changes need to happen in one place  
**What to do**: Extract shared logic to appropriate layer  
**Exception**: Tiny utilities (< 5 lines) can be duplicated if needed

### Every Public Function Needs Tests
**Why**: Prevents regressions and documents behavior  
**What to do**: Create tests alongside implementation  
**Exception**: Trivial getters/setters (use judgment)

### Layer Violations Are Blockers
**Why**: Once boundaries blur, architecture collapses  
**What to do**: Move code to correct layer  
**Exception**: None - architecture is non-negotiable

---

## Decision Framework

When unsure about an architectural decision, ask:

### 1. "Does this belong in the domain?"
- Is it pure business logic?
- Does it have no side effects?
- Could it work without any infrastructure?
→ **YES**: Put it in `domain/`
→ **NO**: Continue to #2

### 2. "Does this orchestrate other components?"
- Does it coordinate multiple domain objects?
- Does it handle request/response flow?
- Is it application-specific logic?
→ **YES**: Put it in `app/`
→ **NO**: Continue to #3

### 3. "Does it interact with external systems?"
- Does it talk to a database?
- Does it call an external API?
- Does it read/write files?
→ **YES**: Put it in `infra/`
→ **NO**: Re-evaluate - you might need `domain/` after all

---

## Evolution and Change

### Adding New Constraints
1. Propose in documentation first
2. Test with one feature
3. Update manifest if valuable
4. Apply to existing code gradually

### Relaxing Constraints
1. Document why constraint is problematic
2. Propose alternative approach
3. Update manifest if approved
4. Refactor existing violations

### Emergency Exceptions
Sometimes you need to break a rule:
1. Document why in code comments
2. Create a ticket to fix properly
3. Add `// TODO(CDA): [reason]` marker
4. Fix within 2 weeks

**Critical**: Exceptions should be rare and temporary.

---

## Measuring Success

We know CDA is working when:

✅ **Velocity stays constant** as project grows  
✅ **New features go in obvious places**  
✅ **No "where does this belong?" confusion**  
✅ **Architecture diagram matches reality**  
✅ **Onboarding takes < 1 hour**  
✅ **Agent effectiveness doesn't degrade**

We know CDA is failing when:

❌ Rules are routinely bypassed  
❌ "Just this once" becomes common  
❌ Architectural violations accumulate  
❌ Constraints feel bureaucratic, not helpful

---

## Enforcement Philosophy

### Humans
- Expected to follow rules voluntarily
- Code review checks for compliance
- Architectural decisions discussed openly

### AI Agents
- Must verify compliance before finishing
- Use self-check verification phase
- Flag violations immediately
- Learn from feedback

### Automation (Future)
- CI/CD runs validation scripts
- Blocks merges with violations
- Provides clear error messages
- No human gate-keeping needed

---

## Living Document

This constitution evolves with the project:
- Rules that don't help → Remove them
- New patterns emerge → Document them
- Constraints too strict → Adjust them
- Missing guidance → Add it

**Last Review**: 2025-11-02  
**Next Review**: As needed

---

## Getting Help

If you're stuck on an architectural decision:
1. Read this document
2. Check `CDA_MANIFEST.md` for specific rules
3. Look at existing examples in the codebase
4. Ask before implementing if still unsure

**Remember**: It's better to ask than to refactor later.
