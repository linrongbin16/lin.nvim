-- Please copy this file to 'linters_by_ft.lua' to enable it.

-- Configure linters by filetypes.

local eslint = { "eslint_d", "eslint" }

local linters_by_ft = {
    lua = { "luacheck" },
    markdown = { "markdownlint" },
    python = { "ruff", "mypy", "pylint" },
    javascript = { eslint },
    javascriptreact = { eslint },
    typescript = { eslint },
    typescriptreact = { eslint },
}

return linters_by_ft
