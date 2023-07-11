-- ---- Constants ----

local OS = vim.loop.os_uname().sysname

local M = {
    os = {
        name = OS,
        is_macos = vim.fn.has("mac") > 0,
        is_windows = vim.fn.has("win32") > 0 or vim.fn.has("win64") > 0,
    },
    lsp = {
        diagnostics = {
            signs = {
                error = "", -- nf-fa-times \uf00d
                warning = "", -- nf-fa-warning \uf071
                info = "", -- nf-fa-info_circle \uf05a
                hint = "", -- : nf-fa-flag \uf024,  nf-fa-bell \uf0f3
                ok = "", -- nf-fa-check \uf00c
            },
        },
    },
    ui = {
        -- options: single,double,rounded,solid,shadow
        border = "rounded",
        winblend = 15,
        pumblend = 15,
        layout = {
            width = 0.95,
            height = 0.85,
            fixed_width = 165,
            fixed_height = 35,
            fixed_gap = 7,
        },
    },
    -- performance
    perf = {
        file = {
            maxsize = 1024 * 1024 * 5, -- 5MB
        },
    },
}

return M