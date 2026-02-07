#!/bin/bash
# Move completed todos from TODO.md to .todos/done/

DATE=$(date +%Y-%m-%d)
DONE_FILE=".todos/done/$DATE.md"

# Extract completed items from TODO.md
grep "^- \[x\]" TODO.md | sed 's/- \[x\] //' >> "$DONE_FILE"

echo "✓ Completed todos archived to $DONE_FILE"
