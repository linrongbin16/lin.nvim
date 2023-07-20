require("nvim-navic").setup({
    lsp = {
        auto_attach = true,
        preference = {
            "flow",
            "tsserver",
            "eslint",
            "prettier",
            "html",
            "css-lsp",
            "cssmodules_ls",
            "jsonls",
            "clangd",
            "bashls",
            "pyright",
            "lua_ls",
            "vim_ls",
            "teal_ls",
        },
    },
    lazy_update_context = true,
})