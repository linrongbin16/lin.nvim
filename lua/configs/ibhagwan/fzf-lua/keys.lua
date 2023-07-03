local keymap = require("builtin.utils.keymap")
local fzf_const = require("configs.ibhagwan.fzf-lua.const")

local M = {
    -- search files
    keymap.set_lazy_key(
        "n",
        "<space>f",
        keymap.exec(function()
            require("fzf-lua").files()
        end),
        { desc = "Search files" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>uf",
        keymap.exec(function()
            require("fzf-lua").files({
                cmd = fzf_const.FD_COMMAND .. " -u", -- --unrestricted
            })
        end),
        { desc = "Unrestricted search files" }
    ),
    -- search buffer
    keymap.set_lazy_key(
        "n",
        "<space>b",
        keymap.exec(function()
            require("fzf-lua").buffers()
        end),
        { desc = "Search buffers" }
    ),
    -- live grep
    keymap.set_lazy_key(
        "n",
        "<space>l",
        keymap.exec(function()
            require("fzf-lua").live_grep({
                cmd = fzf_const.RG_COMMAND,
                rg_glob = true,
            })
        end),
        { desc = "Live grep with `--iglob` support" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>ul",
        keymap.exec(function()
            require("fzf-lua").live_grep({
                cmd = fzf_const.RG_COMMAND .. " -uu",
                rg_glob = true,
            })
        end),
        { desc = "Unrestricted live grep with `--iglob` support" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>r",
        keymap.exec(function()
            require("fzf-lua").live_grep()
        end),
        { desc = "Live grep (without `--iglob` support)" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>ur",
        keymap.exec(function()
            require("fzf-lua").live_grep({
                cmd = fzf_const.RG_COMMAND .. " -uu", -- --unrestricted --hidden
            })
        end),
        { desc = "Unrestricted live grep (without `--iglob` support)" }
    ),
    -- search word
    keymap.set_lazy_key(
        "n",
        "<space>w",
        keymap.exec(function()
            require("fzf-lua").grep_cword()
        end),
        { desc = "Search word under cursor" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>uw",
        keymap.exec(function()
            require("fzf-lua").grep_cword({
                cmd = fzf_const.RG_COMMAND .. " -uu",
            })
        end),
        { desc = "Unrestricted search word under cursor" }
    ),
    -- search WORD
    keymap.set_lazy_key(
        "n",
        "<space>W",
        keymap.exec(function()
            require("fzf-lua").grep_cWORD()
        end),
        { desc = "Search WORD under cursor" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>uW",
        keymap.exec(function()
            require("fzf-lua").grep_cWORD({
                cmd = fzf_const.RG_COMMAND .. " -uu",
            })
        end),
        { desc = "Unrestricted search WORD under cursor" }
    ),
    -- search git
    keymap.set_lazy_key(
        "n",
        "<space>gf",
        keymap.exec(function()
            require("fzf-lua").git_files()
        end),
        { desc = "Search git files" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>gb",
        keymap.exec(function()
            require("fzf-lua").git_branches()
        end),
        { desc = "Search git branches" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>gc",
        keymap.exec(function()
            require("fzf-lua").git_commits()
        end),
        { desc = "Search git commits" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>gs",
        keymap.exec(function()
            require("fzf-lua").git_status()
        end),
        { desc = "Search git status" }
    ),
    -- search diagnostics
    keymap.set_lazy_key(
        "n",
        "<space>dd",
        keymap.exec(function()
            require("fzf-lua").lsp_document_diagnostics()
        end),
        { desc = "Search document diagnostics" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>dw",
        keymap.exec(function()
            require("fzf-lua").lsp_workspace_diagnostics()
        end),
        { desc = "Search workspace diagnostics" }
    ),
    -- search vim
    keymap.set_lazy_key(
        "n",
        "<space>cm",
        keymap.exec(function()
            require("fzf-lua").commands()
        end),
        { desc = "Search vim commands" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>tg",
        keymap.exec(function()
            require("fzf-lua").tags()
        end),
        { desc = "Search vim tags" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>ch",
        keymap.exec(function()
            require("fzf-lua").command_history()
        end),
        { desc = "Search vim command history" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>sh",
        keymap.exec(function()
            require("fzf-lua").search_history()
        end),
        { desc = "Search vim search history" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>mk",
        keymap.exec(function()
            require("fzf-lua").marks()
        end),
        { desc = "Search vim marks" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>km",
        keymap.exec(function()
            require("fzf-lua").keymaps()
        end),
        { desc = "Search vim keymaps" }
    ),
}

return M