# CDA Manifest

**Version**: 1.0  
**Last Updated**: 2025-11-02

This document defines the architectural rules and constraints for this project. All developers and AI agents must follow these rules.

---

## Project Structure

```
project/
├─ src/
│  ├─ domain/        # Business logic, entities, pure functions
│  ├─ app/           # Application layer, handlers, use cases
│  ├─ infra/         # Infrastructure, database, external APIs
│  └─ types/         # Generated types (READ-ONLY)
├─ contracts/        # API specs, schemas, interfaces
├─ tests/            # Test files mirror src/ structure
└─ docs/             # Documentation
```

---

## Layer Rules

### Domain Layer (`src/domain/`)
- ✅ Pure business logic
- ✅ Entities, value objects, domain services
- ✅ No side effects
- ❌ NO I/O operations (no database, no HTTP, no file system)
- ❌ NO imports from `app/` or `infra/`

### App Layer (`src/app/`)
- ✅ Orchestration, use cases, handlers
- ✅ Can import from `domain/`
- ❌ NO direct database queries (use infra layer)
- ❌ NO imports from `infra/`

### Infra Layer (`src/infra/`)
- ✅ Database access, external APIs, file system
- ✅ Can import from `domain/` and `app/`
- ✅ Implements interfaces defined in domain

---

## File Constraints

- **Max 300 lines per file** - Split if larger
- **Max 10 cyclomatic complexity per function** - Simplify if higher
- **One primary responsibility per file** - Single purpose
- **No code duplication** - Extract to shared function if repeated

---

## Naming Conventions

```
Files:    PascalCase.ts (e.g., UserService.ts)
Folders:  kebab-case (e.g., user-management/)
Tests:    *.test.ts (e.g., UserService.test.ts)
Contracts: kebab-case.yaml (e.g., user-api.yaml)
```

---

## Agent Workflow (IMPORTANT)

When implementing a feature, follow these steps **in order**:

### 1. Discovery Phase
```
Before writing any code:
- Check if similar functionality already exists
- Read relevant contracts in contracts/
- Identify which layer(s) this belongs in
```

### 2. Planning Phase
```
Decide:
- What files need to be created/modified?
- Which layer does each file belong to?
- What's the smallest change that works?
```

### 3. Implementation Phase
```
- Create files in the correct layer
- Keep files under 300 lines
- Follow naming conventions
- Add only necessary code (no speculative features)
```

### 4. Verification Phase
```
Self-check before finishing:
□ Code is in the correct layer
□ No files exceed 300 lines
□ No layer rule violations (check imports)
□ No obvious code duplication
□ Tests exist for new functionality
□ All names follow conventions
```

---

## Common Patterns

### Creating a New Feature
1. Check `contracts/` for relevant specs
2. Create domain entities/logic in `src/domain/`
3. Create handlers/use cases in `src/app/`
4. Create infrastructure adapters in `src/infra/`
5. Create tests in `tests/` mirroring structure

### Modifying Existing Feature
1. Find existing files (use search, don't guess)
2. Read the current implementation
3. Make minimal change
4. Update tests
5. Verify no layer violations introduced

### Extracting Shared Logic
If you see duplicated code:
1. Extract to shared function
2. Place in appropriate layer (usually domain)
3. Update all call sites
4. Add tests for extracted function

---

## Red Flags 🚩

If you see these, stop and reconsider:

- 🚩 Domain layer importing from app or infra
- 🚩 Multiple files doing the same thing
- 🚩 File approaching 300 lines
- 🚩 Function with deeply nested logic
- 🚩 Business logic in infrastructure layer
- 🚩 Database queries in app layer

---

## Quick Reference

**Before implementing:**
1. Read this manifest
2. Check contracts/
3. Search for existing implementations

**While implementing:**
1. Stay in correct layer
2. Keep files small
3. No duplication

**After implementing:**
1. Run verification checklist
2. Confirm layer boundaries respected
3. Ensure tests exist

---

## Questions?

If unsure about where something belongs:
1. **Pure logic?** → `domain/`
2. **Orchestrating logic?** → `app/`
3. **Talking to external systems?** → `infra/`

When in doubt, ask before implementing.
