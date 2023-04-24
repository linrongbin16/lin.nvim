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

local found_setup_handler, setup_handler =
    pcall(require, "repo.hrsh7th.nvim-cmp.setup_handler")

if not found_setup_handler then
    local luasnip = require("luasnip")
    local select_opts = { behavior = cmp.SelectBehavior.Select }
    setup_handler = {
        completion = {
            completeopt = "menu,menuone,noinsert",
        },
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        sources = cmp.config.sources({
            { name = "nvim_lsp", keyword_length = 2 },
            { name = "luasnip", keyword_length = 2 },
        }, {
            { name = "buffer", keyword_length = 2 },
            { name = "path", keyword_length = 2 },
            { name = "tags", keyword_length = 2 },
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
end

cmp.setup(setup_handler)

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
        { name = "buffer" },
    }),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer", keyword_length = 2 },
    },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path", keyword_length = 2 },
    }, {
        { name = "cmdline", keyword_length = 2 },
    }),
})

-- Work with nvim-autopairs
local autopairs_cmp = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", autopairs_cmp.on_confirm_done())