# LSP Server Management

Unlike [coc.nvim](https://github.com/neoclide/coc.nvim), there's no such all-in-one framework in Neovim's world. But with the help of a bunch of plugins, managing lsp servers is just a piece of cake now.

## Introduction

To bring LSP based IDE features to user, quite a few plugins are assembled:

- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig): Pre-requirement infrastructure for other lsp plugins.
- [mason.nvim](https://github.com/mason-org/mason.nvim): Manages all the lsp servers to avoid manual work, a simply `:Mason` command can finish all the tasks.
- [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim): Set up LSP servers automatically, i.e. you don't need to call `require("lspconfig")[server_name].setup()` (or `vim.lsp.enable()`) for all lsp servers.
- [none-ls.nvim](https://github.com/nvimtools/none-ls.nvim)(null-ls.nvim reloaded): Provides extra linters, code actions, diagnostics by injecting a lsp server. NOTE: None-ls doesn't format code.
- [mason-null-ls.nvim](https://github.com/jay-babu/mason-null-ls.nvim): Lets none-ls directly use mason packages, and automatically registered as none-ls's sources.
- [conform.nvim](https://github.com/stevearc/conform.nvim): Code formatter.

## Configuration

### LSP Servers

To customize a LSP server, please enable the [`lua/configs/neovim/nvim-lspconfig/setup_handlers.lua`](https://github.com/linrongbin16/lin.nvim/blob/59fcdd16024006796f0825794f3c2173a8a2a306/lua/configs/neovim/nvim-lspconfig/setup_handlers_sample.lua?plain=1) file, and edit the LSP server configuration.

### Code Formatters

To format code, please enable the [`lua/configs/stevearc/conform-nvim/formatters_by_ft.lua`](https://github.com/linrongbin16/lin.nvim/blob/59fcdd16024006796f0825794f3c2173a8a2a306/lua/configs/stevearc/conform-nvim/formatters_by_ft_sample.lua?plain=1) file, and edit the formatter configuration.

## Reference

- [nvim-lspconfig - LSP configurations](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md)
- [nvim-lspconfig - recommended specific language plugins](https://github.com/neovim/nvim-lspconfig/wiki/Language-specific-plugins)
- [mason.nvim - Mason Package Index](https://github.com/mason-org/mason.nvim/blob/main/PACKAGES.md)
- [none-ls - BUILTINS](https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md)
- [none-ls - BUILTIN_CONFIGS](https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md)
