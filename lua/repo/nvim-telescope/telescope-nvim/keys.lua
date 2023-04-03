local keymap = require("cfg.keymap")

local M = {
    -- search files
    keymap.map_lazy(
        "n",
        "<space>f",
        keymap.exec(function()
            require("telescope.builtin").find_files({
                follow = true,
                hidden = false,
                no_ignore = false,
            })
        end),
        { desc = "Search files" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uf",
        keymap.exec(function()
            require("telescope.builtin").find_files({
                follow = true,
                hidden = true,
                no_ignore = true,
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
                additional_args = { "-uu" }, -- --unrestricted --hidden
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
                additional_args = { "-uu" }, -- --unrestricted --hidden
            })
        end),
        { desc = "Unrestricted search word under cursor" }
    ),
}

return M