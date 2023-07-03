-- Configure extra lspconfig setup handlers.
-- Only if you cannot find the lsp server or source from mason, such as: `flow`.

local setup = require("cfg.lsp.setup")

local setup_handlers = {
    ["flow"] = { on_attach = setup.on_attach },
}

return setup_handlers