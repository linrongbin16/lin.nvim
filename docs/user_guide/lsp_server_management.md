# LSP Server Management

Unlike [coc.nvim](https://github.com/neoclide/coc.nvim), there's no such all-in-one framework in Neovim's world. But with the help of a bunch of plugins, managing lsp servers is just a piece of cake now.

## Introduction

To bring LSP based IDE features to user, quite a few plugins are assembled:

- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig): Infrastructure for neovim lsp configurations, pre-requirement for all other lsp plugins.
- [mason.nvim](https://github.com/mason-org/mason.nvim): It helps manage all the lsp servers: install, remove and update. Usually you need to manually maintain lsp servers for programming language (`clangd`, `pyright`, `jsonls`, etc), but with this plugin, now you can just type `:Mason` to finish all these things.
- [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim): It helps setup LSP servers automatically, i.e. you don't need to call `require("lspconfig")[server_name].setup()` (or `vim.lsp.enable()`) for every lsp server.
- [none-ls.nvim](https://github.com/nvimtools/none-ls.nvim)(null-ls.nvim reloaded): It provides linters, code actions, diagnostics by injecting a lsp server. NOTE: This distro uses [conform.nvim](https://github.com/stevearc/conform.nvim) as code formatter, so none-ls doesn't format code.
- [mason-null-ls.nvim](https://github.com/jay-babu/mason-null-ls.nvim): It lets none-ls directly using packages installed by `mason.nvim`, and automatically registered as none-ls's sources.

## Configuration

### LSP Servers

With the `:Mason` command, it usually satisfies most use cases.

?> Check out [mason-lspconfig's Available LSP servers](https://github.com/mason-org/mason-lspconfig.nvim#available-lsp-servers) for available LSP servers.

To customize a LSP server setup configuration, please add the `lua/configs/mason-org/mason-lspconfig-nvim/setup_handlers.lua` file that returns the `setup_handlers` table passed to `require("mason-lspconfig").setup_handlers()` API as parameter. You can simply copy and rename the sample file [lua/configs/mason-org/mason-lspconfig-nvim/setup_handlers_sample.lua](https://github.com/linrongbin16/lin.nvim/blob/744e4c7fd9e0c55630a4881279eefe671bfcee43/lua/configs/mason-org/mason-lspconfig-nvim/setup_handlers_sample.lua) to enable it.

?> Check out [mason-lspconfig's documentation](https://github.com/mason-org/mason-lspconfig.nvim/blob/37a336b653f8594df75c827ed589f1c91d91ff6c/doc/mason-lspconfig.txt#L164) for how the setup handler works.

### None-ls Sources

Usually it works out of the box, without any additional configurations.

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
- [mason.nvim - Mason Package Index](https://github.com/mason-org/mason.nvim/blob/main/PACKAGES.md): Full LSP servers registered in mason.
- [mason-lspconfig.nvim - Available LSP servers](https://github.com/mason-org/mason-lspconfig.nvim#available-lsp-servers): Available mason LSP servers.
- [none-ls - BUILTINS](https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md): None-ls built-in sources.
- [none-ls - BUILTIN_CONFIGS](https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md): None-ls built-in sources usage and configurations.
