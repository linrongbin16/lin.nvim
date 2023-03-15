-- ---- Lsp UI ----

local const = require("cfg.const")

-- diagnostic signs
local function make_diagnostic_sign(opts)
    vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = "",
    })
end

make_diagnostic_sign({
    name = "DiagnosticSignError",
    text = const.lsp.diagnostics.signs["error"],
})
make_diagnostic_sign({
    name = "DiagnosticSignWarn",
    text = const.lsp.diagnostics.signs["warning"],
})
make_diagnostic_sign({
    name = "DiagnosticSignInfo",
    text = const.lsp.diagnostics.signs["info"],
})
make_diagnostic_sign({
    name = "DiagnosticSignHint",
    text = const.lsp.diagnostics.signs["hint"],
})

vim.diagnostic.config({
    virtual_text = false,
    severity_sort = true,
    float = {
        border = const.ui.border,
        source = "always",
        header = "",
        prefix = "",
    },
})

-- hover/signatureHelp
vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = const.ui.border })
vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, { border = const.ui.border })