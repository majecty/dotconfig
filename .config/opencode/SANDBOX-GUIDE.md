# OpenCode Sandbox Guide

## Overview

The sandbox plugin in OpenCode automatically wraps all bash commands with `srt` (sandboxed/restricted) mode for safety. This isolates command execution to prevent accidental damage or security issues.

## Default Behavior

By default, **all bash commands run in sandbox mode**:

```bash
npm install        # Actually runs: srt npm install
ls -la /home       # Actually runs: srt ls -la /home
cd /tmp && mkdir x # Actually runs: srt cd /tmp && mkdir x
```

## When Sandbox Fails

If a command fails in sandboxed mode, you can run it **without sandbox protection** using the `nosrt:` prefix:

```bash
nosrt: npm install --global some-package
nosrt: sudo apt-get update
nosrt: rm -rf /tmp/build
```

**Important**: Use `nosrt:` only when:
- Sandbox is blocking legitimate operations
- You need elevated permissions (sudo)
- You're certain the command is safe

## Sandbox Mode Examples

### Safe Commands (Work in sandbox)
```bash
npm install              # Install dependencies
npm run build            # Run build scripts
ls -la                   # List files
cat package.json         # Read files
grep "version" *.json    # Search files
mkdir /tmp/test          # Create temp directories
```

### Commands Requiring nosrt
```bash
nosrt: sudo npm install -g packages          # Global npm packages with sudo
nosrt: apt-get install packages              # System package management
nosrt: systemctl restart service             # System service control
nosrt: chown -R user:group /path             # Change file ownership
```

## Troubleshooting

### Issue: Command fails with "Permission denied"
**Solution**: Use `nosrt:` prefix
```bash
nosrt: your-command-here
```

### Issue: "Cannot access /usr/local/bin"
**Solution**: Global installs may need `nosrt:`
```bash
nosrt: npm install -g package-name
```

### Issue: "Cannot write to protected directory"
**Solution**: Use `nosrt:` for system directories
```bash
nosrt: command-that-needs-write-access
```

## How It Works

1. **Sandbox enabled (default)**:
   - Command: `npm install`
   - Executed as: `srt npm install`
   - Result: Runs in restricted environment

2. **Sandbox disabled (nosrt)**:
   - Command: `nosrt: npm install`
   - Executed as: `npm install`
   - Result: Runs unrestricted

## Best Practices

1. **Always try sandbox first** - Most commands work fine in sandbox mode
2. **Use nosrt sparingly** - Only when absolutely necessary
3. **Check logs** - View plugin logs to understand sandbox failures:
   ```bash
   grep sandbox-plugin ~/.local/share/opencode/log/*.log
   ```
4. **Document why nosrt is needed** - If you need nosrt, add a comment explaining why

## Examples

### Installing npm packages
```bash
# Default (sandbox)
npm install

# With global flag (may need nosrt)
nosrt: npm install -g @angular/cli
```

### Building projects
```bash
# Default (sandbox)
npm run build

# With elevated access (if needed)
nosrt: npm run build
```

### File operations
```bash
# Create files (sandbox works)
touch myfile.txt

# Remove files (sandbox works)
rm myfile.txt

# Remove system files (use nosrt)
nosrt: rm -rf /var/log/old
```

### Docker/System commands
```bash
# Regular commands (sandbox)
docker ps
kubectl get pods

# Privileged operations (use nosrt)
nosrt: sudo systemctl restart nginx
nosrt: docker run --privileged ...
```

## Viewing Sandbox Logs

Check what the sandbox plugin is doing:

```bash
# View latest logs
tail -f ~/.local/share/opencode/log/$(ls -t ~/.local/share/opencode/log/*.log | head -1 | xargs basename)

# Filter for sandbox plugin
grep "sandbox-plugin" ~/.local/share/opencode/log/*.log

# Follow sandbox logs in real-time
tail -f ~/.local/share/opencode/log/*.log | grep sandbox
```

## Disable Sandbox (Not Recommended)

If you want to completely disable the sandbox plugin:

**Edit** `~/.config/opencode/opencode.json`:
```json
{
  "plugin": []  // Remove "sandbox" from array
}
```

Then restart OpenCode.

---

**Summary**: Try commands in sandbox mode first. If they fail, add `nosrt:` prefix to bypass the sandbox.
