""" ---- Hot keys ----
" Toggle file explorer
lua require('conf/keymap').map('n', '<F1>', ':Neotree reveal toggle<CR>', {silent=false})
" Toggle undotree
lua require('conf/keymap').map('n', '<F2>', ':UndotreeToggle<CR>', {silent=false})
" Toggle outline
lua require('conf/keymap').map('n', '<F3>', ':Vista!!<CR>', {silent=false})
" Switch between C/C++ header and source
lua require('conf/keymap').map('n', '<F4>', ':ClangdSwitchSourceHeader<CR>', {silent=false})
" Markdown preview
lua require('conf/keymap').map('n', '<F9>', ':MarkdownPreview<CR>', {silent=false})
" Toggle terminal
lua require('conf/keymap').map('n', '<F10>', ':ToggleTerm<CR>', {silent=false})

""" ---- Biscuits ----
" Commands
lua require('conf/keymap').map('n', '<leader>ms', ':Mason<CR>', {silent=false})
lua require('conf/keymap').map('n', '<leader>lz', ':Lazy<CR>', {silent=false})
lua require('conf/keymap').map('n', '<leader>wk', ':WhichKey ', {silent=false})
" Quit
lua require('conf/keymap').map('n', '<leader>qt', ':quit<CR>', {silent=false})
lua require('conf/keymap').map('n', '<leader>qT', ':quit!<CR>', {silent=false})
lua require('conf/keymap').map('n', '<leader>qa', ':qall<CR>', {silent=false})
lua require('conf/keymap').map('n', '<leader>qA', ':qall!<CR>', {silent=false})
" Toggle folding
lua require('conf/keymap').map('n', '<leader>zz', "@=((foldclosed(line('.')) < 0) ? 'zc':'zo')<CR>", {silent=false})
" Copy visual selected text to cache
lua require('conf/keymap').map('n', '<leader>y', ":w! $HOME/.nvim/.copypaste<CR>", {silent=false})
" Paste from cache to current cursor
lua require('conf/keymap').map('n', '<leader>y', ":r $HOME/.nvim/.copypaste<CR>", {silent=false})

""" ---- Optimization ----
" Rendering
set ttyfast
" Large file
augroup optimization_augroup
    autocmd!
    autocmd BufReadPre * let f=expand("<afile>") | if getfsize(f) > luaeval("require('conf/constants').perf.filesystem.maxsize") | syntax clear | setlocal eventignore+=FileType | setlocal undolevels=-1 | endif
augroup END
" Neovide
if exists("g:neovide")
    let g:neovide_refresh_rate=30
    let g:neovide_transparency=1.0
    let g:neovide_scroll_animation_length=0.0
    let g:neovide_remember_window_size=v:true
    let g:neovide_input_use_logo=has('mac') " v:true on macOS
    let g:neovide_cursor_animation_length=0.0
    let g:neovide_cursor_trail_length=0.0
    let g:neovide_cursor_antialiasing=v:true
endif

""" ---- Add more settings here ----
