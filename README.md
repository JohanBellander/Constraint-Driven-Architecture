# Constraint-Driven Architecture (CDA)

**A framework-agnostic approach for AI-assisted development**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-1.1.0-blue.svg)](https://github.com/JohanBellander/Constraint-Driven-Architecture)

---

## What is CDA?

Constraint-Driven Architecture (CDA) is a development methodology where specifications and architectural rules are defined as **executable, machine-verifiable constraints**. This allows both humans and AI agents to iterate quickly without sacrificing structure, consistency, or quality.

**The Problem CDA Solves:**
- 🚨 AI agents cause structural decay over time
- 🚨 Code quality degrades with rapid iteration  
- 🚨 Architectural boundaries blur across features
- 🚨 No explicit rules for AI agents to follow

**The CDA Solution:**
- ✅ Explicit, verifiable constraints
- ✅ Layer boundaries enforced automatically
- ✅ Structure preserved across iterations
- ✅ AI agents learn and self-correct

---

## Quick Start

### 1. Copy Files to Your Project

```bash
git clone https://github.com/JohanBellander/Constraint-Driven-Architecture.git
cd Constraint-Driven-Architecture

# Copy to your project
cp CDA_MANIFEST.md /path/to/your/project/
cp CONSTITUTION.md /path/to/your/project/
cp AI_AGENT_INSTRUCTIONS.md /path/to/your/project/
```

### 2. Create Directory Structure

```bash
cd /path/to/your/project
mkdir -p src/{domain,app,infra}
mkdir -p contracts tests
```

### 3. Start Building

Tell your AI agent:
```
Read CDA_MANIFEST.md before implementing anything in this project.
```

---

## Two Modes Available

### Mode 1: Single-Agent (Default)
- ✅ One AI agent implements and self-verifies
- ✅ You review manually
- ✅ Good for: prototyping, learning, solo projects
- ✅ Setup time: 5 minutes

### Mode 2: Dual-Agent Validation (Enhanced) ⭐ NEW
- ✅ Agent 1 implements, Agent 2 (CoPilot) reviews automatically
- ✅ Automated architectural enforcement
- ✅ Good for: production code, teams, learning from AI feedback
- ✅ Setup time: 30 minutes (requires CoPilot CLI)

**See [COPILOT_SETUP.md](COPILOT_SETUP.md) for dual-agent setup.**

---

## Core Files

| File | Purpose | When to Read |
|------|---------|--------------|
| **[CDA_MANIFEST.md](CDA_MANIFEST.md)** | Main architecture rules | Before starting ⭐ |
| **[CONSTITUTION.md](CONSTITUTION.md)** | Philosophy and governance | Day 1 ⭐ |
| **[AI_AGENT_INSTRUCTIONS.md](AI_AGENT_INSTRUCTIONS.md)** | Agent workflow | Before each feature ⭐ |
| **[QUICK_START.md](QUICK_START.md)** | Testing methodology | Week 1 |
| **[Constraint_Driven_Architecture.md](Constraint_Driven_Architecture.md)** | Detailed paper | Reference |

### Dual-Agent Files (Optional)

| File | Purpose | When to Read |
|------|---------|--------------|
| **[COPILOT_SETUP.md](COPILOT_SETUP.md)** | CoPilot CLI setup guide | Before dual-agent |
| **[DUAL_AGENT_VALIDATION.md](DUAL_AGENT_VALIDATION.md)** | How dual-agent works | Before dual-agent |

---

## The Three Layers

```
┌─────────────┐
│   INFRA     │  External systems (DB, APIs, I/O)
├─────────────┤
│    APP      │  Orchestration (UI, use cases)
├─────────────┤
│   DOMAIN    │  Business logic (pure, no side effects)
└─────────────┘

Dependency flow: INFRA → APP → DOMAIN
```

### Layer Rules

| Layer | Contains | Imports From | NO Imports From |
|-------|----------|--------------|-----------------|
| **Domain** | Entities, validation, business logic | Nothing | app, infra |
| **App** | Components, use cases, handlers | domain | infra |
| **Infra** | DB, APIs, external systems | domain, app | - |

---

## Battle-Tested Results

CDA was validated with a real CRM application:

| Metric | Result |
|--------|--------|
| **Features Built** | 5 (Contact, Lead, Deal, Company, Activity) |
| **Test Duration** | 5 days |
| **Layer Violations** | 0 (after feature 1) |
| **Structural Decay** | None detected |
| **Agent Learning** | Demonstrated by feature 3 |
| **Final Quality** | 100% compliance |

**Conclusion:** CDA prevents "AI code decay" and maintains structure over time.

---

## Technology Support

**Languages:** TypeScript, JavaScript, Python, Go, Java, C#, Ruby, PHP

**Frameworks:**
- Frontend: React, Vue, Angular, Svelte, React Native, Flutter
- Backend: Express, NestJS, Django, Flask, Spring Boot, Go Gin
- Full-stack: Next.js, Nuxt, SvelteKit, Remix

**No dependencies. Just documentation.**

---

## Getting Started

### Option 1: Single-Agent Mode (Recommended to Start)

1. **Read the core files** (30 minutes)
   - CDA_MANIFEST.md
   - CONSTITUTION.md
   - AI_AGENT_INSTRUCTIONS.md

2. **Build your first feature** (1-2 hours)
   - Tell AI agent to read CDA_MANIFEST.md
   - Implement a simple CRUD feature
   - Track results in QUICK_START.md

3. **Build 4 more features** (Week 1)
   - Watch for agent learning
   - Track violations
   - Decide if you need dual-agent mode

### Option 2: Dual-Agent Mode (For Production/Teams)

1. **Complete Option 1 first**

2. **Set up CoPilot CLI** (30 minutes)
   - Follow [COPILOT_SETUP.md](COPILOT_SETUP.md)
   - Install GitHub CLI and CoPilot extension
   - Add review scripts to your project

3. **Enable dual-agent validation**
   - Agent 1 implements and submits
   - Agent 2 (CoPilot) reviews automatically
   - Agent 1 fixes based on feedback

---

## Example Workflow

### Single-Agent Mode:

```
You: "Implement user authentication following CDA_MANIFEST.md"

Agent: [reads manifest, implements, self-checks]
Agent: "Implementation complete. Verification checklist: ✅ All passed"

You: [review manually]
You: "Approved" OR "Fix these issues: [...]"
```

### Dual-Agent Mode:

```
You: "Implement user authentication following CDA_MANIFEST.md"

Agent 1: [reads manifest, implements, self-checks]
Agent 1: "Implementation complete. Ready for architectural review."

You: "./scripts/request-copilot-review.sh"

Agent 2 (CoPilot): [reviews against CDA rules]
Agent 2: "REJECTED - 1 violation: UserForm.tsx exceeds 300 lines"

Agent 1: [fixes based on feedback]
Agent 1: "Violations addressed. Resubmitting."

You: "./scripts/request-copilot-review.sh"

Agent 2: "APPROVED - All constraints satisfied"

You: git commit -m "feat: add user authentication (CDA approved)"
```

---

## File Constraints

- **Max 300 lines per file** - Split if larger
- **Max complexity 10** - Simplify if higher
- **No code duplication** - Extract to shared functions
- **One responsibility per file** - Single purpose

---

## Success Metrics

After 1 week / 5 features:

✅ Structure stayed clean across features  
✅ AI agent self-enforced constraints  
✅ No layer violations  
✅ Files stayed under limits  
✅ Minimal duplication  

If 4/5 are met → CDA is working!

---

## Documentation

### Core Documentation
- **CDA_MANIFEST.md** - The rules (read first)
- **CONSTITUTION.md** - The philosophy
- **AI_AGENT_INSTRUCTIONS.md** - Agent workflow
- **QUICK_START.md** - Testing guide
- **Constraint_Driven_Architecture.md** - Full paper

### Dual-Agent Documentation (Optional)
- **COPILOT_SETUP.md** - CoPilot CLI setup
- **DUAL_AGENT_VALIDATION.md** - How it works
- **scripts/request-copilot-review.sh** - Review script
- **scripts/create-review-request.sh** - Helper script

---

## Contributing

Found improvements? Have questions?

1. Open an issue
2. Submit a pull request
3. Share your experience
4. Help improve the documentation

---

## License

MIT License - free to use, modify, and distribute.

See [LICENSE](LICENSE) for details.

---

## Credits

- **Concept:** Constraint-Driven Architecture framework
- **Testing:** Validated with real CRM application
- **AI Integration:** Tested with Claude (Anthropic) and GitHub CoPilot
- **Author:** Johan Bellander

---

## Quick Links

- 📖 [Read the Full Paper](Constraint_Driven_Architecture.md)
- 🚀 [Quick Start Guide](QUICK_START.md)
- 🤖 [AI Agent Instructions](AI_AGENT_INSTRUCTIONS.md)
- ⚙️ [CoPilot Setup](COPILOT_SETUP.md)
- 💬 [Discussions](https://github.com/JohanBellander/Constraint-Driven-Architecture/discussions)
- 🐛 [Issues](https://github.com/JohanBellander/Constraint-Driven-Architecture/issues)

---

## FAQ

### Q: Do I need CoPilot for CDA to work?
**A:** No! CoPilot is optional for dual-agent validation. Single-agent mode works great without it.

### Q: What programming languages are supported?
**A:** All of them! CDA is language-agnostic. Just adapt the layer names to your context.

### Q: Can I use this with existing projects?
**A:** Yes! Start by adding CDA files, then apply to new features first. Gradually refactor old code.

### Q: How much does this cost?
**A:** CDA itself is free. Dual-agent mode requires GitHub CoPilot ($10/month).

### Q: Does this work with solo developers?
**A:** Absolutely! CDA works great for solo devs. Start with single-agent mode.

### Q: How long does it take to learn?
**A:** ~30 minutes to understand, 1 day to build first feature, 1 week to master.

---

**⭐ Star this repo if CDA helps you build better software with AI agents!**

**Version:** 1.1.0 (Dual-Agent Support Added)  
**Last Updated:** November 2, 2025
