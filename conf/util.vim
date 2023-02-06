""" ---- Utils ----

function! LinExecuteOnEditableBuffer(cmd) abort
    let n = winnr('$')
    let i = 0
    while i < n
        let i += 1
        " non-editable window
        if &filetype ==# "neo-tree" || &filetype ==# "NvimTree" || &filetype ==# "undotree" || &filetype ==# "vista" || &filetype ==# 'diff'
            execute "wincmd w"
        else
            " editable window
            execute a:cmd
            return
        endif
    endwhile
    " if finally don't have an editable window
    " execute command on original window
    execute a:cmd
endfunction
