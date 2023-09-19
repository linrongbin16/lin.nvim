-- Please copy this file to 'formatters_by_ft.lua' to enable it.

-- Configure formatters by filetypes.
-- This module will be passed to `require("conform").setup({ formatters_by_ft = ... })`.

local prettier = { "prettierd", "prettier" }

local formatters_by_ft = {
    bash = { "shfmt" },
    c = { "clang_format" },
    css = { prettier },
    cpp = { "clang_format" },
    cmake = { "cmake_format" },
    html = { prettier },
    javascript = { "biome", prettier },
    javascriptreact = { "biome", prettier },
    json = { "biome", prettier },
    lua = { "stylua" },
    markdown = { prettier },
    python = { "ruff", { "isort", "black" } },
    sh = { "shfmt" },
    typescript = { "biome", prettier },
    typescriptreact = { "biome", prettier },
    xhtml = { prettier },
    xml = { prettier },
}

return formatters_by_ft
