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
    -- grep
    keymap.map_lazy(
        "n",
        "<space>g",
        keymap.exec(function()
            require("fzf-lua").grep()
        end),
        { desc = "Grep(g)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>ug",
        keymap.exec(function()
            require("fzf-lua").grep({
                cmd = fzf_const.GREP_CMD .. " -uu",
            })
        end),
        { desc = "Unrestricted(u) grep(g)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>og",
        keymap.exec(function()
            require("fzf-lua").grep({
                cmd = fzf_const.GREP_CMD,
                rg_glob = true,
                glob_flag = "--glob",
            })
        end),
        { desc = "Glob(o) grep(g)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uog",
        keymap.exec(function()
            require("fzf-lua").grep({
                cmd = fzf_const.GREP_CMD .. " -uu",
                rg_glob = true,
                glob_flag = "--glob",
            })
        end),
        { desc = "Unrestricted(u) glob(o) grep(g)" }
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
        "<space>ol",
        keymap.exec(function()
            require("fzf-lua").live_grep({
                cmd = fzf_const.GREP_CMD,
                rg_glob = true,
                glob_flag = "--glob",
            })
        end),
        { desc = "Glob(o) grep(g)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uol",
        keymap.exec(function()
            require("fzf-lua").live_grep({
                cmd = fzf_const.GREP_CMD .. " -uu",
                rg_glob = true,
                glob_flag = "--glob",
            })
        end),
        { desc = "Unrestricted(u) glob(o) live(l) grep" }
    ),
    -- FzfLua
    keymap.map_lazy("n", "<Leader>fz", ":FzfLua ", { desc = "Open FzfLua" }),
}

return M