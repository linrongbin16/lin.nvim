lua<<EOF
    local lspconfig = require('lspconfig')
    local mason_lspconfig=require("mason-lspconfig")
    local null_ls = require("null-ls")
    local mason_null_ls = require("mason-null-ls")
    local lsp_status = require('lsp-status')

    -- {{
    -- To add new LSP server for language, you need to define possibly 4 components in below configurations:
    --
    -- LSP server configurations
    --
    -- Key:
    --  Language, ensure this field is unique. Notice this field is just a hint, not actually been used.
    -- Value:
    --  1. Ensure installed LSP server(for mason-lspconfig), set 'nil' if not used.
    --  2. Extra formatters/linters(for null-ls), set 'nil' if not used.
    --  3. Extra sources(for null-ls), set 'nil' if not used.
    local lsp_servers = {
        protobuf = {"bufls", nil, nil},
        c = {"clangd", nil, nil},
        cmake = {"cmake", nil, nil},
        css = {"cssls", nil, nil},
        cssmodules = {"cssmodules_ls", nil, nil},
        eslint = {"eslint", {"eslint"}, {null_ls.builtins.code_actions.eslint}},
        grammar = {"grammarly", nil, nil},
        graphql = {"graphql", nil, nil},
        html = {"html", nil, nil},
        xml = {"lemminx", nil, nil},
        json = {"jsonls", nil, nil},
        javascript = {"tsserver", nil, nil},
        lua = {"sumneko_lua", nil, nil},
        markdown = {"marksman", nil, nil},
        -- prettierd is not a LSP server in mason, but we use it as a powerful formatter for js/ts/md/json/html/etc.
        prettier = {nil, {"prettierd"}, {null_ls.builtins.formatting.prettierd}},
        -- pyright does not provide formatting, so we add black/isort to null-ls, as python formatter.
        python = {"pyright", {"black", "isort"}, {null_ls.builtins.formatting.black, null_ls.builtins.formatting.isort}},
        rust = {"rust_analyzer", nil, nil},
        sql = {"sqlls", nil, nil},
        toml = {"taplo", nil, nil},
        yaml = {"yamlls", nil, nil},
        vim = {"vimls", nil, nil},
    }
    if vim.fn.has('win32') == 1 then
        -- powershell for windows
        lsp_servers.powershell = {"powershell_es", nil, nil}
    else
        -- bash for UNIX/Linux/macOS
        lsp_servers.bash = {"bashls", {"shfmt"}, {null_ls.builtins.formatting.shfmt}}
    end
    -- }}


    -- {{
    -- The real setup work goes here.

    -- Setup mason-lspconfig
    local mason_lspconfig_ensure_installed = {}
    -- print("mason_lspconfig_ensure_installed")
    for lang, config in pairs(lsp_servers) do
        -- print(lang, ": ", config[1])
        local server = config[1]
        if server ~= nil then
            -- print(lang, ": ", config[1], " -- inserted")
            table.insert(mason_lspconfig_ensure_installed, server)
        end
    end
    mason_lspconfig.setup {
        ensure_installed = mason_lspconfig_ensure_installed,
    }

    -- Setup nvim-lspconfig
    mason_lspconfig.setup_handlers {
        -- Default server setup for nvim-lspconfig.
        function (server)
            lspconfig[server].setup {
                on_attach = lsp_status.on_attach,
                capabilities = lsp_status.capabilities
            }
        end,
        -- Specific server setup.
        -- ["rust_analyzer"] = function ()
        --     require("rust-tools").setup {}
        -- end
    }

    -- Setup null-ls
    local null_ls_sources = {}
    -- print("null_ls_sources")
    for lang, config in pairs(lsp_servers) do
        -- print(lang, ": ", config[3])
        local sources = config[3]
        if sources ~= nil then
            for index, source in ipairs(sources) do
                -- print(lang, ": (", index, ") ", source, " inserted")
                table.insert(null_ls_sources, source)
            end
        end
    end
    null_ls.setup({
        sources = null_ls_sources,
    })

    -- Setup mason-null-ls
    local mason_null_ls_ensure_installed = {}
    -- print("mason_null_ls_ensure_installed")
    for lang, config in pairs(lsp_servers) do
        -- print(lang, ": ", config[2])
        local formatters = config[2]
        if formatters ~= nil then
            for index, formatter in ipairs(formatters) do
                -- print(lang, ": (", index, ") ", formatter, " inserted")
                table.insert(mason_null_ls_ensure_installed, formatter)
            end
        end
    end
    mason_null_ls.setup({
        ensure_installed = mason_null_ls_ensure_installed,
    })

    -- }}
EOF
