-- ---- Constants ----

--- @type string
local OS = vim.loop.os_uname().sysname

--- @type LuaModule
local M = {
    --- @type table<string, any>
    diagnostic = {
        --- @type table<string, any>
        sign = {
            --- @type string
            error = "", -- nf-fa-times \uf00d
            --- @type string
            warning = "", -- nf-fa-warning \uf071
            --- @type string
            info = "", -- nf-fa-info_circle \uf05a
            --- @type string
            hint = "", -- nf-fa-bell \uf0f3
            --- @type string
            ok = "", -- nf-fa-check \uf00c
        },
    },
    --- @type table<string, any>
    ui = {
        --- @type string
        border = "rounded", -- single,double,rounded,solid,shadow
        --- @type integer
        winblend = 15,
        --- @type integer
        pumblend = 15,
        --- @type table<string, any>
        layout = {
            --- @type table<string, number>
            middle = {
                --- @type number
                scale = 0.8,
            },
            --- @type table<string, number>
            large = {
                --- @type number
                scale = 0.9,
            },
        },
    },
    --- @type table<string, any>
    perf = {
        --- @type table<string, any>
        file = {
            --- @type integer
            maxsize = 1024 * 1024 * 5, -- 5MB
        },
    },
    --- @type table<string, any>
    plugin = {
        lazy = {
            root = vim.fn.stdpath("config") .. "/lazy",
            install = {
                missing = true,
            },
        },
    },
}

M = vim.tbl_deep_extend("force", M, vim.g.lin_nvim_options or {})

M.os = {
    --- @type string
    name = OS,
    --- @type boolean
    is_macos = vim.fn.has("mac") > 0,
    --- @type boolean
    is_windows = vim.fn.has("win32") > 0 or vim.fn.has("win64") > 0,
}

return M