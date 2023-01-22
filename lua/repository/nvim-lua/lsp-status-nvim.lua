local lsp_status = require('lsp-status')

lsp_status.config {
    status_symbol = ' [LSP]',
    current_function = false,
    diagnostics = false,
}

lsp_status.register_progress()
