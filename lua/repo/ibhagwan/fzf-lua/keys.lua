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
        { desc = "Search files(FzfLua)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uf",
        keymap.exec(function()
            require("fzf-lua").files({
                cmd = fzf_const.FILES_CMD .. " -u", -- --unrestricted
            })
        end),
        { desc = "Unrestricted search files(FzfLua)" }
    ),
    -- live grep
    keymap.map_lazy(
        "n",
        "<space>l",
        keymap.exec(function()
            require("fzf-lua").live_grep()
        end),
        { desc = "Live grep(FzfLua)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>ul",
        keymap.exec(function()
            require("fzf-lua").live_grep({
                cmd = fzf_const.GREP_CMD .. " -uu", -- --unrestricted --hidden
            })
        end),
        { desc = "Unrestricted live grep(FzfLua)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>gl",
        keymap.exec(function()
            require("fzf-lua").live_grep({
                cmd = fzf_const.GREP_CMD,
                rg_glob = true,
            })
        end),
        { desc = "Glob live grep(FzfLua)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>ugl",
        keymap.exec(function()
            require("fzf-lua").live_grep({
                cmd = fzf_const.GREP_CMD .. " -uu",
                rg_glob = true,
            })
        end),
        { desc = "Unrestricted glob live grep(FzfLua)" }
    ),
    -- search word
    keymap.map_lazy(
        "n",
        "<space>w",
        keymap.exec(function()
            require("fzf-lua").grep_cword()
        end),
        { desc = "Search word under cursor(FzfLua)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uw",
        keymap.exec(function()
            require("fzf-lua").grep_cword({
                cmd = fzf_const.GREP_CMD .. " -uu",
            })
        end),
        { desc = "Unrestricted search word under cursor(FzfLua)" }
    ),
    -- search WORD
    keymap.map_lazy(
        "n",
        "<space>W",
        keymap.exec(function()
            require("fzf-lua").grep_cWORD()
        end),
        { desc = "Search WORD under cursor(FzfLua)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uW",
        keymap.exec(function()
            require("fzf-lua").grep_cWORD({
                cmd = fzf_const.GREP_CMD .. " -uu",
            })
        end),
        { desc = "Unrestricted search WORD under cursor(FzfLua)" }
    ),
}

return M