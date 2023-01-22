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

return M
