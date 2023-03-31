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
        { desc = "Search files(f)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uf",
        keymap.exec(function()
            require("fzf-lua").files({
                cmd = fzf_const.FILES_CMD .. " -u",
            })
        end),
        { desc = "Unrestricted(u) search files(f)" }
    ),
    -- live grep
    keymap.map_lazy(
        "n",
        "<space>l",
        keymap.exec(function()
            require("fzf-lua").live_grep()
        end),
        { desc = "Live(l) grep" }
    ),
    keymap.map_lazy(
        "n",
        "<space>ul",
        keymap.exec(function()
            require("fzf-lua").live_grep({
                cmd = fzf_const.GREP_CMD .. " -uu",
            })
        end),
        { desc = "Unrestricted live grep" }
    ),
    keymap.map_lazy(
        "n",
        "<space>gl",
        keymap.exec(function()
            require("fzf-lua").live_grep({
                cmd = fzf_const.GREP_CMD,
                rg_glob = true,
                glob_flag = "--glob",
            })
        end),
        { desc = "Glob(g) grep(g)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>ugl",
        keymap.exec(function()
            require("fzf-lua").live_grep({
                cmd = fzf_const.GREP_CMD .. " -uu",
                rg_glob = true,
                glob_flag = "--glob",
            })
        end),
        { desc = "Unrestricted(u) glob(g) live(l) grep" }
    ),
    -- grep word
    keymap.map_lazy(
        "n",
        "<space>w",
        keymap.exec(function()
            require("fzf-lua").grep_cword()
        end),
        { desc = "Grep word(w)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uw",
        keymap.exec(function()
            require("fzf-lua").grep_cword({
                cmd = fzf_const.GREP_CMD .. " -uu",
            })
        end),
        { desc = "Unrestricted(u) grep word(w)" }
    ),
    -- grep WORD
    keymap.map_lazy(
        "n",
        "<space>W",
        keymap.exec(function()
            require("fzf-lua").grep_cWORD()
        end),
        { desc = "Grep WORD(W)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uw",
        keymap.exec(function()
            require("fzf-lua").grep_cWORD({
                cmd = fzf_const.GREP_CMD .. " -uu",
            })
        end),
        { desc = "Unrestricted(u) grep WORD(W)" }
    ),
    -- FzfLua
    keymap.map_lazy("n", "<Leader>fz", ":FzfLua ", { desc = "Open FzfLua" }),
}

return M