lua<<EOF
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require("mason-lspconfig").setup {
    ensure_installed = {
        -- bash
        "bashls",
        -- c/c++
        "clangd",
        -- cmake
        "cmake",
        -- css
        "cssls",
        "cssmodules_ls",
        -- eslint
        "eslint",
        -- go
        "gopls",
        -- grammarly
        "grammarly",
        -- graphql
        "graphql",
        -- html
        "html",
        -- json
        "jsonls",
        -- js/ts
        "tsserver",
        -- lua
        "sumneko_lua",
        -- markdown
        "remark_ls",
        -- powershell
        "powershell_es",
        -- python
        "pyright",
        -- reason
        "reason_ls",
        -- rust
        "rust_analyzer",
        -- sql,
        "sqlls",
        -- toml
        "taplo",
        -- vue
        "volar",
        -- yaml
        "yamlls",
    },
}
EOF
