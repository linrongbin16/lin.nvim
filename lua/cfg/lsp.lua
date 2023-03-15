-- Case-1: Add LSP server name in 'embeded_servers'.
--  LSP server is working as nvim-cmp sources, installed by mason-lspconfig.
--  Please refer to:
--      * [mason-lspconfig Available LSP servers](https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers) for more LSP servers.
--      * [nvim-lspconfig's language specific plugins](https://github.com/neovim/nvim-lspconfig/wiki/Language-specific-plugins) for more specific language plugins.
--
-- Case-2: Add extra null-ls source in 'embeded_extras'.
--  Extra null-ls source is working as null-ls sources, installed by mason-null-ls.
--  Please refer to:
--      * [mason-null-ls Available Null-ls sources](https://github.com/jay-babu/mason-null-ls.nvim#available-null-ls-sources) for more null-ls sources.
--      * [null-ls BUILTINS](https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md) for null-ls source configurations.

local null_ls = require("null-ls")
local lspconfig = require("lspconfig")

local function lsp_on_attach(client, bufnr)
    local map = require("cfg.keymap").map

    -- attach navic to work with multiple tabs
    if client.server_capabilities["documentSymbolProvider"] then
        require("nvim-navic").attach(client, bufnr)
    end

    local function diagnostic_goto(next, severity)
        local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
        severity = severity and vim.diagnostic.severity[severity] or nil
        return function()
            go({ severity = severity })
        end
    end

    local function make_desc(value)
        return { buffer = true, desc = value }
    end

    -- lsp key mappings
    -- navigation
    if vim.fn.exists(":Glance") > 0 then
        map(
            "n",
            "gd",
            "<CMD>Glance definitions<CR>",
            make_desc("Go to definitions")
        )
        map(
            "n",
            "gt",
            "<CMD>Glance type_definitions<CR>",
            make_desc("Go to type definitions")
        )
        map(
            "n",
            "gi",
            "<CMD>Glance implementations<CR>",
            make_desc("Go to implementations")
        )
        map(
            "n",
            "gr",
            "<CMD>Glance references<CR>",
            make_desc("Go to references")
        )
    else
        map(
            "n",
            "gd",
            "<cmd>lua vim.lsp.buf.definition()<cr>",
            make_desc("Go to definitions")
        )
        map(
            "n",
            "gt",
            "<cmd>lua vim.lsp.buf.type_definition()<cr>",
            make_desc("Go to type definitions")
        )
        map(
            "n",
            "gi",
            "<cmd>lua vim.lsp.buf.implementation()<cr>",
            make_desc("Go to implementations")
        )
        map(
            "n",
            "gr",
            "<cmd>lua vim.lsp.buf.references()<cr>",
            make_desc("Go to references")
        )
    end
    map(
        "n",
        "gD",
        "<cmd>lua vim.lsp.buf.declaration()<cr>",
        make_desc("Go to declarations")
    )
    map(
        "n",
        "<leader>ic",
        "<cmd>lua vim.lsp.buf.incoming_calls()<cr>",
        make_desc("Go to incoming calls")
    )
    map(
        "n",
        "<leader>og",
        "<cmd>lua vim.lsp.buf.outgoing_calls()<cr>",
        make_desc("Go to outgoing calls")
    )

    -- hover
    map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", make_desc("Show hover"))

    map(
        { "n", "i" },
        "<C-k>",
        "<cmd>lua vim.lsp.buf.signature_help()<cr>",
        make_desc("Show signature help")
    )

    -- operation
    map(
        "n",
        "<Leader>rn",
        "<cmd>lua vim.lsp.buf.rename()<cr>",
        make_desc("Rename symbol")
    )
    map(
        { "n", "x" },
        "<Leader>cf",
        "<cmd>lua vim.lsp.buf.format({async=false})<cr>",
        make_desc("Code format")
    )
    map(
        "n",
        "<Leader>ca",
        "<cmd>lua vim.lsp.buf.code_action()<cr>",
        make_desc("Code actions")
    )
    map(
        "x",
        "<Leader>ca",
        "<cmd>lua vim.lsp.buf.range_code_action()<cr>",
        make_desc("Code actions")
    )

    -- diagnostic
    map(
        "n",
        "<Leader>dc",
        "<cmd>lua vim.diagnostic.open_float()<cr>",
        make_desc("Show diagnostic under cursor")
    )
    map("n", "]d", diagnostic_goto(true), make_desc("Next diagnostic item"))
    map(
        "n",
        "[d",
        diagnostic_goto(false),
        make_desc("Previous diagnostic item")
    )
    map(
        "n",
        "]e",
        diagnostic_goto(true, "ERROR"),
        make_desc("Next diagnostic error")
    )
    map(
        "n",
        "[e",
        diagnostic_goto(false, "ERROR"),
        make_desc("Previous diagnostic error")
    )
    map(
        "n",
        "]w",
        diagnostic_goto(true, "WARN"),
        make_desc("Next diagnostic warning")
    )
    map(
        "n",
        "[w",
        diagnostic_goto(false, "WARN"),
        make_desc("Previous diagnostic warning")
    )

    -- switch header/source for c/c++
    map(
        "n",
        "<leader>cs",
        ":ClangdSwitchSourceHeader<CR>",
        { silent = false, desc = "Switch between c/c++ header and source" }
    )

    -- (silently)detach lsp client when close buffer
    vim.api.nvim_create_autocmd("BufDelete", {
        buffer = bufnr,
        callback = function()
            vim.cmd(
                string.format(
                    "silent lua vim.lsp.buf_detach_client(%d,%d)",
                    bufnr,
                    client.id
                )
            )
        end,
    })
    -- format on save and load buffer
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format()
            end,
        })
    end
