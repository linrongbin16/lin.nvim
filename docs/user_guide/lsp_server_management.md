# LSP Server Management

Unlike [coc.nvim](https://github.com/neoclide/coc.nvim), there's no such all-in-one framework in Neovim's world. But with the help of a bunch of plugins, managing lsp servers is just a piece of cake now.

## Introduction

To bring LSP based IDE features to user, quite a few plugins are assembled:

- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig): Infrastructure for neovim lsp configurations, pre-requirement for all other lsp plugins.
- [mason.nvim](https://github.com/williamboman/mason.nvim): It helps manage all the lsp servers: install, remove and update. Usually you need to manually maintain lsp servers for programming language (`clangd`, `pyright`, `jsonls`, etc), but with this plugin, now you can just type `:Mason` to finish all these things.
- [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim): It fills the gap between `mason.nvim` and `nvim-lspconfig.nvim`. And you can also:
  1. Ensure some lsp servers installed (please checkout [williamboman/mason-lspconfig-nvim/ensure_installed_sample.lua](https://github.com/linrongbin16/lin.nvim/blob/744e4c7fd9e0c55630a4881279eefe671bfcee43/lua/configs/williamboman/mason-lspconfig-nvim/ensure_installed_sample.lua)).
  2. Automatically setup LSP servers, i.e. avoid duplicated calls on `require("lspconfig")[server_name].setup()` API.
- [none-ls.nvim](https://github.com/nvimtools/none-ls.nvim)(null-ls.nvim reloaded): It provides extra formatter/linter/code actions/diagnostics by injecting lsp server. A single LSP server sometimes cannot meet the developer's needs, for example I use `luacheck` as lua linter, `eslint` as javascript linter. With this plugin, it registers them (they're called none-ls sources) as a `none-ls` LSP server, so they can work through LSP protocols. The same goes for code actions, diagnostics, formatters, etc.

  ?> This distro uses [conform.nvim](https://github.com/stevearc/conform.nvim) as code formatter, which works compatible with none-ls's sources, i.e. conform will use either an explicitly configured code formatter, or fallback to LSP formatting methods provided by LSP servers or none-ls sources.

- [mason-null-ls.nvim](https://github.com/jay-babu/mason-null-ls.nvim): It lets `none-ls.nvim` directly using packages managed by `mason.nvim`. And you can also:
  1. Ensure none-ls sources installed via mason.nvim.
  2. Automatically register them as none-ls sources.

?> There're more UI improving plugins, leave them to you to find out.

## Configuration

### LSP Servers

With the `:Mason` command, it usually satisfies most use cases.

But in case you want to ensure some LSP servers installed, please add the `lua/configs/williamboman/mason-lspconfig-nvim/ensure_installed.lua` file that returns a list of LSP server names. You can simply copy and rename the sample file [lua/configs/williamboman/mason-lspconfig-nvim/ensure_installed_sample.lua](https://github.com/linrongbin16/lin.nvim/blob/744e4c7fd9e0c55630a4881279eefe671bfcee43/lua/configs/williamboman/mason-lspconfig-nvim/ensure_installed_sample.lua) to enable it.

?> Check out [mason-lspconfig's Available LSP servers](https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers) for available LSP servers.

To customize a LSP server setup configuration, please add the `lua/configs/williamboman/mason-lspconfig-nvim/setup_handlers.lua` file that returns the `setup_handlers` table passed to `require("mason-lspconfig").setup_handlers()` API as parameter. You can simply copy and rename the sample file [lua/configs/williamboman/mason-lspconfig-nvim/setup_handlers_sample.lua](https://github.com/linrongbin16/lin.nvim/blob/744e4c7fd9e0c55630a4881279eefe671bfcee43/lua/configs/williamboman/mason-lspconfig-nvim/setup_handlers_sample.lua) to enable it.

?> Check out [mason-lspconfig's documentation](https://github.com/williamboman/mason-lspconfig.nvim/blob/37a336b653f8594df75c827ed589f1c91d91ff6c/doc/mason-lspconfig.txt#L164) for how the setup handler works.

### None-ls Sources

Usually it works out of the box, without any additional configurations.

But in case you want to ensure some none-ls sources installed, please add the `lua/configs/jay-babu/mason-null-ls-nvim/ensure_installed.lua` file that returns a list of none-ls source names. You can simply copy and rename [lua/configs/jay-babu/mason-null-ls-nvim/ensure_installed_sample.lua](https://github.com/linrongbin16/lin.nvim/blob/744e4c7fd9e0c55630a4881279eefe671bfcee43/lua/configs/jay-babu/mason-null-ls-nvim/ensure_installed_sample.lua) to enable it.

?> Check out [none-ls's BUILTINS](https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md) for built-in sources.

To customize a none-ls source setup configuration, please add the `lua/configs/jay-babu/mason-null-ls-nvim/setup_handlers.lua` file that returns the `handlers` table passed to `require("mason-null-ls").setup({})` API as the `handlers` option. You can simply copy and rename the sample file [lua/configs/jay-babu/mason-null-ls-nvim/setup_handlers_sample.lua](https://github.com/linrongbin16/lin.nvim/blob/744e4c7fd9e0c55630a4881279eefe671bfcee43/lua/configs/jay-babu/mason-null-ls-nvim/setup_handlers_sample.lua) to enable it.

?> Check out [mason-null-ls's instructions](https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md) for how the setup handler works.

### Nvim-lspconfig Setups

In very rare use cases, for example the javascript [flow](https://github.com/facebook/flow) LSP server, it's not existed in mason's package registries. So user will have to manually install it, and call the `require("lspconfig")["flow"].setup()` API to setup.

Please add the `lua/configs/neovim/nvim-lspconfig/setup_handlers.lua` file that returns the `setup_handlers` table, and each entry will be invoked with `require("lspconfig")[server_name].setup()` API to setup the LSP server. You can simply copy and rename [lua/configs/neovim/nvim-lspconfig/setup_handlers_sample.lua](https://github.com/linrongbin16/lin.nvim/blob/d910b5e4209ebf414aefde5174f944ad5e18c82e/lua/configs/neovim/nvim-lspconfig/setup_handlers_sample.lua?plain=1) to enable it.

### Formatters

This distro uses [conform.nvim](https://github.com/stevearc/conform.nvim) as code formatter, and needs to configure formatters explicitly. Please add the `lua/configs/stevearc/conform-nvim/formatters_by_ft.lua` file that returns a set of code formatters configuration. You can simply copy and rename the sample file [lua/configs/stevearc/conform-nvim/formatters_by_ft.lua](https://github.com/linrongbin16/lin.nvim/blob/3b567314f85f56c3397fcdba382ec53a5bfae953/lua/configs/stevearc/conform-nvim/formatters_by_ft_sample.lua) to enable it.

## Reference

- [nvim-lspconfig - LSP configurations](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md): All LSP configurations.
- [nvim-lspconfig - recommended specific language plugins](https://github.com/neovim/nvim-lspconfig/wiki/Language-specific-plugins): Enhancements for specific languages.
- [mason.nvim - Mason Package Index](https://github.com/williamboman/mason.nvim/blob/main/PACKAGES.md): Full LSP servers registered in mason.
- [mason-lspconfig.nvim - Available LSP servers](https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers): Available mason LSP servers.
- [none-ls - BUILTINS](https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md): None-ls built-in sources.
- [none-ls - BUILTIN_CONFIGS](https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md): None-ls built-in sources usage and configurations.
