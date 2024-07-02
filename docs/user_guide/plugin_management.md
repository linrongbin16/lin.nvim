# Plugin Management

This distro uses [lazy.nvim](https://github.com/folke/lazy.nvim) as its plugin manager, all plugins are listed in [lua/plugins/init.lua](https://github.com/linrongbin16/lin.nvim/tree/main/lua/plugins/init.lua).

By following lazy's [Plugin Spec](https://lazy.folke.io/spec), all the plugins are specified with several options such as `init`, `config`, `keys`, `cmd`, `event`, etc:

- `init`: Some configurations run on Neovim start, i.e. before loading any plugin.
- `config`: Some configurations run on the plugin loading, usually it just calls the `setup` API provided by the plugin lua package.
- `keys`: Some key mappings related to the plugin. By specifying this option, the plugin will be lazy loaded when first pressing the keys.
- `cmd`: Some command names provided by the plugin. By specifying this option, the plugin will be lazy loaded when first running the command.
- `event`: Some Vim events to trigger the plugin loading. By specifying this option, the plugin will be lazy loaded until these events first been triggered.
