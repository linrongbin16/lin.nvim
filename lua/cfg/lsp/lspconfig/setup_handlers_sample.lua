-- Configure extra lspconfig setup handlers.
-- Only if you cannot find the lsp server or source from mason, such as: `flow`.

local global_setup = require("cfg.lsp.global_setup")

local setup_handlers = {
    ["flow"] = { on_attach = global_setup.on_attach },
}

return setup_handlers