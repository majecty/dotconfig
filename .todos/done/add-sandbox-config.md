# add sandbox config in opencode

**Status:** Done (with notes)
**Date:** 2026-02-08

## Details
Added sandbox configuration in opencode. Lesson learned: prefer direct command execution.

## Notes
- Sandbox plugin removed: reliability issues with srt/nosrt sandbox mode
- Attempts to auto-retry with nosrt led to inconsistent file permissions and errors
- Lessons: Prefer direct command execution unless sandboxing is proven reliable
- Future: If sandbox needed, thoroughly validate cross-platform/FS mechanics
