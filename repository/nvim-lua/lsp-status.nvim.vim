lua<<EOF
    local lsp_status = require('lsp-status')
    local lspconfig = require('lspconfig')

    lsp_status.config {
        -- current_function = true,
        -- indicator_separator = " │ ",
        -- component_separator = " │ ",
        status_symbol = 'ﬦ',
    }

    lsp_status.register_progress()
EOF
