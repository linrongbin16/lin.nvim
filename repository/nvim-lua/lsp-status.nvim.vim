lua<<EOF
    local lsp_status = require('lsp-status')

    lsp_status.config {
        current_function = true,
    }

    lsp_status.register_progress()
EOF
