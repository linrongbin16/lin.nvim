local global_setup = require("cfg.lsp.global_setup")

require("null-ls").setup({ on_attach = global_setup.on_attach })