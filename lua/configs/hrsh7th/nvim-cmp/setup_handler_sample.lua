-- Please copy this file to 'setup_handler.lua' to enable it.

local cmp = require("cmp")

local setup_handler = {
    completion = {
        completeopt = "menu,menuone,noinsert",
        keyword_length = 2,
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
    }, {
        { name = "copilot" }, -- github copilot
        { name = "buffer" },
        { name = "async_path" },
        {
            name = "tags",
            option = {
                -- performant for super big codebase
                exact_match = true,
                current_buffer_only = true,
            },
        }, -- tags
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