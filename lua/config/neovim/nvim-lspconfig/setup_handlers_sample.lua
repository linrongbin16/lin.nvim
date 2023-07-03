-- Configure extra lspconfig setup handlers.
-- Only if you cannot find the lsp server or source from mason, such as: `flow`.

-- Please copy this file to 'setup_handlers.lua' to enable it.

local lsp_setup_helper = require("builtin.utils.lsp_setup_helper")

local setup_handlers = {
    ["flow"] = { on_attach = lsp_setup_helper.on_attach },
}

return setup_handlers