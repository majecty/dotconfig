Sample: Local VeryLazy Plugin

This directory contains a minimal example of a local plugin and the plugin spec
that demonstrates how to configure it to load on the `VeryLazy` event.

Structure:
- `nvim/lua/packages/sample-executor.lua` - the local module implementing a simple `setup()`.
- `nvim/lua/plugins/sample-executor.lua` - the plugin spec that uses `dir` + `event = 'VeryLazy'`.

To use the sample in your config, copy the `nvim/` tree into your config root
(`~/jhconfig/`) or adjust `dir` to point to the sample location.
