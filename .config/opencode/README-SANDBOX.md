# OpenCode Sandbox Configuration

This directory contains the OpenCode sandbox configuration for safe LLM/agent execution with isolated bash command execution.

## 📋 Files

- **`sandbox.config.json`** - Main configuration file for sandbox behavior
- **`plugins/sandbox.ts`** - Plugin that intercepts and manages bash command execution
- **`tools/sandbox.ts`** - Custom sandbox tool for explicit command execution control
- **`package.json`** - Dependencies for sandbox functionality (if using external packages)

## 🎯 Purpose

The sandbox system provides:
- **Isolation** - All bash commands run in a restricted environment by default
- **Safety** - Prevents dangerous operations like recursive deletions, fork bombs, etc.
- **Flexibility** - Commands can opt-out with `nosrt:` prefix when needed
- **Resource Limits** - Configurable timeouts and memory limits

## 🚀 Usage

### Default Sandboxed Mode (srt)

All commands run in sandbox by default:

```bash
npm install    # Runs in sandbox
cd /tmp && ls  # Runs in sandbox
```

### Unrestricted Mode (nosrt)

To bypass sandbox protection:

```bash
nosrt: npm install --global package
nosrt: rm -rf node_modules
```

## ⚙️ Configuration

Edit `sandbox.config.json` to customize:

- **`enabled`** - Enable/disable sandbox (default: `true`)
- **`defaultMode`** - Default execution mode: `"srt"` (safe) or `"nosrt"` (unrestricted)
- **`sandbox.resourceLimits`**:
  - `timeout`: Maximum execution time in ms (default: 30000)
  - `maxMemory`: Maximum memory usage (default: 512MB)
- **`security.restrictedOperations`** - Operations blocked in sandbox mode
- **`security.allowedPaths`** - Paths accessible in sandbox mode

## 🔧 Integration with OpenCode

### How It Works

1. **Plugin Hook** (`plugins/sandbox.ts`):
   - Intercepts all bash tool executions via `tool.execute.before` hook
   - Checks command prefix (`srt:` or `nosrt:`)
   - Validates command against security restrictions
   - Wraps command in sandbox if using `srt` mode

2. **Custom Tool** (`tools/sandbox.ts`):
   - Provides explicit control over sandbox execution
   - Can be called directly in prompts: `Use the sandbox tool to run: npm install`
   - Returns execution status (sandboxed, unrestricted, or pending)

3. **Configuration Loading**:
   - Plugin automatically loads `sandbox.config.json` from `~/.config/opencode/`
   - Logs initialization status and settings

## 📦 Dependencies

The sandbox system uses Claude Code's sandbox implementation via npm:

```json
{
  "dependencies": {
    "@ai-sdk/sandbox": "latest"
  }
}
```

Install dependencies in OpenCode config directory:

```bash
cd ~/.config/opencode
npm install
# or
bun install
```

## 🔒 Security Features

- **Command Validation**: Blocks dangerous patterns (recursive deletions, fork bombs, etc.)
- **Resource Limits**: Enforces timeout and memory constraints
- **Path Restrictions**: Limits file access to safe directories
- **Explicit Opt-out**: Requires `nosrt:` prefix to bypass sandbox
- **Logging**: All operations logged for audit trail

## 📝 Logs

View sandbox execution logs:

```bash
# In OpenCode, check logs during plugin initialization
# Plugin outputs status via client.app.log()
```

## 🚨 Dangerous Operations Blocked in Sandbox

- `rm -rf` - Recursive deletion
- `:\(\s*\{\s*:\&` - Fork bombs
- Writing to `/dev/sda` or other system devices

## 💡 Examples

### Safe: Run npm commands in sandbox
```
opencode: npm install
opencode: npm run build
```

### Safe: Read files in sandbox
```
opencode: cat package.json
opencode: grep "version" package.json
```

### Unsafe: Explicitly bypass sandbox
```
opencode: nosrt: sudo apt-get update
opencode: nosrt: rm -rf /tmp/build
```

## 🔄 Future Enhancements

- Integration with actual Claude Code sandbox npm package
- Custom whitelist/blacklist rules per project
- Performance profiling for sandboxed commands
- Sandbox mode switching via OpenCode commands
- Per-user permission policies

## ❓ Troubleshooting

**Issue: Commands hang or timeout**
- Check `sandbox.config.json` timeout setting
- Increase `resourceLimits.timeout` if needed

**Issue: "Permission denied" errors**
- Verify paths are in `allowedPaths`
- Use `nosrt:` prefix for operations outside allowed paths

**Issue: Plugin not loading**
- Verify `plugins/sandbox.ts` exists in `~/.config/opencode/plugins/`
- Check OpenCode logs for initialization errors

## 🤝 Contributing

To improve the sandbox system:
1. Test new security patterns
2. Update restrictions in `sandbox.config.json`
3. Add logging for debugging
4. Document security implications

---

**Status**: Configuration ready for OpenCode integration  
**Version**: 1.0  
**Last Updated**: Feb 7, 2026
