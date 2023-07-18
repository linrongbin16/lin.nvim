-- Please copy this file to 'postinit.lua' to enable it.

local constants = require("builtin.utils.constants")

-- ctrl/cmd-?
if vim.fn.exists("$VIMRUNTIME/mswin.vim") > 0 then
    vim.cmd([[source $VIMRUNTIME/mswin.vim]])
end
if constants.os.is_macos and vim.fn.exists("$VIMRUNTIME/macmap.vim") > 0 then
    vim.cmd([[source $VIMRUNTIME/macmap.vim]])
end