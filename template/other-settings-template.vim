
""" ---- Hot keys ----
" Toggle file explorer
nnoremap <F1> :<C-u>NvimTreeToggle<CR>
" Toggle undotree
nnoremap <F2> :<C-u>UndotreeToggle<CR>
" Toggle outline
nnoremap <F3> :<C-u>Vista!!<CR>
" Switch between C/C++ header and source
nnoremap <F4> :<C-u>ClangdSwitchSourceHeader<CR>
" Toggle marks
nmap <F7> <Plug>MarkToggle
" Clear marks, use '<Plug>MarkAllClear' without confirmation
nmap <S-F7> <Plug>MarkConfirmAllClear
" Markdown preview
nnoremap <F8> :<C-u>MarkdownPreview<CR>
" Toggle terminal
nnoremap <F9> :<C-u>ToggleTerm<CR>
" Toggle bufexplorer
nnoremap <F10> :<C-u>ToggleBufExplorer<CR>

""" ---- Ctrl/cmd keys ----
if exists('$VIMRUNTIME/mswin.vim')
    source $VIMRUNTIME/mswin.vim
endif
if has('mac') && exists('$VIMRUNTIME/macmap.vim')
    source $VIMRUNTIME/macmap.vim
endif

""" ---- Enhanced copy-paste ----
" Copy visual selected text to cache
vnoremap <Leader>y :w! ~/.vim/.copypaste<CR>
" Paste from cache to current cursor
nnoremap <Leader>p :r ~/.vim/.copypaste<CR>

""" ---- Disable syntax highlight for super big file ----
""" filesize=1000000
" autocmd BufWinEnter * if line2byte(line("$") + 1) > 1000000 | syntax clear | endif

""" ---- Neovide ----
" let g:neovide_refresh_rate=60
" let g:neovide_transparency=1.0
" let g:neovide_scroll_animation_length=0.0
" let g:neovide_remember_window_size=v:true
" let g:neovide_input_use_logo=has('mac') " v:true on macOS
" let g:neovide_cursor_animation_length=0.0
" let g:neovide_cursor_trail_length=0.0
" let g:neovide_cursor_antialiasing=v:true

""" ---- Add more settings here ----

