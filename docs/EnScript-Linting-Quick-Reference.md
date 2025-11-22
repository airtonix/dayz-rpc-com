# EnScript Linting Quick Reference Card

## TL;DR

**There is NO linter for EnScript.** Use this workflow instead:

```
VSCode (Enfusion Script) → Manual Review → Workbench Build → Test Server
```

---

## Tools at a Glance

| Tool | What It Does | Worth Using? |
|------|-------------|--------------|
| **Enfusion Script (VSCode)** | Syntax highlighting + symbol search | ✅ **YES** - Essential |
| **DayZ Workbench** | Compilation errors + config validation | ✅ **YES** - Official |
| **Style Guide** | Manual code review reference | ✅ **YES** - Use it |
| **DayZConfigValidator** | JSON/XML file validation | ⚠️ Config mods only |
| **Dabs Framework** | Best practice patterns | ⚠️ For new projects |

---

## Setup Checklist (30 minutes)

- [ ] Install VSCode extension: `yuval.enfusion-script`
- [ ] Create `.vscode/settings.json` with script folders
- [ ] Create `.git/hooks/pre-commit` for basic checks
- [ ] Read `docs/EnScript-(Enforce-Script)-Style-Guide.md`
- [ ] Bookmark this guide for code review

---

## Code Review Checklist

### Naming
- [ ] Classes: `PascalCase` (e.g., `PlayerManager`)
- [ ] Methods: `PascalCase` (e.g., `OnUpdate()`)
- [ ] Variables: `camelCase` (e.g., `playerCount`)
- [ ] Members: `m_` prefix (e.g., `m_IsLoaded`)
- [ ] Statics: `s_` prefix (e.g., `s_Instance`)

### Memory
- [ ] No `ref` in parameters
- [ ] No `ref` in return types
- [ ] Use `= null` instead of `delete`
- [ ] Null checks before use: `if (object)`

### EnScript Specific
- [ ] `modded class` has NO `: ParentClass`
- [ ] `#ifdef` blocks NOT empty
- [ ] Complex array ops use intermediate vars
- [ ] Tabs only (no spaces)
- [ ] Spacing: `x = y + z`

### Quality
- [ ] Comments explain "why"
- [ ] Methods do one thing
- [ ] No duplicate code
- [ ] Magic numbers → constants
- [ ] Error handling in place

---

## Validation Steps Before Commit

```bash
# 1. Run pre-commit checks
./cmd/validate-scripts.sh

# 2. Build in Workbench
# In Workbench: Project → Build
# Or: Ctrl+Shift+B

# 3. Manual code review
# Use checklist above

# 4. Commit
git commit
```

---

## What You Can't Automate

❌ **Linting** (style checking)
❌ **Formatting** (code beautification)
❌ **Complexity** metrics
❌ **Unused** variables
❌ **Security** scanning

These must be caught through **code review**.

---

## Common Mistakes to Watch For

| Mistake | Error | Fix |
|---------|-------|-----|
| Spaces for indent | Wrong style | Use tabs only |
| `class myClass` | Fails build | Use `MyClass` |
| `ref` in param | Memory issues | Remove `ref` |
| `modded class X : Y` | Ignored/crash | Remove `: Y` |
| `#ifdef` empty | Segfault | Add one statement |
| `delete obj` | Crash | Use `obj = null` |

---

## Tools Status

```
✅ PRODUCTION READY:
  • Enfusion Script VSCode Extension
  • DayZ Workbench (official)
  • Style Guide (in docs/)

⚠️ LIMITED USE:
  • DayZConfigValidator (configs only)
  • Dabs Framework (patterns only)

❌ DON'T USE:
  • dayz-vscode (experimental)
  • ESE Library (WIP)
  • MutantSpawnValidator (unmaintained)
```

---

## Resources

- **Full Guide:** `docs/EnScript-Linting-Research.md`
- **Style Guide:** `docs/EnScript-(Enforce-Script)-Style-Guide.md`
- **VSCode Extension:** https://marketplace.visualstudio.com/items?itemName=yuval.enfusion-script
- **Reference Code:** https://github.com/salutesh/DayZ-Expansion-Scripts
- **Official Docs:** https://developer.bistudio.com/

---

## Remember

**Quality comes from process, not tools.**

The best DayZ mods use:
1. IDE support (Enfusion Script)
2. Manual review (checklist above)
3. Build validation (Workbench)
4. Testing (on server)
5. Peer review (GitHub PR)

That's it. That's how professional DayZ modders work in 2024-2025.
