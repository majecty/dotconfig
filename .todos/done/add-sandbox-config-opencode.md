# add sandbox config in opencode

**Status:** Done
**Date:** 2026-02-08

## Details
Added sandbox configuration in OpenCode.
Note: Sandbox plugin removed due to reliability issues with srt/nosrt sandbox mode.
- Auto-retry with nosrt led to inconsistent file permissions and errors
- Read-only file system and permission denied errors observed

## Notes
Lessons learned: Prefer direct command execution unless sandboxing is proven reliable.
Fallback logic adds complexity and sometimes masks underlying platform or mount issues.
Future: If sandbox needed, thoroughly validate cross-platform/FS mechanics.

