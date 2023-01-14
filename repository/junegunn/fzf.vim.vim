""" Use fd for fzf file finding, instead of default find
let $FZF_DEFAULT_COMMAND = 'fd --type f --type symlink --color=never --ignore-case --no-ignore --hidden --exclude ".git"'


""" Fzf command prefix
let g:fzf_command_prefix = 'Fzf'

""" Text search

command! -bang -nargs=* LinFzfRg
            \ call fzf#vim#grep(
            \ "rg --column --line-number --no-heading --color=always --smart-case --no-ignore --hidden --glob=!.git/ -- ".shellescape(<q-args>), 1,
            \ fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=0 LinFzfRgCWord
            \ call fzf#vim#grep(
            \ "rg --column --line-number --no-heading --color=always --smart-case --no-ignore --hidden --glob=!.git/ ".shellescape(expand('<cword>')), 1,
            \ fzf#vim#with_preview(), <bang>0)

function! s:LinDefineFzfKeys(k, v) abort
    execute printf('nnoremap <silent> <expr> %s (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":\<C-u>%s\<CR>"', a:k, a:v)
endfunction

" search text

" search text
call s:LinDefineFzfKeys('<space>gr', 'LinFzfRg')
" search word under cursor
call s:LinDefineFzfKeys('<space>gw', 'LinFzfRgCWord')
" search lines on opened buffers
call s:LinDefineFzfKeys('<space>l', 'FzfLines')
" search text on tags
call s:LinDefineFzfKeys('<space>t', 'FzfTags')
" search searched history
call s:LinDefineFzfKeys('<space>sh', 'FzfHistory/')
" search command history
call s:LinDefineFzfKeys('<space>ch', 'FzfHistory:')

" search files

" search files
call s:LinDefineFzfKeys('<space>f', 'FzfFiles')
call s:LinDefineFzfKeys('<C-p>', 'FzfFiles')
" search opened buffers
call s:LinDefineFzfKeys('<space>b', 'FzfBuffers')
" search history files(v:oldfiles) and opened buffers
call s:LinDefineFzfKeys('<space>hf', 'FzfHistory')

" search git

" search git commits
call s:LinDefineFzfKeys('<space>gc', 'FzfCommits')
" search git files
call s:LinDefineFzfKeys('<space>gf', 'FzfGFile')
" search git status
call s:LinDefineFzfKeys('<space>gs', 'FzfGFiles?')

" other search

" search marks
call s:LinDefineFzfKeys('<space>mk', 'FzfMarks')
" search maps
call s:LinDefineFzfKeys('<space>mp', 'FzfMaps')
" search vim commands
call s:LinDefineFzfKeys('<space>vc', 'FzfCommands')
" search help tags
call s:LinDefineFzfKeys('<space>ht', 'FzfHelptags')
