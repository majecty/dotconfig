# Add wiki link auto-completion in nvim

**Status:** Done
**Date:** 2026-08-04

## Details

Added a custom `nvim-cmp` completion source for wiki-style links in markdown files.

- New source: `nvim/lua/packages/wiki/cmp.lua`
  - Triggered by `[[` inside markdown buffers.
  - Collects page names from `~/jhconfig/docs/{daily,notes,wiki}` and the docs root.
  - Completes to `pagename]]` so the final result is `[[pagename]]`.
  - Uses `textEdit` to replace only the text after `[[` and before the cursor.
  - De-duplicates and sorts candidates by page name.
- Registered the source in `nvim/lua/plugins/cmp.lua` for the `markdown` filetype.

## Notes

- Validation passed with `stylua --check` and `nvim --headless -c 'checkhealth'`.
- The source follows the existing `packages/wiki` basename resolution used by `follow_link.lua`.
