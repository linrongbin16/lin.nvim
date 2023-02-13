    \]

function! s:rand_int(n) abort
  return str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:]) % a:n
endfunction

function s:lin_next_color(color, update)
  " echom 'a:color:' . a:color . ', a:update:' . a:update
  if len(a:color) > 0
    execute 'colorscheme ' . a:color
  else
    if len(s:colors) > 0
      let idx = s:rand_int(len(s:colors))
      execute 'colorscheme ' . s:colors[idx]
    else
      execute 'normal! \<Esc>'
      echohl ErrorMsg
      echomsg 'Error: no colorscheme installed, check `~/.nvim/colorschemes.vim`!'
      echohl None
    endif
  endif
  if a:update
    execute 'diffupdate'
    execute 'syntax sync fromstart'
  endif
endfunction

command! -bang -nargs=? NextColor call s:lin_next_color(<q-args>, <bang>0)
