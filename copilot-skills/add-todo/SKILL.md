---
name: add-todo
description: Adds TODO items to TODO.md when starting substantive work, breaking tasks into logical chunks.
---

# Add TODO Skill

Use this skill when starting any substantive task (code changes, research, configuration, problem-solving).

## Activation

- Visible activation message: "📝 Adding TODOs..."
- Skip only for trivial single-step tasks or pure informational requests

## Process

### 1. Analyze and Break Down
- Understand the user's request
- Break it into logical, actionable chunks
- Each chunk should be completable in one focused work session

### 2. Add TODOs to TODO.md
- Add each chunk as a new TODO item
- Format: `- [ ] Task description`
- Add to `/home/juhyung/jhconfig/TODO.md` under "## Pending Tasks"
- Display the added TODOs to the user

### 3. Commit Changes
- Run: `git add TODO.md && git commit -m "add todos: [brief description of what was added]"`
- Show confirmation message

## Guidelines

- **Visible**: Always show what TODOs were added
- **Logical**: Break down tasks into independently completable chunks
- **Clear**: Use descriptive task names that are actionable
- **Committed**: Always commit TODO.md changes immediately
- Use 📝 emoji for visibility

## Example

```
📝 Adding TODOs...

Adding 3 items to TODO.md:
- [ ] Research existing metrics tracking
- [ ] Design metrics collection system
- [ ] Implement core metrics functionality

✅ Committed: "add todos: usage metrics tracking"
```
