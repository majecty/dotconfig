import type { Plugin } from "@opencode-ai/plugin"

// Strip sandbox prefix from command
function stripSandboxPrefix(command: string): string {
  return command.replace(/^(srt|nosrt)/, "")
}

// Check if command should run in sandbox
function shouldUseSandbox(command: string): boolean {
  // Check command prefix
  if (command.startsWith("nosrt")) return false // Explicitly disabled
  if (command.startsWith("srt")) return true // Explicitly enabled

  // Default to sandbox mode
  return true
}

export const SandboxPlugin: Plugin = async ({ client }) => {
  await client.app.log({
    body: {
      service: "sandbox-plugin",
      level: "info",
      message: "Sandbox plugin initialized",
    },
  })

  return {
    "tool.execute.before": async (input, output) => {
      if (input.tool !== "bash") return

      // Safely access command from args
      if (!output.args || typeof output.args !== "object" || !("command" in output.args)) {
        return
      }

      const command = output.args.command as string
      if (typeof command !== "string") {
        return
      }

      const useSandbox = shouldUseSandbox(command)
      const cleanCommand = stripSandboxPrefix(command)

      if (useSandbox) {
        await client.app.log({
          body: {
            service: "sandbox-plugin",
            level: "info",
            message: "Executing command in sandbox mode",
            extra: { command: cleanCommand },
          },
        })

        // Wrap command with srt
        output.args.command = `srt ${cleanCommand}`
      } else {
        await client.app.log({
          body: {
            service: "sandbox-plugin",
            level: "warn",
            message: "Executing command WITHOUT sandbox (nosrt mode)",
            extra: { command: cleanCommand },
          },
        })

        output.args.command = cleanCommand
      }
    },
  }
}