end

-- { mason's config
local embeded_servers = {}
local embeded_servers_setups = {
    -- default setup
    function(server)
        lspconfig[server].setup({
            on_attach = function(client, bufnr)
                lsp_on_attach(client, bufnr)
            end,
        })
    end,
    -- specific setup
    tsserver = function()
        lspconfig["tsserver"].setup({
            on_attach = function(client, bufnr)
                lsp_on_attach(client, bufnr)
            end,
            root_dir = function(fname)
                -- disable tsserver when detect flow
                return lspconfig.util.root_pattern("tsconfig.json")(fname)
                    or not lspconfig.util.root_pattern(".flowconfig")(fname)
                        and lspconfig.util.root_pattern(
                            "package.json",
                            "jsconfig.json",
                            ".git"
                        )(fname)
            end,
        })
    end,
    -- clangd = function()
    --   require("clangd_extensions").setup({
    --     on_attach = function(client, bufnr)
    --       attach_ext(client, bufnr)
    --     end,
    --   })
    -- end,
    -- ["rust_analyzer"] = function()
    --   require("rust-tools").setup({
    --     on_attach = function(client, bufnr)
    --       attach_ext(client, bufnr)
    --     end,
    --   })
    -- end,
}
-- } mason's config

-- { null-ls's config
local embeded_nullls = {}
local embeded_nullls_setups = {
    -- default setup
    function(source, methods)
        require("mason-null-ls.automatic_setup")(source, methods)
    end,
    -- specific setup
    -- stylua = function(source, methods)
    --   null_ls.register(null_ls.builtins.formatting.stylua)
    -- end,
}
-- } null-ls's config

-- { lspconfig's setup

local embeded_lspconfig_setups = {
    ["flow"] = {
        on_attach = function(client, bufnr)
            lsp_on_attach(client, bufnr)
        end,
    },
}

-- } lspconfig's setup

-- }

-- { ---- The real config work goes here ----

-- Setup mason-lspconfig
require("mason-lspconfig").setup({ ensure_installed = embeded_servers })
require("mason-lspconfig").setup_handlers(embeded_servers_setups)

-- Setup mason-null-ls and null-ls configs
require("mason-null-ls").setup({
    ensure_installed = embeded_nullls,
})
require("mason-null-ls").setup_handlers(embeded_nullls_setups)
null_ls.setup({
    on_attach = function(client, bufnr)
        lsp_on_attach(client, bufnr)
    end,
})

-- Setup nvim-lspconfig
for name, cfg in pairs(embeded_lspconfig_setups) do
    lspconfig[name].setup(cfg)
end

-- }