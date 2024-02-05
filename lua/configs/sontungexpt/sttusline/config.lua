local Components = {
    "mode",
    "os-uname",
    "filename",
    "git-branch",
    "git-diff",
    "%=",
    "diagnostics",
    "lsps-formatters",
    "copilot",
    "copilot-loading",
    "indent",
    "encoding",
    "pos-cursor",
    "pos-cursor-progress",
}

require("sttusline").setup({
    on_attach = function(create_update_group) end,
    statusline_color = "StatusLine",
    disabled = {
        filetypes = {
            -- "NvimTree",
            -- "lazy",
        },
        buftypes = {
            "terminal",
        },
    },
    components = Components,
})
