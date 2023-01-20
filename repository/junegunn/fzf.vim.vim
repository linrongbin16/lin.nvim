""" Use fd for fzf file finding, instead of default find
if executable('fd')
    let $FZF_DEFAULT_COMMAND = 'fd -tf -tl -i -u --exclude ".git"'
elseif executable('fdfind')
    let $FZF_DEFAULT_COMMAND = 'fdfind -tf -tl -i -u --exclude ".git"'
endif
let $BAT_THEME = 'base16'

""" Fzf command prefix
let g:fzf_command_prefix = 'Fzf'

" for advanced rg integration, please see:
" https://github.com/junegunn/fzf.vim#example-advanced-ripgrep-integration
command! -bang -nargs=* LinFzfRg
            \ call fzf#vim#grep(
            \ "rg --column --no-heading --color=always -S -u -u --glob=!.git/ -- ".shellescape(<q-args>), 1,
            \ fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=0 LinFzfRgCWord
            \ call fzf#vim#grep(
            \ "rg --column --no-heading --color=always -S -u -u --glob=!.git/ ".shellescape(expand('<cword>')), 1,
            \ fzf#vim#with_preview(), <bang>0)

""" Text
" live grep
nnoremap <space>r    :LinFzfRg<CR>
" cursor word/string
nnoremap <space>w    :LinFzfRgCWord<CR>
" lines in opened buffers
nnoremap <space>ln   :FzfLines<CR>
" tags
nnoremap <space>tg   :FzfTags<CR>

""" History
" search history
nnoremap <space>sh   :FzfHistory/<CR>
" vim command history
nnoremap <space>ch   :FzfHistory:<CR>

""" Files
" files
nnoremap <space>f    :FzfFiles<CR>
" opened buffers
nnoremap <space>b    :FzfBuffers<CR>
" history files/oldfiles
nnoremap <space>hf   :FzfHistory<CR>

""" Lsp
" all diagnostics
nnoremap <space>dg   :LspDiagnosticsAll<CR>

""" Git
" git commits
nnoremap <space>gc   :FzfCommits<CR>
" git files
nnoremap <space>gf   :FzfGFiles<CR>
" git status files
nnoremap <space>gs   :FzfGFiles?<CR>

""" Vim
" vim marks
nnoremap <space>mk   :FzfMarks<CR>
" vim key mappings
nnoremap <space>mp   :FzfMaps<CR>
" vim commands
nnoremap <space>cm   :FzfCommands<CR>
" vim help tags
nnoremap <space>ht   :FzfHelptags<CR>
" vim colorschemes
nnoremap <space>cl   :FzfColors<CR>
" vim filetypes
nnoremap <space>ft   :FzfFiletypes<CR>
