import type { Plugin } from "@opencode-ai/plugin"

export const SandboxPlugin: Plugin = async ({ client }) => {
  await client.app.log({
    body: {
      service: "sandbox-plugin",
      level: "info",
      message: "Sandbox plugin loaded (sandbox logic removed; no wrapping applied)",
    },
  })

  return {
    // Pass-through: Remove all sandbox wrapping.
    "tool.execute.before": async (_input, _output) => {
      // Previously wrapped with srt/nosrt, now noop.
    },
    "tool.execute.after": async (_input, _output) => {
      // Previously retried with nosrt on error, now noop.
    },
  }
}
