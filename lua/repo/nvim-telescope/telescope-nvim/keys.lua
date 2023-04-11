local keymap = require("cfg.keymap")
local FIND = vim.fn.executable("fdfind") > 0 and "fdfind" or "fd"

local M = {
    -- search files
    keymap.map_lazy(
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
    keymap.map_lazy(
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
    -- live grep
    keymap.map_lazy(
        "n",
        "<space>l",
        keymap.exec(function()
            require("telescope").extensions.live_grep_args.live_grep_args()
        end),
        { desc = "Live grep" }
    ),
    keymap.map_lazy(
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
    keymap.map_lazy(
        "n",
        "<space>w",
        keymap.exec(function()
            require("telescope.builtin").grep_string()
        end),
        { desc = "Search word under cursor" }
    ),
    keymap.map_lazy(
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
    keymap.map_lazy(
        "n",
        "<space>gf",
        keymap.exec(function()
            require("telescope.builtin").git_files()
        end),
        { desc = "Search git files" }
    ),
    keymap.map_lazy(
        "n",
        "<space>gc",
        keymap.exec(function()
            require("telescope.builtin").git_commits()
        end),
        { desc = "Search git commits" }
    ),
    keymap.map_lazy(
        "n",
        "<space>gb",
        keymap.exec(function()
            require("telescope.builtin").git_branches()
        end),
        { desc = "Search git branches" }
    ),
    keymap.map_lazy(
        "n",
        "<space>gs",
        keymap.exec(function()
            require("telescope.builtin").git_status()
        end),
        { desc = "Search git status" }
    ),
    -- search diagnostics
    keymap.map_lazy(
        "n",
        "<space>dw",
        keymap.exec(function()
            require("telescope.builtin").diagnostics()
        end),
        { desc = "Search workspace diagnostics" }
    ),
    keymap.map_lazy(
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
    keymap.map_lazy(
        "n",
        "<space>bf",
        keymap.exec(function()
            require("telescope.builtin").buffers()
        end),
        { desc = "Search buffers" }
    ),
    keymap.map_lazy(
        "n",
        "<space>cm",
        keymap.exec(function()
            require("telescope.builtin").commands()
        end),
        { desc = "Search vim commands" }
    ),
    keymap.map_lazy(
        "n",
        "<space>tg",
        keymap.exec(function()
            require("telescope.builtin").tags()
        end),
        { desc = "Search vim tags" }
    ),
    keymap.map_lazy(
        "n",
        "<space>ch",
        keymap.exec(function()
            require("telescope.builtin").command_history()
        end),
        { desc = "Search vim command history" }
    ),
    keymap.map_lazy(
        "n",
        "<space>sh",
        keymap.exec(function()
            require("telescope.builtin").search_history()
        end),
        { desc = "Search vim search history" }
    ),
    keymap.map_lazy(
        "n",
        "<space>mk",
        keymap.exec(function()
            require("telescope.builtin").marks()
        end),
        { desc = "Search vim marks" }
    ),
    keymap.map_lazy(
        "n",
        "<space>km",
        keymap.exec(function()
            require("telescope.builtin").keymaps()
        end),
        { desc = "Search vim key mappings" }
    ),
}

return M