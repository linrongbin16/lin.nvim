-- Please copy this file to 'formatters_by_ft.lua' to enable it.

-- Configure formatters by filetypes.
-- This module will be passed to `require("conform").setup({ formatters_by_ft = ... })`.

local formatters_by_ft = {
    bash = { "shfmt" },
    c = { "clang_format" },
    css = { { "prettierd", "prettier" } },
    cpp = { "clang_format" },
    cmake = { "cmake_format" },
    html = { { "prettierd", "prettier" } },
    javascript = { { "eslint_d", "eslint", "prettierd", "prettier" } },
    lua = { "stylua" },
    markdown = { { "prettierd", "prettier" } },
    python = { "isort", "black" },
    sh = { "shfmt" },
    typescript = { { "eslint_d", "eslint", "prettierd", "prettier" } },
    xhtml = { { "prettierd", "prettier" } },
    xml = { { "prettierd", "prettier" } },
}

return formatters_by_ft
