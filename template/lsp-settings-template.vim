lua<<EOF
    local null_ls = require("null-ls")

    -- {{
    -- ---- Add new LSP server ----
    --
    -- Case-1: Add LSP server name in 'embeded_servers'.
    --  LSP server is working as nvim-cmp sources, installed through mason.
    --  Please refer to:
    --      * [mason-lspconfig Available LSP servers](https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers) for more LSP servers.
    --
    -- Case-2: Add extra null-ls source in 'embeded_extras'.
    --  Extra null-ls source is working as null-ls source(formatter/linter/diagnostic/codeAction/etc), installed through mason-null-ls.
    --  Please refer to:
    --      * [mason-null-ls Available Null-ls sources](https://github.com/jay-babu/mason-null-ls.nvim#available-null-ls-sources) for more null-ls sources.
    --      * [null-ls BUILTINS](https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md) for null-ls source configurations.

    local embeded_servers = {
        -- clang
        "clangd",
        -- cmake
        "cmake",
        -- css
        "cssls",
        "cssmodules_ls",
        -- grammar
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
        "marksman",
        -- protobuf
        "bufls",
        -- python
        "pyright",
        -- rust
        "rust_analyzer",
        -- sql
        "sqlls",
        -- toml
        "taplo",
        -- yaml
        "yamlls",
        -- vim
        "vimls",
        -- xml
        "lemminx",
    }
    local embeded_extras = {
        -- js/ts
        {
            -- Some eslint_d and prettierd are not valid LSP servers,
            -- They're not working through nvim-cmp when editing js/ts files.
            -- So we registered them as null-ls sources to let them work.
            "eslint_d",
            {
                null_ls.builtins.diagnostics.eslint_d,
                null_ls.builtins.formatting.eslint_d,
                null_ls.builtins.code_actions.eslint_d,
            }
        },
        { "prettierd", { null_ls.builtins.formatting.prettierd } },
        -- python
        { "black", { null_ls.builtins.formatting.black } }, -- Since pyright doesn't include code format.
        { "isort", { null_ls.builtins.formatting.isort } }, -- So registered black/isort as null-ls sources to let them work.
    }
    if vim.fn.has('win32') == 1 then
        -- powershell for windows
        table.insert(embeded_servers, "powershell_es")
    else
        -- bash for UNIX/Linux/macOS
        table.insert(embeded_servers, "bashls")
        table.insert(embeded_extras, { "shfmt", { null_ls.builtins.formatting.shfmt } })
    end

    -- }}


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

    -- Setup mason-lspconfig
    local ensure_installed_servers = {}
    for i, server in ipairs(embeded_servers) do
        table.insert(ensure_installed_servers, server)
    end
    require('mason-lspconfig').setup {
        ensure_installed = ensure_installed_servers,
    }

    -- Setup mason-null-ls and null-ls configs
    local ensure_installed_extras = {}
    local null_ls_sources = {}
    -- print('null-ls')
    for i, extra in ipairs(embeded_extras) do
        local name = extra[1]
        table.insert(ensure_installed_extras, name)
        local configs = extra[2]
        -- print('i:', i, ", name:", name, ", configs:", configs, ", configs.length:", #configs)
        for j, conf in ipairs(configs) do
            -- print('j:', j, ", conf:", conf)
            table.insert(null_ls_sources, conf)
        end
    end
    require("mason-null-ls").setup({
        ensure_installed = ensure_installed_extras,
    })
    null_ls.setup({
        sources = null_ls_sources,
    })


    -- }}
EOF
