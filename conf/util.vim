function! LinExecuteOnEditableBuffer(c) abort
    let n = winnr('$')
    let i = 0
    while i < n
        let i += 1
        " non-editable window
        if &filetype ==# "NvimTree" || &filetype ==# "undotree" || &filetype ==# "vista" || &filetype ==# 'diff'
            execute "wincmd w"
        else
            " editable window
            execute a:c
            return
        endif
    endwhile
    " if finally don't have an editable window
    " execute command on original window
    execute a:c
endfunction
