lua<<EOF
    local lsp_status = require('lsp-status')
    local lspconfig = require('lspconfig')

    lsp_status.config {
        -- current_function = true,
        indicator_separator = " ",
        component_separator = " ",
        status_symbol = 'ﬦ',
        -- indicator_errors = '',
        indicator_errors = '',
        indicator_warnings = '',
        indicator_info = '🛈',
        indicator_hint = '❗',
        indicator_ok = '',
        diagnostics = false,
    }

    lsp_status.register_progress()
EOF
