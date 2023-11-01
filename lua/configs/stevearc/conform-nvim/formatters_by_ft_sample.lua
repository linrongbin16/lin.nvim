-- Please copy this file to 'formatters_by_ft.lua' to enable it.

-- Configure formatters by filetypes.
-- This module will be passed to `require("conform").setup({ formatters_by_ft = ... })`.

local formatters_by_ft = {
    bash = { "shfmt" },
    c = { "clang_format" },
    css = { "prettier" },
    cpp = { "clang_format" },
    cmake = { "cmake_format" },
    html = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    lua = { "stylua" },
    markdown = { "prettier" },
    python = { "isort", "black" },
    sh = { "shfmt" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    xhtml = { "prettier" },
    xml = { "prettier" },
    rust = { "rustfmt" },
}

return formatters_by_ft
