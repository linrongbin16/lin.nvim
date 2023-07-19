-- ---- Other Options ----

--- @type LuaModule
local constants = require("builtin.utils.constants")
--- @type BuiltinKeymapSetkey
local set_key = require("builtin.utils.keymap").set_key

-- GUI font
if constants.os.is_windows then
    -- Windows
    vim.o.guifont = "Hack NFM:h10"
else
    if constants.os.is_macos then
        -- MacOS
        vim.o.guifont = "Hack Nerd Font Mono:h13"
    else
        -- Linux
        vim.o.guifont = "Hack Nerd Font Mono:h10"
    end
end

-- random colorscheme
vim.cmd([[SwitchColor]])

-- biscuits
set_key(
    { "n", "x" },
    "<leader>ww",
    ":noa w<CR>",
    { silent = false, desc = "Save file without formatting" }
)
set_key(
    { "n", "x" },
    "<leader>qt",
    ":quit<CR>",
    { silent = false, desc = ":quit" }
)
set_key(
    { "n", "x" },
    "<leader>qT",
    ":quit!<CR>",
    { silent = false, desc = ":quit!" }
)
set_key(
    { "n", "x" },
    "<leader>qa",
    ":qall<CR>",
    { silent = false, desc = ":qall" }
)
set_key(
    { "n", "x" },
    "<leader>qA",
    ":qall!<CR>",
    { silent = false, desc = ":qall!" }
)
set_key(
    { "n", "x" },
    "<leader>zz",
    "@=((foldclosed(line('.')) < 0) ? 'zc':'zo')<CR>",
    { silent = false, desc = "Toggle folding" }
)
set_key(
    "x",
    "<leader>yy",
    ":w! " .. vim.fn.stdpath("config") .. "/.copypaste<CR>",
    { silent = false, desc = "Copy visual selected to cache" }
)
set_key(
    "n",
    "<leader>pp",
    ":r " .. vim.fn.stdpath("config") .. "/.copypaste<CR>",
    { silent = false, desc = "Paste from cache" }
)

-- large file performance
vim.api.nvim_create_augroup("large_file_performance_augroup", { clear = true })
vim.api.nvim_create_autocmd("BufReadPre", {
    group = "large_file_performance_augroup",
    callback = function()
        local f = vim.fn.expand("<afile>")
        if vim.fn.getfsize(f) > constants.perf.file.maxsize then
            vim.cmd([[
                syntax clear
                setlocal eventignore+=FileType
                setlocal undolevels=-1
            ]])
        end
    end,
})

-- transparent
vim.o.winblend = constants.ui.winblend
vim.o.pumblend = constants.ui.pumblend