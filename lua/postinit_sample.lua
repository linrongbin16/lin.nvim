-- Please copy this file to 'postinit.lua' to enable it.

-- ctrl/cmd-?
if vim.fn.exists("$VIMRUNTIME/mswin.vim") > 0 then
    vim.cmd([[source $VIMRUNTIME/mswin.vim]])
end
if vim.fn.has("mac") > 0 and vim.fn.exists("$VIMRUNTIME/macmap.vim") > 0 then
    vim.cmd([[source $VIMRUNTIME/macmap.vim]])
end
