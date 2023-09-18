-- Please copy this file to 'linters_by_ft.lua' to enable it.

-- Configure linters by filetypes.

local eslint = { "eslint_d", "eslint" }

local linters_by_ft = {
    markdown = { "markdownlint" },
    javascript = { eslint },
    typescript = { eslint },
}

return linters_by_ft
