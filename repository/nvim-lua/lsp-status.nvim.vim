lua<<EOF
    local lsp_status = require('lsp-status')
    local lspconfig = require('lspconfig')

    lsp_status.config {
        status_symbol = 'ﬦ',
        current_function = true,
        diagnostics = false,
    }

    lsp_status.register_progress()
EOF
