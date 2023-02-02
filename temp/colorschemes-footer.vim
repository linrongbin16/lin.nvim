    \]

function! s:RandNum(n) abort
  return str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:]) % a:n
endfunction

function LinNextRandomColor()
    if len(s:colors) > 0
        let idx = s:RandNum(len(s:colors))
        execute 'colorscheme ' . s:colors[idx]
    endif
endfunction

function LinNextRandomColorSync()
    if len(s:colors) > 0
        let idx = s:RandNum(len(s:colors))
        execute 'colorscheme ' . s:colors[idx]
        execute 'syntax sync fromstart'
    endif
endfunction
