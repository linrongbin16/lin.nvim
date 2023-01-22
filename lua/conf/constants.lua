-- ---- Constants ----

local M = {}

M.lsp = {
    diagnostics = {
        signs = {
            ['error'] = '✘',
            ['warning'] = '',
            ['info'] = '',
            ['hint'] = '⚑',
            ['ok'] = '',
        }
    },
}

M.ui = {
    border = 'rounded', -- border options: single,double,rounded,solid,shadow
}

vim.g.lin_constants = {
    lsp = {
        diagnostic_signs = {
            ['error'] = '✘',
            ['warning'] = '',
            ['info'] = '',
            ['hint'] = '⚑',
            ['ok'] = '',
        },
    },
    ui = {
        border = 'rounded', -- border options: single,double,rounded,solid,shadow
    }
}

return M
