# LSP Server Management

Unlike [coc.nvim](https://github.com/neoclide/coc.nvim), there's no such all-in-one framework in Neovim's world.

But with the help of [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig), [mason.nvim](https://github.com/williamboman/mason.nvim), [none-ls.nvim](https://github.com/nvimtools/none-ls.nvim), [neoconf.nvim](https://github.com/folke/neoconf.nvim) and several other plugins, managing lsp servers is just a piece of cake now.

## Plugins List

To bring lsp based auto-complete to user, quite a few plugins are assembled:

### [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)

Infrastructure for neovim lsp configurations, pre-requirement for all other lsp plugins.

### [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)

Auto-complete engine, it collects complete sources from other extensions, then provides suggestions when user typing:

- [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp): collect from lsp servers.
- [cmp-buffer](https://github.com/hrsh7th/cmp-buffer): collect from vim buffers.
- [cmp-async-path](https://github.com/FelipeLema/cmp-async-path): collect from filesystem path.
- [cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline): collect from vim command-line.
- [LuaSnip](https://github.com/L3MON4D3/LuaSnip) and [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip): collect from snippet.

### [mason.nvim](https://github.com/williamboman/mason.nvim)/[mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)

`mason` helps manage all the lsp servers: install, remove and update. Usually you need to manually maintain lsp servers for programming language (`clangd`, `pyright`, `jsonls`, etc), but with this plugin, now you can just type `:Mason` to finish all these things.

`mason-lspconfig` fills the gap between `mason.nvim` and `nvim-lspconfig.nvim`. With this plugin, now you can:

1. Ensure some lsp servers installed (please checkout [williamboman/mason-lspconfig-nvim/ensure_installed_sample.lua](https://github.com/linrongbin16/lin.nvim/blob/744e4c7fd9e0c55630a4881279eefe671bfcee43/lua/configs/williamboman/mason-lspconfig-nvim/ensure_installed_sample.lua)).
2. Avoid duplicated default setup handlers, e.g. `require('lspconfig')[server_name].setup()` (please checkout [williamboman/mason-lspconfig-nvim/setup_handlers_sample.lua](https://github.com/linrongbin16/lin.nvim/blob/744e4c7fd9e0c55630a4881279eefe671bfcee43/lua/configs/williamboman/mason-lspconfig-nvim/setup_handlers_sample.lua)).

### [none-ls.nvim](https://github.com/nvimtools/none-ls.nvim)(null-ls.nvim reloaded)/[mason-null-ls.nvim](https://github.com/jay-babu/mason-null-ls.nvim)

`none-ls` (null-ls) provide extra formatter/linter/code actions/diagnostics by injecting lsp server, with its sources.

> [!IMPORTANT]
>
> In this nvim configuration, we're using [conform.nvim](https://github.com/stevearc/conform.nvim) as formatter instead of none-ls, because it's much more performant and can correctly handle the confliction when multiple lsp servers trying to format the same buffer.

Sometimes just a lsp server is not enough, for example usually I use `luacheck` as an extra static lua syntax checker on a lua project, while it cannot be registered as a lsp server. In this case, we can register them as null-ls sources, thus lint code through lsp methods. Others such as `pylint`, `eslint`, `prettier`, `grammarly` are the same.

`mason-null-ls` can let `none-ls.nvim` use packages from `mason.nvim`, with this plugin you can:

1. Ensure `none-ls.nvim` sources installed via `mason.nvim` (please checkout [jay-babu/mason-null-ls-nvim/ensure_installed_sample.lua](https://github.com/linrongbin16/lin.nvim/blob/744e4c7fd9e0c55630a4881279eefe671bfcee43/lua/configs/jay-babu/mason-null-ls-nvim/ensure_installed_sample.lua)).
2. Automatically register them as `none-ls.nvim` sources (please checkout [jay-babu/mason-null-ls-nvim/setup_handlers_sample.lua](https://github.com/linrongbin16/lin.nvim/blob/744e4c7fd9e0c55630a4881279eefe671bfcee43/lua/configs/jay-babu/mason-null-ls-nvim/setup_handlers_sample.lua)).

### [Neoconf.nvim](https://github.com/folke/neoconf.nvim)

Configure lsp servers like [coc.nvim](https://github.com/neoclide/coc.nvim), also provide project-wise lsp configurations.

The global configuration is [neoconf.json](https://github.com/linrongbin16/lin.nvim/blob/744e4c7fd9e0c55630a4881279eefe671bfcee43/neoconf_sample.json).

> There're more UI improvement plugins leave to you to find out.

## Configuration

Usually all you need to install a lsp server is simply by one-line command `:Mason`, and that's all.

But in case you want more control on lsp server, please check out the following sections.

### LSP Server

1. Ensure installed

   To ensure a lsp server installed, configure the file [williamboman/mason-lspconfig-nvim/ensure_installed.lua](https://github.com/linrongbin16/lin.nvim/blob/744e4c7fd9e0c55630a4881279eefe671bfcee43/lua/configs/williamboman/mason-lspconfig-nvim/ensure_installed_sample.lua). Here's an example:

   ```lua
   local ensure_installed = {
     "lua_ls", -- lua
     "vimls", -- vim
     "jsonls", -- json
   }
   return ensure_installed
   ```

2. Customize LSP server

   To customize a LSP server, configure the file [williamboman/mason-lspconfig-nvim/setup_handlers.lua](https://github.com/linrongbin16/lin.nvim/blob/744e4c7fd9e0c55630a4881279eefe671bfcee43/lua/configs/williamboman/mason-lspconfig-nvim/setup_handlers_sample.lua). Here's an example:

   ```lua
   local lspconfig = require("lspconfig")
   local setup_handlers = {
     jsonls = function()
       lspconfig["jsonls"].setup({
         settings = {
           json = {
             schemas = require("schemastore").json.schemas(),
             validate = { enable = true },
           },
         },
     })
     end,
   }
   return setup_handlers
   ```

### None-ls Source

1. Ensure installed

   To ensure a none-ls source installed, configure the file [jay-babu/mason-null-ls-nvim/ensure_installed.lua](https://github.com/linrongbin16/lin.nvim/blob/744e4c7fd9e0c55630a4881279eefe671bfcee43/lua/configs/jay-babu/mason-null-ls-nvim/ensure_installed_sample.lua). Here's an example:

   ```lua
   local ensure_installed = {
     "markdownlint", -- markdown
     "luacheck", -- lua
     "eslint", -- js/ts lint
   }
   return ensure_installed
   ```

2. Customize none-ls source setup

   To customize a none-ls source setup, configure the file [jay-babu/mason-null-ls-nvim/setup_handlers.lua](https://github.com/linrongbin16/lin.nvim/blob/744e4c7fd9e0c55630a4881279eefe671bfcee43/lua/configs/jay-babu/mason-null-ls-nvim/setup_handlers_sample.lua). Here's an example:

   ```lua
   local null_ls = require("null-ls")
   local setup_handlers = {
     -- Custom setup.
     stylua = function(source, methods)
       null_ls.register(null_ls.builtins.formatting.stylua)
     end,
   }
   return setup_handlers
   ```

### Nvim-lspconfig

For those lsp servers cannot be installed via `mason.nvim`, we have to manually install and setup them in the file [neovim/nvim-lspconfig/setup_handlers.lua](https://github.com/linrongbin16/lin.nvim/blob/744e4c7fd9e0c55630a4881279eefe671bfcee43/lua/configs/neovim/nvim-lspconfig/setup_handlers_sample.lua). Here's an example:

```lua
local setup_handlers = {
    ["flow"] = {},
}
return setup_handlers
```

> The LSP server `flow` is shipped with the `flow` cli, it doesn't exist in mason.

### Format on Save

To configure the formatter [conform.nvim](https://github.com/stevearc/conform.nvim), configure the file [stevearc/conform-nvim/formatters_by_ft.lua](https://github.com/linrongbin16/lin.nvim/blob/3b567314f85f56c3397fcdba382ec53a5bfae953/lua/configs/stevearc/conform-nvim/formatters_by_ft_sample.lua).

Here's an example:

```lua
local prettier = { "prettierd", "prettier" }

local formatters_by_ft = {
    bash = { "shfmt" },
    c = { "clang_format" },
    css = { prettier },
    cpp = { "clang_format" },
    cmake = { "cmake_format" },
    html = { prettier },
    javascript = { "biome", prettier },
    javascriptreact = { "biome", prettier },
    json = { "biome", prettier },
    lua = { "stylua" },
    markdown = { prettier },
    python = { "ruff", { "isort", "black" } },
    sh = { "shfmt" },
    typescript = { "biome", prettier },
    typescriptreact = { "biome", prettier },
    xhtml = { prettier },
    xml = { prettier },
}

return formatters_by_ft
```

## Reference

- [nvim-lspconfig - LSP configurations](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md) for all LSP configurations.
- [nvim-lspconfig - recommended specific language plugins](https://github.com/neovim/nvim-lspconfig/wiki/Language-specific-plugins) for enhancements for specific languages.
- [mason.nvim - Mason Package Index](https://github.com/williamboman/mason.nvim/blob/main/PACKAGES.md) for full LSP servers list.
- [mason-lspconfig.nvim - Available LSP servers](https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers) for available mason LSP servers list.
- [null-ls - BUILTINS](https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md) for all null-ls builtin configs.
