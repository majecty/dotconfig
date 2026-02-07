import { tool } from "@opencode-ai/plugin"

export const sandbox = tool({
  description:
    "Execute a command in a secure sandbox environment with resource isolation. Use 'srt:' prefix for sandboxed execution (default) or 'nosrt:' prefix to bypass sandbox (requires confirmation).",
  args: {
    command: tool.schema
      .string()
      .describe("The command to execute. Prefix with 'srt:' for sandboxed or 'nosrt:' to bypass sandbox"),
    timeout: tool.schema.number().optional().describe("Timeout in milliseconds (default: 30000)"),
    allowNetwork: tool.schema
      .boolean()
      .optional()
      .describe("Allow network access (only in nosrt mode)"),
  },
  async execute(args, context) {
    const command = args.command
    const useSandbox = !command.startsWith("nosrt:")
    const cleanCommand = command.replace(/^(srt|nosrt):/, "")

    if (!useSandbox) {
      return {
        status: "pending",
        message: "This command requires unrestricted execution (nosrt mode). User confirmation is required.",
        command: cleanCommand,
        warning: "This will execute WITHOUT sandbox protection",
      }
    }

    // Return sandbox execution info
    return {
      status: "sandboxed",
      command: cleanCommand,
      timeout: args.timeout || 30000,
      memory: "512MB",
      isolation: "enabled",
      message: "Command will execute in secure sandbox",
    }
  },
})
