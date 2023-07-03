local setup = require("cfg.lsp.setup")

require("null-ls").setup({ on_attach = setup.on_attach })