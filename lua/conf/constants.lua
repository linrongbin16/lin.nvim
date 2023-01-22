-- ---- Constants ----

local M = {}

M.lsp = {
    diagnostics = {
        signs = {
            ['error'] = '', -- nf-fa-times_circle \uf057
            ['warning'] = '', -- nf-fa-warning \uf071
            ['info'] = '', -- nf-fa-info_circle \uf05a
            ['hint'] = '', -- nf-fa-bell \uf0f3
            ['ok'] = '', -- nf-fa-check \uf00c
        }
    },
}

M.ui = {
    border = 'rounded', -- border options: single,double,rounded,solid,shadow
}

return M
