local cmp = require("cmp")
local keyword = 2

local sources = cmp.config.sources({
    { name = "nvim_lsp", keyword_length = keyword },
    { name = "luasnip", keyword_length = keyword },
}, {
    { name = "copilot", keyword_length = keyword }, -- github copilot
    { name = "buffer", keyword_length = keyword },
    { name = "path", keyword_length = keyword },
    { name = "tags", keyword_length = keyword },
})

return sources