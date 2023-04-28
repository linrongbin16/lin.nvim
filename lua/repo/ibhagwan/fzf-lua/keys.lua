local keymap = require("cfg.keymap")
local fzf_const = require("repo.ibhagwan.fzf-lua.const")

local M = {
    -- search files
    keymap.map_lazy(
        "n",
        "<space>f",
        keymap.exec(function()
            require("fzf-lua").files()
        end),
        { desc = "Search files (FzfLua)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uf",
        keymap.exec(function()
            require("fzf-lua").files({
                cmd = fzf_const.FILES_CMD .. " -u", -- --unrestricted
            })
        end),
        { desc = "Unrestricted search files (FzfLua)" }
    ),
    -- search buffer
    keymap.map_lazy(
        "n",
        "<space>b",
        keymap.exec(function()
            require("fzf-lua").buffers()
        end),
        { desc = "Search buffers (FzfLua)" }
    ),
    -- live grep
    keymap.map_lazy(
        "n",
        "<space>l",
        keymap.exec(function()
            require("fzf-lua").live_grep({
                cmd = fzf_const.GREP_CMD,
                rg_glob = true,
            })
        end),
        { desc = "Live grep with glob support via '--' (FzfLua)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>ul",
        keymap.exec(function()
            require("fzf-lua").live_grep({
                cmd = fzf_const.GREP_CMD .. " -uu", -- --unrestricted --hidden
                rg_glob = true,
            })
        end),
        { desc = "Unrestricted live grep with glob support via '--' (FzfLua)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>nl",
        keymap.exec(function()
            require("fzf-lua").live_grep()
        end),
        { desc = "Live grep without glob support (FzfLua)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>unl",
        keymap.exec(function()
            require("fzf-lua").live_grep({
                cmd = fzf_const.GREP_CMD .. " -uu", -- --unrestricted --hidden
            })
        end),
        { desc = "Unrestricted live grep without glob support (FzfLua)" }
    ),
    -- search word
    keymap.map_lazy(
        "n",
        "<space>w",
        keymap.exec(function()
            require("fzf-lua").grep_cword()
        end),
        { desc = "Search word under cursor (FzfLua)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uw",
        keymap.exec(function()
            require("fzf-lua").grep_cword({
                cmd = fzf_const.GREP_CMD .. " -uu",
            })
        end),
        { desc = "Unrestricted search word under cursor (FzfLua)" }
    ),
    -- search WORD
    keymap.map_lazy(
        "n",
        "<space>W",
        keymap.exec(function()
            require("fzf-lua").grep_cWORD()
        end),
        { desc = "Search WORD under cursor (FzfLua)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uW",
        keymap.exec(function()
            require("fzf-lua").grep_cWORD({
                cmd = fzf_const.GREP_CMD .. " -uu",
            })
        end),
        { desc = "Unrestricted search WORD under cursor (FzfLua)" }
    ),
    -- search git
    keymap.map_lazy(
        "n",
        "<space>gc",
        keymap.exec(function()
            require("fzf-lua").git_commits()
        end),
        { desc = "Search git commits (FzfLua)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>gf",
        keymap.exec(function()
            require("fzf-lua").git_files()
        end),
        { desc = "Search git files (FzfLua)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>gs",
        keymap.exec(function()
            require("fzf-lua").git_status()
        end),
        { desc = "Search git status (FzfLua)" }
    ),
}

return M