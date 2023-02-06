""" ---- Hot keys ----

" Toggle file explorer
nnoremap <F1> :Neotree reveal toggle<CR>
" Find current file in nvim-tree
nnoremap <S-F1> :NvimTreeFindFile<CR>
" Toggle undotree
nnoremap <F2> :UndotreeToggle<CR>
" Toggle outline
nnoremap <F3> :Vista!!<CR>
" Switch between C/C++ header and source
nnoremap <F4> :ClangdSwitchSourceHeader<CR>
" Toggle marks
nmap <F8> <Plug>MarkToggle
" Markdown preview
nnoremap <F9> :MarkdownPreview<CR>
" Toggle terminal
nnoremap <F10> :ToggleTerm<CR>

""" ---- Biscuits ----

" Toggle folding
nnoremap zz @=((foldclosed(line('.')) < 0) ? 'zc':'zo')<CR>
" Clean highlight, update diff, and refresh color
nnoremap <C-l> :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>
" Copy visual selected text to cache
xnoremap <Leader>y :w! $HOME/.nvim/.copypaste<CR>
" Paste from cache to current cursor
nnoremap <Leader>p :r $HOME/.nvim/.copypaste<CR>

""" ---- Optmization ----

" Rendering
set ttyfast
" Large file
augroup large_file_augroup
    autocmd BufReadPre * let f=expand("<afile>") | if getfsize(f) > luaeval("require('conf/constants').perf.filesystem.maxsize") | syntax clear | setlocal eventignore+=FileType | setlocal undolevels=-1 | endif
augroup END

""" ---- Neovide ----

" if exists("g:neovide")
"     let g:neovide_refresh_rate=60
"     let g:neovide_transparency=1.0
"     let g:neovide_scroll_animation_length=0.0
"     let g:neovide_remember_window_size=v:true
"     let g:neovide_input_use_logo=has('mac') " v:true on macOS
"     let g:neovide_cursor_animation_length=0.0
"     let g:neovide_cursor_trail_length=0.0
"     let g:neovide_cursor_antialiasing=v:true
" endif

""" ---- Add more settings here ----
