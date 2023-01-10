lua<<EOF
    local lspconfig = require('lspconfig')
    local mason_lspconfig=require("mason-lspconfig")
    local null_ls = require("null-ls")

    -- Add LSP server here
    local mason_lspconfig_servers = {
        "clangd", -- c/c++
        "cmake", -- cmake
        "cssls", -- css
        "cssmodules_ls",
        "eslint", -- js/ts
        "gopls", -- go
        "grammarly", -- markdown
        "graphql", -- graphql
        "html", -- html
        "jsonls", -- json
        "tsserver", -- js/ts
        "sumneko_lua", -- lua
        "marksman", -- markdown
        "pyright", -- python
        "rust_analyzer", -- rust
        "sqlls", -- sql,
        "taplo", -- toml
        "yamlls", -- yaml
        "vimls", -- vim
    }
    if vim.fn.has('win32') then
        -- powershell
        table.insert(mason_lspconfig_servers, "powershell_es")
    else
        -- bash
        table.insert(mason_lspconfig_servers, "bashls")
    end

    -- Register LSP server to lspconfig here
    local lspconfig_servers = {
    }

    -- Add formatter here
    local null_ls_servers = {

    }

    -- Setup
    require("mason-lspconfig").setup {
        ensure_installed = mason_lspconfig_servers,
    }
EOF
