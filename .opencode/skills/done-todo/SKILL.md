---
name: done-todo
description: Creates completion records for finished TODOs in .todos/done/ directory.
---

# Done TODO Skill

Use this skill when a TODO item is fully completed and needs a completion record.

## Process

### 1. Mark as Completed
- Update `/home/juhyung/jhconfig/TODO.md`
- Change the completed TODO: `- [ ] Task` → `- [x] Task`

### 2. Create Completion Record
- Create a markdown file in `/home/juhyung/jhconfig/.todos/done/`
- Filename: `task-name-slugified.md` (e.g., `add-dark-mode-toggle.md`)
- Content format:
  ```markdown
  # Task Name
  
  **Status:** Done
  **Date:** YYYY-MM-DD
  
  ## Details
  - Brief summary of what was done
  - Key changes or implementations
  - Features added/fixed
  
  ## Notes
  - Additional context or learnings
  - Any gotchas or special considerations
  ```

### 3. Commit Changes
- Run: `git add TODO.md .todos/done/[filename] && git commit -m "mark '[task name]' done and add completion record"`
- Show confirmation message

## Guidelines

- **Visible**: Always show the completion record created
- **Detailed**: Include context about what was done and why
- **Dated**: Always include completion date in the record
- **Committed**: Always commit both TODO.md and .todos/done/ files together
- Use ✅ emoji for visibility

## Example

```
✅ Marked 'Add dark mode toggle' as completed

Created: .todos/done/add-dark-mode-toggle.md

Committed: "mark 'Add dark mode toggle' done and add completion record"
```
