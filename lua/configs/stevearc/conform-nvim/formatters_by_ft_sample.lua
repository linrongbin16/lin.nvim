-- Please copy this file to 'formatters_by_ft.lua' to enable it.

-- Configure formatters by filetypes.
-- This module will be passed to `require("conform").setup({ formatters_by_ft = ... })`.

local biome_or_prettier_d = { "biome", "prettierd", "prettier" }

local formatters_by_ft = {
    bash = { "shfmt" },
    c = { "clang_format" },
    css = { biome_or_prettier_d },
    cpp = { "clang_format" },
    cmake = { "cmake_format" },
    html = { biome_or_prettier_d },
    javascript = { biome_or_prettier_d },
    javascriptreact = { biome_or_prettier_d },
    json = { biome_or_prettier_d },
    jsonc = { biome_or_prettier_d },
    lua = { "stylua" },
    markdown = { biome_or_prettier_d },
    python = { "isort", "black" },
    sh = { "shfmt" },
    typescript = { biome_or_prettier_d },
    typescriptreact = { biome_or_prettier_d },
    xhtml = { biome_or_prettier_d },
    xml = { biome_or_prettier_d },
    rust = { "rustfmt" },
}

return formatters_by_ft
