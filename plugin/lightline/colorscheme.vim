function! lightline#colorscheme#flatten(p) abort
  for k in values(a:p)
    for l in values(k)
      for m in range(len(l))
        let attr = ''
        if len(l[m]) == 3 && type(l[m][2]) == 1
          let attr = l[m][2]
        endif
        let l[m] = [l[m][0][0], l[m][1][0], l[m][0][1], l[m][1][1]]
        if !empty(attr)
          call add(l[m], attr)
        endif
      endfor
    endfor
  endfor
  return a:p
endfunction