local lsp_setup_helper = require("builtin.utils.lsp_setup_helper")

require("null-ls").setup({ on_attach = lsp_setup_helper.on_attach })