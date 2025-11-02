# Instructions for AI Agents

**READ THIS FIRST** before implementing any code in this project.

---

## Your Role

You are working in a **Constraint-Driven Architecture (CDA)** project. This means:
- Architecture rules are explicit and must be followed
- Structure is more important than speed
- Quality gates are non-negotiable

---

## Mandatory Workflow

### Step 1: Before Writing ANY Code

**STOP and do this first:**

1. **Read the manifest**
   ```
   Open and read: CDA_MANIFEST.md
   ```

2. **Check for existing code**
   ```
   Search the codebase: Does this already exist?
   If YES: Extend existing code, don't duplicate
   If NO: Proceed to step 3
   ```

3. **Read relevant contracts**
   ```
   Check: contracts/ folder
   Read: Any specs related to this feature
   ```

4. **Plan your approach**
   ```
   Answer:
   - Which layer does this belong in? (domain/app/infra)
   - What files will I create/modify?
   - Is this the minimal change needed?
   ```

### Step 2: Implementation

Follow these rules **strictly**:

```yaml
Layer Rules:
  domain/:
    - Pure logic only
    - NO imports from app/ or infra/
    - NO I/O operations
    - NO side effects
  
  app/:
    - Can import from domain/
    - NO imports from infra/
    - Orchestration and use cases only
  
  infra/:
    - Can import from domain/ and app/
    - All external system interactions
    - Database, APIs, file system

File Rules:
  - Max 300 lines per file
  - One responsibility per file
  - No code duplication
  - Clear, descriptive names
```

### Step 3: Verification (DO NOT SKIP)

Before you say "I'm done", run through this checklist:

```
□ I have read CDA_MANIFEST.md
□ I checked for existing similar code
□ All code is in the correct layer
□ No files exceed 300 lines
□ No layer violations (I checked all imports)
□ No obvious code duplication
□ Tests exist for new functionality
□ All file names follow conventions
```

**If ANY checkbox is unchecked, you're not done.**

---

## Common Mistakes to Avoid

### ❌ Don't Do This

```typescript
// DON'T: Domain importing from infra
// File: src/domain/User.ts
import { database } from '../infra/database';

export class User {
  async save() {
    await database.users.insert(this); // ❌ I/O in domain!
  }
}
```

### ✅ Do This Instead

```typescript
// DO: Keep domain pure
// File: src/domain/User.ts
export class User {
  constructor(
    public id: string,
    public name: string,
    public email: string
  ) {}
  
  validate(): boolean {
    return this.email.includes('@'); // ✅ Pure logic
  }
}

// File: src/infra/UserRepository.ts
import { User } from '../domain/User';
import { database } from './database';

export class UserRepository {
  async save(user: User): Promise<void> {
    await database.users.insert(user); // ✅ I/O in infra
  }
}
```

---

## Layer Decision Tree

Use this to decide where code belongs:

```
Is it pure business logic with no side effects?
├─ YES → domain/
└─ NO → Does it orchestrate multiple components?
    ├─ YES → app/
    └─ NO → Does it interact with external systems?
        ├─ YES → infra/
        └─ NO → You probably need domain/ (re-evaluate)
```

---

## When Files Get Too Large

If a file approaches 300 lines:

### Option 1: Split by Responsibility
```
UserService.ts (350 lines) →
  ├─ UserService.ts (150 lines)      # Core service
  ├─ UserValidation.ts (100 lines)   # Validation logic
  └─ UserTransforms.ts (100 lines)   # Data transformations
```

### Option 2: Extract Utilities
```
OrderProcessor.ts (400 lines) →
  ├─ OrderProcessor.ts (200 lines)   # Main processor
  └─ utils/
      ├─ price-calculator.ts (100 lines)
      └─ tax-calculator.ts (100 lines)
```

### Option 3: Create Sub-modules
```
payment/
  ├─ PaymentProcessor.ts (320 lines) →
      ├─ PaymentProcessor.ts (150 lines)
      ├─ CreditCardHandler.ts (80 lines)
      └─ PayPalHandler.ts (90 lines)
```

---

## Handling Duplication

If you see duplicated code:

### Step 1: Identify the Pattern
```typescript
// Found in: src/app/UserHandler.ts
if (!email.includes('@')) {
  throw new Error('Invalid email');
}

// Also found in: src/app/OrderHandler.ts
if (!email.includes('@')) {
  throw new Error('Invalid email');
}
```

### Step 2: Extract to Shared Location
```typescript
// Create: src/domain/validation/email.ts
export function validateEmail(email: string): void {
  if (!email.includes('@')) {
    throw new Error('Invalid email');
  }
}
```

### Step 3: Update Call Sites
```typescript
// Update: src/app/UserHandler.ts
import { validateEmail } from '../domain/validation/email';
validateEmail(email);

// Update: src/app/OrderHandler.ts
import { validateEmail } from '../domain/validation/email';
validateEmail(email);
```

---

## Testing Requirements

Every new public function needs a test:

```typescript
// File: src/domain/User.ts
export class User {
  validate(): boolean {
    return this.email.includes('@');
  }
}

// File: tests/domain/User.test.ts
import { User } from '../../src/domain/User';

describe('User', () => {
  it('validates email correctly', () => {
    const user = new User('1', 'John', 'john@example.com');
    expect(user.validate()).toBe(true);
  });
  
  it('rejects invalid email', () => {
    const user = new User('1', 'John', 'invalid-email');
    expect(user.validate()).toBe(false);
  });
});
```

---

## Communication Protocol

### When Implementing
Say this:
```
I've read CDA_MANIFEST.md. I'll implement [feature] by:
1. Creating [files] in [layers]
2. Following [specific constraints]
3. Adding tests in [location]

Proceeding with implementation...
```

### When Finished
Say this:
```
Implementation complete. Verification checklist:
✓ Code in correct layers
✓ No files exceed 300 lines
✓ No layer violations
✓ No duplication detected
✓ Tests added

[Then show the code]
```

### When Uncertain
Say this:
```
Before implementing, I need clarification:
- Should [X] go in domain or app layer?
- Does similar functionality already exist in [Y]?
- What's the preferred approach for [Z]?
```

**Never guess - always ask when uncertain about architecture.**

---

## Red Flags - Stop Immediately If You See:

🚩 **You're about to create a 400-line file**  
→ Split it first, then implement

🚩 **You're copying code from another file**  
→ Extract to shared location instead

🚩 **You're importing from a higher layer**  
→ Restructure - you're violating layer rules

🚩 **You can't decide which layer this belongs in**  
→ Ask before implementing

🚩 **The code "mostly works" but has warnings**  
→ Fix warnings - they're there for a reason

---

## Success Criteria

You've done well when:
- ✅ All code is in appropriate layers
- ✅ No files exceed size limits
- ✅ No duplication introduced
- ✅ Tests cover new functionality
- ✅ Structure is clear and navigable
- ✅ Future developers can understand your changes

You need to iterate when:
- ❌ Layer violations exist
- ❌ Files are too large
- ❌ Code is duplicated
- ❌ Tests are missing
- ❌ Structure is confusing

---

## Remember

**Speed is good. Structure is better. Both together is best.**

Following CDA constraints might feel slow initially, but it:
- Prevents technical debt
- Keeps the codebase navigable
- Maintains agent effectiveness over time
- Makes future changes easier

**When in doubt, read CDA_MANIFEST.md again.**
