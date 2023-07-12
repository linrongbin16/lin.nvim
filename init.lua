-- preload user options
if
    vim.fn.filereadable(vim.fn.expand("~/.nvim/lua/builtin/users_preload.lua"))
    > 0
then
    require("builtin.users_preload")
end
if
    vim.fn.filereadable(vim.fn.expand("~/.nvim/lua/builtin/users_preload.vim"))
    > 0
then
    vim.cmd("source $HOME/.nvim/lua/builtin/users_preload.vim")
end

-- basic options
vim.cmd([[source $HOME/.nvim/lua/builtin/options.vim]])

-- plugins
require("configs.folke.lazy-nvim.config")

-- other options
require("builtin.colors")
require("builtin.others")

-- postload user options
if
    vim.fn.filereadable(vim.fn.expand("~/.nvim/lua/builtin/users_postload.lua"))
    > 0
then
    require("builtin.users_postload")
end
if
    vim.fn.filereadable(vim.fn.expand("~/.nvim/lua/builtin/users_postload.vim"))
    > 0
then
    vim.cmd("source $HOME/.nvim/lua/builtin/users_postload.vim")
end