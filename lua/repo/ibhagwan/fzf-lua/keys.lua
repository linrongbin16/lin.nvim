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
        { desc = "Search files" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uf",
        keymap.exec(function()
            require("fzf-lua").files({
                files = {
                    previewer = "bat",
                    cmd = fzf_const.FILES_CMD .. " -u",
                },
            })
        end),
        { desc = "Unrestricted search files" }
    ),
    -- grep
    keymap.map_lazy(
        "n",
        "<space>g",
        keymap.exec(function()
            require("fzf-lua").grep()
        end),
        { desc = "Grep" }
    ),
    keymap.map_lazy(
        "n",
        "<space>ug",
        keymap.exec(function()
            require("fzf-lua").grep({
                grep = {
                    cmd = fzf_const.GREP_CMD .. " -uu",
                },
            })
        end),
        { desc = "Unrestricted grep" }
    ),
    keymap.map_lazy(
        "n",
        "<space>pg",
        keymap.exec(function()
            require("fzf-lua").grep({
                grep = {
                    cmd = fzf_const.GREP_CMD,
                    rg_glob = true,
                    glob_flag = "--glob",
                },
            })
        end),
        { desc = "Glob patterned grep" }
    ),
    keymap.map_lazy(
        "n",
        "<space>upg",
        keymap.exec(function()
            require("fzf-lua").grep({
                grep = {
                    cmd = fzf_const.GREP_CMD .. " -uu",
                    rg_glob = true,
                    glob_flag = "--glob",
                },
            })
        end),
        { desc = "Unrestricted glob patterned grep" }
    ),
    -- live grep
    keymap.map_lazy(
        "n",
        "<space>l",
        keymap.exec(function()
            require("fzf-lua").live_grep()
        end),
        { desc = "Live grep" }
    ),
    keymap.map_lazy(
        "n",
        "<space>ul",
        keymap.exec(function()
            require("fzf-lua").live_grep({
                grep = {
                    cmd = fzf_const.GREP_CMD .. " -uu",
                },
            })
        end),
        { desc = "Unrestricted live grep" }
    ),
    keymap.map_lazy(
        "n",
        "<space>pl",
        keymap.exec(function()
            require("fzf-lua").live_grep({
                grep = {
                    cmd = fzf_const.GREP_CMD,
                    rg_glob = true,
                    glob_flag = "--glob",
                },
            })
        end),
        { desc = "Glob patterned grep" }
    ),
    keymap.map_lazy(
        "n",
        "<space>upl",
        keymap.exec(function()
            require("fzf-lua").live_grep({
                grep = {
                    cmd = fzf_const.GREP_CMD .. " -uu",
                    rg_glob = true,
                    glob_flag = "--glob",
                },
            })
        end),
        { desc = "Unrestricted glob patterned live grep" }
    ),
}

return M