local lsp_status = require('lsp-status')

lsp_status.config {
    status_symbol = 'ﬦ',
    current_function = false,
    diagnostics = false,
    indicator_errors = vim.g.lin_constants.lsp.diagnostic_signs['error'],
    indicator_warnings = vim.g.lin_constants.lsp.diagnostic_signs['warning'],
    indicator_info = vim.g.lin_constants.lsp.diagnostic_signs['info'],
    indicator_hint = vim.g.lin_constants.lsp.diagnostic_signs['hint'],
    indicator_ok = '',
}

lsp_status.register_progress()
