require("conform").setup({
    formatters_by_ft = {
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
