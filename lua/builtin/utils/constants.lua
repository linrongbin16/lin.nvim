-- ---- Constants ----

local OS = vim.loop.os_uname().sysname

local M = {
    diagnostic = {
        sign = {
            error = "", -- nf-fa-times \uf00d
            warning = "", -- nf-fa-warning \uf071
            info = "", -- nf-fa-info_circle \uf05a
            hint = "", -- nf-fa-bell \uf0f3
            ok = "", -- nf-fa-check \uf00c
        },
    },
    ui = {
        border = "rounded", -- single,double,rounded,solid,shadow
        winblend = 15,
        pumblend = 15,
        layout = {
            -- width = 0.8,
            -- height = 0.8,
            scale = 0.8,
        },
    },
    perf = {
        file = {
            maxsize = 1024 * 1024 * 5, -- 5MB
        },
    },
}

M = vim.tbl_deep_extend("force", M, vim.g.lin_nvim_options or {})

M.os = {
    name = OS,
    is_macos = vim.fn.has("mac") > 0,
    is_windows = vim.fn.has("win32") > 0 or vim.fn.has("win64") > 0,
}

return M