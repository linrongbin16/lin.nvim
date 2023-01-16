lua<<EOF

    -- {{ Add new LSP server
    -- Please refer to [Mason Package Index](https://github.com/williamboman/mason.nvim/blob/main/PACKAGES.md#mason-package-index) for more LSP servers.

    local embeded_lsp_servers = {
        -- clang
        "clangd",
        -- cmake
        "cmake-language-server",
        -- css
        "css-lsp",
        "cssmodules-language-server",
        -- grammar
        "grammarly-languageserver",
        -- graphql
        "graphql-language-service-cli",
        -- html
        "html-lsp",
        -- json
        "json-lsp",
        -- js/ts
        "typescript-language-server",
        "eslint_d",
        "prettierd",
        -- lua
        "lua-language-server",
        -- markdown
        "marksman",
        -- protobuf
        "buf-language-server",
        -- python
        "pyright",
        "black",
        "isort",
        -- rust
        "rust_analyzer",
        -- sql
        "sqlfluff",
        -- toml
        "taplo",
        -- yaml
        "yaml-language-server",
        -- vim
        "vim-language-server",
        -- xml
        "lemminx",
    }
    if vim.fn.has('win32') == 1 then
        -- powershell for windows
        table.insert(embeded_lsp_servers, "powershell-editor-services")
    else
        -- bash for UNIX/Linux/macOS
        table.insert(embeded_lsp_servers, "bash-language-server")
        table.insert(embeded_lsp_servers, "shfmt")
    end

    -- Add new LSP server }}


    -- {{
    -- ---- The real setup work goes here ----

    -- Setup nvim-lspconfig
    require("mason-lspconfig").setup_handlers {
        -- Default server setup for nvim-lspconfig.
        function (server)
            require('lspconfig')[server].setup {
                on_attach = require('lsp-status').on_attach,
                capabilities = require('lsp-status').capabilities
            }
        end,

        -- Specific server setup.
        -- ["rust_analyzer"] = function ()
        --     require("rust-tools").setup {}
        -- end
    }

    -- Setup mason-tool-installer
    require('mason-tool-installer').setup {
        ensure_installed = embeded_lsp_servers,
    }

    -- }}
EOF
