-- ---- Const ----

local OS = vim.loop.os_uname().sysname
local editor_width = require("cfg.ui").editor_width
local editor_height = require("cfg.ui").editor_height

local M = {
    os = {
        name = OS,
        is_macos = OS == "Darwin",
        is_windows = OS:match("Windows"),
    },
    lsp = {
        diagnostics = {
            signs = {
                ["error"] = "", -- nf-fa-times \uf00d
                ["warning"] = "", -- nf-fa-warning \uf071
                ["info"] = "", -- nf-fa-info_circle \uf05a
                -- ["hint"] = "", -- nf-mdi-lightbulb \uf834, used for codeAction in vscode, choose another icon
                ["hint"] = "", -- : nf-fa-flag \uf024,  nf-fa-bell \uf0f3
                ["ok"] = "", -- nf-fa-check \uf00c
            },
        },
    },
    ui = {
        border = "single", -- border options: single,double,rounded,solid,shadow
        layout = {
            big = {
                width = editor_width(0.9, 40, nil),
                height = editor_height(0.8, 35, nil),
            },
            middle = {
                width = editor_width(0.7, 30, nil),
                height = editor_height(0.6, 25, nil),
            },
            small = {
                width = editor_width(0.5, 20, nil),
                height = editor_height(0.4, 15, nil),
            },
        },
    },
    perf = {
        -- performance
        file = {
            maxsize = 1024 * 1024 * 5, -- 5MB
        },
    },
}

return M