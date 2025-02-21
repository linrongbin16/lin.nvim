" Please copy this file to 'postinit.vim' to enable it.

" ctrl/cmd-?
if exists("$VIMRUNTIME/mswin.vim")
  source $VIMRUNTIME/mswin.vim
end

if has("mac") && exists("$VIMRUNTIME/macmap.vim")
  source $VIMRUNTIME/macmap.vim
end
