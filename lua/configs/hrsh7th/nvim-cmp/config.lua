-- cmp_nvim_lsp
local lspconfig = require("lspconfig")
local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend(
    "force",
    lsp_defaults.capabilities,
    require("cmp_nvim_lsp").default_capabilities()
)

-- nvim-cmp
-- require('luasnip.loaders.from_vscode').lazy_load()
local cmp = require("cmp")
local luasnip = require("luasnip")
local select_opts = { behavior = cmp.SelectBehavior.Select }
local setup_handler = {
    -- performance = {
    -- debounce = 50,
    -- throttle = 50,
    -- fetching_timeout = 50,
    -- },
    completion = {
        completeopt = "menu,menuone,noinsert",
        keyword_length = 2,
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
    }, {
        { name = "buffer" },
        { name = "async_path" },
    }),
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    formatting = {
        -- fields = { "menu", "abbr", "kind" },
        format = require("lspkind").cmp_format({
            mode = "symbol",
            menu = {
                buffer = "[BUF]",
                nvim_lsp = "[LSP]",
                luasnip = "[SNIP]",
                tags = "[TAGS]",
                path = "[PATH]",
                async_path = "[PATH]",
                cmdline = "[CMD]",
                copilot = "[COPILOT]",
            },
            symbol_map = { Copilot = "" },
            maxwidth = 50,
            ellipsis_char = "…",
        }),
    },
    mapping = cmp.mapping.preset.insert({
        ["<Up>"] = cmp.mapping.select_prev_item(select_opts),
        ["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
        ["<Down>"] = cmp.mapping.select_next_item(select_opts),
        ["<C-n>"] = cmp.mapping.select_next_item(select_opts),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm({ select = true })
            else
                -- If you use vim-endwise, this fallback will behave the same as vim-endwise.
                fallback()
            end
        end, { "i", "s" }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            local col = vim.fn.col(".") - 1
            if cmp.visible() then
                cmp.confirm({ select = true })
            elseif
                col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
            then
                fallback()
            else
                cmp.complete()
            end
        end, { "i", "s" }),
        ["<C-f>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<C-b>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
}

local user_setup_handler_ok, user_setup_handler =
    pcall(require, "configs.hrsh7th.nvim-cmp.setup_handler")

if user_setup_handler_ok then
    setup_handler = vim.tbl_deep_extend(
        "force",
        vim.deepcopy(setup_handler),
        user_setup_handler
    )
end

cmp.setup(setup_handler)

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
        { name = "buffer" },
    }),
})

--- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" },
    },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "async_path" },
    }, {
        {
            name = "cmdline",
            option = {
                ignore_cmds = { "Man", "!", "tag" },
            },
        },
    }),
})

-- Work with nvim-autopairs
local autopairs_cmp = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", autopairs_cmp.on_confirm_done())