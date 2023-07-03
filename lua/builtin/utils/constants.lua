-- ---- Const ----

local OS = vim.loop.os_uname().sysname
local editor_layout = require("builtin.utils.layout").editor

local M = {
    os = {
        name = OS,
        is_macos = OS == "Darwin",
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
        -- border options: single,double,rounded,solid,shadow
        border = "rounded",
        layout = {
            width = editor_layout.width(0.9, 10, nil),
            height = editor_layout.height(0.8, 5, nil),
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