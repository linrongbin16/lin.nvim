local cmp = require("cmp")

local setup_handler = {
    sources = cmp.config.sources({
        { name = "nvim_lsp", keyword_length = 2 },
        { name = "luasnip", keyword_length = 2 },
    }, {
        { name = "copilot", keyword_length = 2 }, -- github copilot
        { name = "buffer", keyword_length = 2 },
        { name = "path", keyword_length = 2 },
        { name = "tags", keyword_length = 2 }, -- tags
    }),
    sorting = {
        priority_weight = 2,
        comparators = {
            require("copilot_cmp.comparators").prioritize, -- github copilot
            cmp.config.compare.offset,
            cmp.config.compare.scopes,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
}

return setup_handler