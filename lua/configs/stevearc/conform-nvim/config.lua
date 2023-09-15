require("conform").setup({
    formatters_by_ft = {
        bash = { "shfmt" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        cmake = { "cmake_format" },
        javascript = { { "eslint_d", "eslint", "prettierd", "prettier" } },
        lua = { "stylua" },
        python = { "isort", "black" },
        sh = { "shfmt" },
        typescript = { { "eslint_d", "eslint", "prettierd", "prettier" } },
    },
    format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
        async = true,
    },
    format_after_save = {
        lsp_fallback = true,
        async = true,
    },
})