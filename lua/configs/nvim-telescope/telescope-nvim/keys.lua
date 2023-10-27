local set_lazy_key = require("builtin.utils.keymap").set_lazy_key
local FIND = vim.fn.executable("fdfind") > 0 and "fdfind" or "fd"

local M = {
    -- search files
    set_lazy_key("n", "<space>f", function()
        require("telescope.builtin").find_files({
            find_command = {
                FIND,
                "-cnever", -- --color=never
                "-tf", -- --type file
                "-tl", -- --type symlink
                "-L", -- --follow
                "-i", -- --ignore-case
            },
        })
    end, { desc = "Search files" }),
    set_lazy_key("n", "<space>uf", function()
        require("telescope.builtin").find_files({
            find_command = {
                FIND,
                "-cnever", -- --color=never
                "-tf", -- --type file
                "-tl", -- --type symlink
                "-L", -- --follow
                "-i", -- --ignore-case
                "-u", -- --unrestricted (--hidden --no-ignore)
            },
        })
    end, { desc = "Unrestricted search files" }),
    -- search buffers
    set_lazy_key("n", "<space>b", function()
        require("telescope.builtin").buffers()
    end, { desc = "Search buffers" }),
    -- live grep
    set_lazy_key("n", "<space>l", function()
        require("telescope").extensions.live_grep_args.live_grep_args()
    end, { desc = "Live grep" }),
    set_lazy_key("n", "<space>ul", function()
        require("telescope").extensions.live_grep_args.live_grep_args({
            additional_args = { "-uu" }, -- --unrestricted (--hidden --no-ignore)
        })
    end, { desc = "Unrestricted live grep" }),
    -- search word
    set_lazy_key("n", "<space>w", function()
        require("telescope.builtin").grep_string()
    end, { desc = "Search word under cursor" }),
    set_lazy_key("n", "<space>uw", function()
        require("telescope.builtin").grep_string({
            additional_args = { "-uu" }, -- --unrestricted (--hidden --no-ignore)
        })
    end, { desc = "Unrestricted search word under cursor" }),
    -- search git
    set_lazy_key("n", "<space>gf", function()
        require("telescope.builtin").git_files()
    end, { desc = "Search git files" }),
    set_lazy_key("n", "<space>gc", function()
        require("telescope.builtin").git_commits()
    end, { desc = "Search git commits" }),
    set_lazy_key("n", "<space>gb", function()
        require("telescope.builtin").git_branches()
    end, { desc = "Search git branches" }),
    set_lazy_key("n", "<space>gs", function()
        require("telescope.builtin").git_status()
    end, { desc = "Search git status" }),
    -- search diagnostics
    set_lazy_key("n", "<space>dw", function()
        require("telescope.builtin").diagnostics()
    end, { desc = "Search workspace diagnostics" }),
    set_lazy_key("n", "<space>dd", function()
        require("telescope.builtin").diagnostics({
            bufnr = 0,
        })
    end, { desc = "Search document diagnostics" }),
    -- search vim
    set_lazy_key("n", "<space>cm", function()
        require("telescope.builtin").commands()
    end, { desc = "Search vim commands" }),
    set_lazy_key("n", "<space>tg", function()
        require("telescope.builtin").tags()
    end, { desc = "Search vim tags" }),
    set_lazy_key("n", "<space>ch", function()
        require("telescope.builtin").command_history()
    end, { desc = "Search vim command history" }),
    set_lazy_key("n", "<space>sh", function()
        require("telescope.builtin").search_history()
    end, { desc = "Search vim search history" }),
    set_lazy_key("n", "<space>mk", function()
        require("telescope.builtin").marks()
    end, { desc = "Search vim marks" }),
    set_lazy_key("n", "<space>km", function()
        require("telescope.builtin").keymaps()
    end, { desc = "Search vim key mappings" }),
    set_lazy_key("n", "<space>ud", function()
        require("telescope").extensions.undo.undo()
    end, { desc = "Search vim undo tree" }),
}

return M
