local const = require("cfg.const")
local fzf_actions = require("fzf-lua.actions")
local fzf_const = require("repo.ibhagwan.fzf-lua.const")
local fzf_previewer = vim.fn.executable("bat") > 0 and "bat" or "builtin"

require("fzf-lua").setup({
    winopts = {
        height = 0.85,
        width = 0.9,
        border = const.ui.border,
        preview = {
            default = fzf_previewer,
            horizontal = "right:50%",
        },
    },
    keymap = {
        builtin = {
            ["<C-l>"] = "toggle-preview",
            ["<C-d>"] = "preview-page-down",
            ["<C-u>"] = "preview-page-up",

            ["<F1>"] = false, -- "toggle-help",
            ["<F2>"] = false, --  "toggle-fullscreen",
            ["<F3>"] = false, -- "toggle-preview-wrap",
            ["<F4>"] = false, -- "toggle-preview",
            ["<F5>"] = false, -- "toggle-preview-ccw",
            ["<F6>"] = false, -- "toggle-preview-cw",
            ["<S-down>"] = false, -- "preview-page-down",
            ["<S-up>"] = false, -- "preview-page-up",
            ["<S-left>"] = false, -- "preview-page-reset",
        },
        fzf = {
            -- fzf '--bind=' options
            ["ctrl-d"] = "half-page-down",
            ["ctrl-u"] = "half-page-up", -- "unix-line-discard",
            ["ctrl-l"] = "toggle-preview",

            ["ctrl-z"] = false, -- "abort",
            ["ctrl-f"] = false, -- "half-page-down",
            ["ctrl-b"] = false, -- "half-page-up",
            ["ctrl-a"] = false, -- "beginning-of-line",
            ["ctrl-e"] = false, -- "end-of-line",
            ["alt-a"] = false, -- "toggle-all",
            ["f3"] = false, -- "toggle-preview-wrap",
            ["f4"] = false, -- "toggle-preview",
            ["shift-down"] = false, -- "preview-page-down",
            ["shift-up"] = false, -- "preview-page-up",
        },
    },
    actions = {
        files = {
            ["default"] = fzf_actions.file_edit, -- fzf_actions.file_edit_or_qf,
            ["ctrl-s"] = false, -- fzf_actions.file_split,
            ["ctrl-v"] = false, -- fzf_actions.file_vsplit,
            ["ctrl-t"] = false, -- fzf_actions.file_tabedit,

            ["alt-q"] = false, -- fzf_actions.file_sel_to_qf,
            ["alt-l"] = false, -- fzf_actions.file_sel_to_ll,
        },
        buffers = {
            ["default"] = fzf_actions.buf_edit,
            ["ctrl-s"] = false, -- fzf_actions.buf_split,
            ["ctrl-v"] = false, -- fzf_actions.buf_vsplit,
            ["ctrl-t"] = false, -- fzf_actions.buf_tabedit,
        },
    },
    previewers = {
        bat = {
            cmd = fzf_const.BAT,
            args = "--style=numbers,changes,header --color always",
            theme = "ansi",
        },
    },
    files = {
        previewer = fzf_previewer,
        cmd = fzf_const.FILES_CMD,
    },
    grep = {
        cmd = fzf_const.GREP_CMD,
    },
    global_git_icons = false,
    global_file_icons = false,
})