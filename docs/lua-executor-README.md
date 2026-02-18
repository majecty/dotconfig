# Lua Executor for Markdown

A minimal Neovim plugin that lets you execute Lua code blocks in markdown files interactively - like Jupyter notebooks for Lua!

## Features

- ✅ Execute standard markdown ` ```lua ... ``` ` code blocks
- ✅ Press `Enter` in any code block to run it
- ✅ **Persistent state** - variables/functions persist across blocks
- ✅ Output displayed in a **separate window**
- ✅ **Zero dependencies** - ~200 lines of pure Lua
- ✅ Works with any markdown file

## How to Use

1. **Open a markdown file** with Lua code blocks:
   ```markdown
   ```lua
   x = 10
   print("x = " .. x)
   ```
   ```

2. **Position your cursor** anywhere in the code block

3. **Press `Enter`** to execute the entire block

4. **View output** in the bottom window

## Example Workflow

```markdown
# First Block
```lua
x = 10
y = 20
sum = x + y
print("Sum: " .. sum)
```

# Second Block (state persists!)
```lua
print("x is still " .. x)
print("sum is still " .. sum)
result = sum * 2
print("Doubled: " .. result)
```
```

- Execute first block → prints "Sum: 30"
- Execute second block → prints "x is still 10", "sum is still 30", "Doubled: 60"

## Commands

| Command | Action |
|---------|--------|
| `<Enter>` (in markdown) | Execute current Lua code block |
| `:LuaExecute` | Execute current code block manually |

## Architecture

- **State Management**: Uses shared `execution_context` table to maintain variables across blocks
- **Code Execution**: Uses `loadstring()` + `setfenv()` to run code in isolated but persistent context
- **Output Capture**: Redirects `print()` to capture all output
- **Error Handling**: Catches runtime errors and displays them in output window

## Files

- `nvim/lua/packages/lua-executor.lua` - Core executor logic
- `nvim/lua/plugins/lua-executor.lua` - Plugin wrapper
- `docs/learn-nvim-lua.md` - Complete Neovim Lua API basics guide

## Learning with This Tool

Open `docs/learn-nvim-lua.md` to learn Neovim Lua API fundamentals:

1. Neovim's global `vim` object
2. Buffer manipulation
3. Window management
4. Cursor control
5. Option setting
6. Command execution
7. Keymap registration
8. Variable management
9. User notifications
10. File type handling
11. Simple plugins
12. Practice exercises

**All code blocks are executable!** Just press `Enter` to try them.

## Tips

- 💡 State persists across blocks - use this to your advantage!
- 🔄 To clear state: Call `:lua require("packages.lua-executor").clear_context()`
- 📝 You can define functions in one block and use them in later blocks
- 🐛 Syntax errors are caught and displayed in the output window
- 🔍 First 3 lines of your code are shown in the output for reference

## Output Format

The output window shows:

```
╔════════════════════════════════════════════════════════════════════════════╗
║ Lua Execution Output                                                       ║
╠════════════════════════════════════════════════════════════════════════════╣
║ Code:                                                                      ║
║   (first 3 lines of your code)                                            ║
╠════════════════════════════════════════════════════════════════════════════╣
║ ✓ Success                                                                  ║
╠════════════════════════════════════════════════════════════════════════════╣
║ (your output here)                                                        ║
╚════════════════════════════════════════════════════════════════════════════╝
```

Or if there's an error:

```
╔════════════════════════════════════════════════════════════════════════════╗
║ ✗ Error                                                                    ║
╠════════════════════════════════════════════════════════════════════════════╣
║ (error message)                                                           ║
╚════════════════════════════════════════════════════════════════════════════╝
```

## Example: Learning Loop

```
1. Open docs/learn-nvim-lua.md
2. Read a section (e.g., "Buffers")
3. Position cursor in the code block
4. Press Enter
5. See the output immediately
6. Modify the code
7. Press Enter again
8. Learn through experimentation!
```

## Requirements

- Neovim (any recent version)
- No external dependencies

## Troubleshooting

**Q: Code doesn't execute**
- Make sure you're in Normal mode
- Ensure the markdown file is open in Neovim
- Verify you're inside a ` ```lua ... ``` ` block

**Q: Variables don't persist**
- They should persist by default! Check if you're executing different blocks
- Use `:LuaExecute` directly to confirm execution

**Q: Error in code block**
- Check the error message in the output window
- Verify Lua syntax is correct
- Try breaking the code into smaller blocks

