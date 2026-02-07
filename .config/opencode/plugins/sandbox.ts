import type { Plugin } from "@opencode-ai/plugin"
import * as fs from "fs"
import * as path from "path"

interface SandboxConfig {
  enabled: boolean
  defaultMode: "srt" | "nosrt"
  sandbox: {
    engine: string
    npm: string
    resourceLimits: {
      timeout: number
      maxMemory: string
    }
  }
  security: {
    restrictedOperations: string[]
    allowedPaths: string[]
  }
}

let sandboxConfig: SandboxConfig | null = null

// Load sandbox configuration
function loadSandboxConfig(configDir: string): SandboxConfig | null {
  try {
    const configPath = path.join(configDir, "sandbox.config.json")
    if (fs.existsSync(configPath)) {
      const content = fs.readFileSync(configPath, "utf-8")
      return JSON.parse(content)
    }
  } catch (error) {
    console.error("Failed to load sandbox config:", error)
  }
  return null
}

// Check if command should run in sandbox
function shouldUseSandbox(command: string): boolean {
  if (!sandboxConfig?.enabled) return false

  // Check command prefix
  if (command.startsWith("nosrt:")) return false // Explicitly disabled
  if (command.startsWith("srt:")) return true // Explicitly enabled

  // Default mode
  return sandboxConfig.defaultMode === "srt"
}

// Strip sandbox prefix from command
function stripSandboxPrefix(command: string): string {
  return command.replace(/^(srt|nosrt):/, "")
}

// Validate command against security restrictions
function validateCommand(command: string, config: SandboxConfig): { valid: boolean; reason?: string } {
  const restrictedPatterns = [
    /rm\s+-rf/, // Dangerous deletions
    /:\(\s*\{\s*:\&/, // Fork bomb
    />\s*\/dev\/sda/, // Writing to disk
  ]

  for (const pattern of restrictedPatterns) {
    if (pattern.test(command)) {
      return { valid: false, reason: `Dangerous operation detected: ${pattern}` }
    }
  }

  return { valid: true }
}

export const SandboxPlugin: Plugin = async ({ project, client, $, directory }) => {
  // Load configuration from global config directory
  const configDir = path.join(process.env.HOME || "/root", ".config/opencode")
  sandboxConfig = loadSandboxConfig(configDir)

  if (!sandboxConfig?.enabled) {
    await client.app.log({
      body: {
        service: "sandbox-plugin",
        level: "info",
        message: "Sandbox plugin loaded but disabled",
      },
    })
    return {}
  }

  await client.app.log({
    body: {
      service: "sandbox-plugin",
      level: "info",
      message: "Sandbox plugin initialized",
      extra: { defaultMode: sandboxConfig.defaultMode },
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

      // Validate command
      const validation = validateCommand(cleanCommand, sandboxConfig!)
      if (!validation.valid) {
        throw new Error(`Sandbox security violation: ${validation.reason}`)
      }

      if (useSandbox) {
        // Wrap command in sandbox execution
        // Note: This is a placeholder. Real implementation would use Claude Code's sandbox npm package
        await client.app.log({
          body: {
            service: "sandbox-plugin",
            level: "info",
            message: "Executing command in sandbox mode",
            extra: { command: cleanCommand },
          },
        })

        // Update the command to be executed (would integrate with actual sandbox)
        output.args.command = `srt --timeout ${sandboxConfig.sandbox.resourceLimits.timeout} --memory ${sandboxConfig.sandbox.resourceLimits.maxMemory} -- ${cleanCommand}`
      } else {
        // nosrt mode
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

    "tool.execute.after": async (input, output) => {
      if (input.tool !== "bash") return

      // Safely access output
      if (!output || typeof output !== "object" || !("output" in output)) {
        return
      }

      const outputText = output.output as string
      if (typeof outputText !== "string") {
        return
      }

      await client.app.log({
        body: {
          service: "sandbox-plugin",
          level: "info",
          message: "Bash command executed",
        },
      })
    },
  }
}
