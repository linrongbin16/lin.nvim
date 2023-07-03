local keymap = require("builtin.utils.keymap")
local FIND = vim.fn.executable("fdfind") > 0 and "fdfind" or "fd"

local M = {
    -- search files
    keymap.set_lazy_key(
        "n",
        "<space>f",
        keymap.exec(function()
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
        end),
        { desc = "Search files" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>uf",
        keymap.exec(function()
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
        end),
        { desc = "Unrestricted search files" }
    ),
    -- search buffers
    keymap.set_lazy_key(
        "n",
        "<space>b",
        keymap.exec(function()
            require("telescope.builtin").buffers()
        end),
        { desc = "Search buffers" }
    ),
    -- live grep
    keymap.set_lazy_key(
        "n",
        "<space>l",
        keymap.exec(function()
            require("telescope").extensions.live_grep_args.live_grep_args()
        end),
        { desc = "Live grep" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>ul",
        keymap.exec(function()
            require("telescope").extensions.live_grep_args.live_grep_args({
                additional_args = { "-uu" }, -- --unrestricted (--hidden --no-ignore)
            })
        end),
        { desc = "Unrestricted live grep" }
    ),
    -- search word
    keymap.set_lazy_key(
        "n",
        "<space>w",
        keymap.exec(function()
            require("telescope.builtin").grep_string()
        end),
        { desc = "Search word under cursor" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>uw",
        keymap.exec(function()
            require("telescope.builtin").grep_string({
                additional_args = { "-uu" }, -- --unrestricted (--hidden --no-ignore)
            })
        end),
        { desc = "Unrestricted search word under cursor" }
    ),
    -- search git
    keymap.set_lazy_key(
        "n",
        "<space>gf",
        keymap.exec(function()
            require("telescope.builtin").git_files()
        end),
        { desc = "Search git files" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>gc",
        keymap.exec(function()
            require("telescope.builtin").git_commits()
        end),
        { desc = "Search git commits" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>gb",
        keymap.exec(function()
            require("telescope.builtin").git_branches()
        end),
        { desc = "Search git branches" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>gs",
        keymap.exec(function()
            require("telescope.builtin").git_status()
        end),
        { desc = "Search git status" }
    ),
    -- search diagnostics
    keymap.set_lazy_key(
        "n",
        "<space>dw",
        keymap.exec(function()
            require("telescope.builtin").diagnostics()
        end),
        { desc = "Search workspace diagnostics" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>dd",
        keymap.exec(function()
            require("telescope.builtin").diagnostics({
                bufnr = 0,
            })
        end),
        { desc = "Search document diagnostics" }
    ),
    -- search vim
    keymap.set_lazy_key(
        "n",
        "<space>cm",
        keymap.exec(function()
            require("telescope.builtin").commands()
        end),
        { desc = "Search vim commands" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>tg",
        keymap.exec(function()
            require("telescope.builtin").tags()
        end),
        { desc = "Search vim tags" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>ch",
        keymap.exec(function()
            require("telescope.builtin").command_history()
        end),
        { desc = "Search vim command history" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>sh",
        keymap.exec(function()
            require("telescope.builtin").search_history()
        end),
        { desc = "Search vim search history" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>mk",
        keymap.exec(function()
            require("telescope.builtin").marks()
        end),
        { desc = "Search vim marks" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>km",
        keymap.exec(function()
            require("telescope.builtin").keymaps()
        end),
        { desc = "Search vim key mappings" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>ud",
        keymap.exec(function()
            require("telescope").extensions.undo.undo()
        end),
        { desc = "Search vim undo tree" }
    ),
}

return M