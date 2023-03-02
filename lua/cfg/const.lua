-- ---- Const ----

local OS = vim.loop.os_uname().sysname

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
        border = "rounded", -- border options: single,double,rounded,solid,shadow
    },
    perf = {
        -- performance
        file = {
            maxsize = 1024 * 1024 * 5, -- 5MB
        },
    },
}

return M
