# CDA Quick Start Guide

Get started with Constraint-Driven Architecture in 5 minutes.

---

## For Humans (Quick Reference)

### Project Structure
```
src/
├─ domain/     # Business logic (pure, no I/O)
├─ app/        # Orchestration (uses domain)
└─ infra/      # External systems (database, APIs)
```

### Golden Rules
1. **Dependencies flow down**: infra → app → domain
2. **Max 300 lines per file**
3. **No duplication**
4. **Domain = pure logic only**

### Quick Decisions
- Pure logic? → `domain/`
- Coordinating things? → `app/`
- Talking to database/API? → `infra/`

---

## For AI Agents (Quick Reference)

### Before Coding
1. ✅ Read `CDA_MANIFEST.md`
2. ✅ Search for existing code
3. ✅ Check `contracts/` folder
4. ✅ Plan which layer(s)

### While Coding
1. ✅ Follow layer rules
2. ✅ Keep files < 300 lines
3. ✅ No duplication
4. ✅ Add tests

### After Coding
```
Run verification checklist from AI_AGENT_INSTRUCTIONS.md
```

---

## Testing the System

### Day 1: Setup
1. Add these files to your project:
   - `CDA_MANIFEST.md`
   - `CONSTITUTION.md`
   - `AI_AGENT_INSTRUCTIONS.md`
   - `QUICK_START.md` (this file)

2. Create basic structure:
   ```bash
   mkdir -p src/{domain,app,infra}
   mkdir -p contracts
   mkdir -p tests
   ```

### Day 2-7: First Feature with Agent

**Test 1: Discovery**
- Ask agent: "Implement user authentication"
- **Expected**: Agent reads CDA_MANIFEST.md first
- **Watch for**: Does it check for existing code?

**Test 2: Layer Compliance**
- **Expected**: 
  - Domain logic in `src/domain/`
  - Handlers in `src/app/`
  - Database in `src/infra/`
- **Watch for**: Layer violations in imports

**Test 3: Size Constraints**
- **Expected**: No files exceed 300 lines
- **Watch for**: Large files that should be split

**Test 4: Duplication**
- Add a second feature
- **Expected**: Reuses existing code
- **Watch for**: Copy-pasted logic

**Test 5: Verification**
- **Expected**: Agent runs checklist before saying "done"
- **Watch for**: Skipping verification step

---

## Tracking Results

Use this simple table to track your test week:

| Day | Feature | Read Manifest? | Correct Layers? | Size OK? | No Duplication? | Ran Checklist? | Notes |
|-----|---------|----------------|-----------------|----------|-----------------|----------------|-------|
| 1   |         | ☐              | ☐               | ☐        | ☐               | ☐              |       |
| 2   |         | ☐              | ☐               | ☐        | ☐               | ☐              |       |
| 3   |         | ☐              | ☐               | ☐        | ☐               | ☐              |       |
| 4   |         | ☐              | ☐               | ☐        | ☐               | ☐              |       |
| 5   |         | ☐              | ☐               | ☐        | ☐               | ☐              |       |

### Success Metrics
- ✅ **80%+ compliance** → Markdown is working, continue with this
- ⚠️ **50-79% compliance** → Add validation scripts (Medium CDA)
- ❌ **<50% compliance** → Rules unclear or agent ignoring them

---

## Common First-Week Issues

### Issue: Agent doesn't read manifest
**Solution**: Explicitly say "Read CDA_MANIFEST.md first"

### Issue: Agent creates wrong structure
**Solution**: Reference AI_AGENT_INSTRUCTIONS.md in your prompt

### Issue: Agent violates layers constantly
**Solution**: Rules might be unclear - refine manifest

### Issue: Agent asks too many questions
**Solution**: Good sign! It's being careful. Refine docs to answer common questions.

### Issue: Agent ignores verification checklist
**Solution**: Explicitly ask "Run the verification checklist"

---

## Week 1 Retrospective Questions

After 1 week, answer these:

1. **Did structure stay clean?**
   - Yes → CDA is working
   - No → Why? (Agent ignoring rules? Rules unclear?)

2. **Did agent effectiveness degrade?**
   - No → Good sign
   - Yes → Why? (Context? Complexity?)

3. **How often did you manually correct violations?**
   - Rarely → Markdown is sufficient
   - Often → Need validation scripts

4. **What rules were most violated?**
   - Layer boundaries? → Make clearer
   - File size? → Agent doesn't prioritize this
   - Duplication? → Need automated detection

5. **Did you spend more time on structure or logic review?**
   - Logic → CDA working as intended
   - Structure → Need better enforcement

---

## Next Steps Decision Tree

```
After 1 week:

Did CDA help? ────┬── No → Refine rules and try 1 more week
                  │
                  └── Yes → Was compliance good?
                            │
                            ├── Yes (>80%) → Keep using markdown only
                            │
                            └── No (<80%) → Add validation scripts
                                            (Medium CDA)
```

---

## Getting Help

**Stuck on setup?**
- Review project structure in CDA_MANIFEST.md
- Start with one simple feature
- Don't over-engineer initially

**Agent not following rules?**
- Check: Are rules clear and specific?
- Check: Did you tell agent to read the manifest?
- Try: Different phrasing in your prompts

**Unsure what rules to enforce?**
- Start with: Layer boundaries + file size
- Add more as you discover what matters

**Ready for more enforcement?**
- See: "Medium CDA" in original discussion
- Add: Validation scripts
- Integrate: Into git hooks or CI/CD

---

## Contact & Feedback

Track your experience:
- What worked well?
- What was confusing?
- What rules helped most?
- What rules were annoying?

Use this feedback to refine your CDA setup.

---

## Remember

**This is a test.** Don't over-invest yet.

The goal this week:
- See if explicit constraints help
- Learn what rules matter
- Decide if you need more enforcement

**Start simple. Iterate based on results.**
