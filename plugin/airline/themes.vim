" generates a dictionary which defines the colors for each highlight group
function! airline#themes#generate_color_map(sect1, sect2, sect3, ...)
  let palette = {
        \ 'airline_a': [ a:sect1[0] , a:sect1[1] , a:sect1[2] , a:sect1[3] , get(a:sect1 , 4 , '') ] ,
        \ 'airline_b': [ a:sect2[0] , a:sect2[1] , a:sect2[2] , a:sect2[3] , get(a:sect2 , 4 , '') ] ,
        \ 'airline_c': [ a:sect3[0] , a:sect3[1] , a:sect3[2] , a:sect3[3] , get(a:sect3 , 4 , '') ] ,
        \ }

  if a:0 > 0
    call extend(palette, {
          \ 'airline_x': [ a:1[0] , a:1[1] , a:1[2] , a:1[3] , get(a:1 , 4 , '' ) ] ,
          \ 'airline_y': [ a:2[0] , a:2[1] , a:2[2] , a:2[3] , get(a:2 , 4 , '' ) ] ,
          \ 'airline_z': [ a:3[0] , a:3[1] , a:3[2] , a:3[3] , get(a:3 , 4 , '' ) ] ,
          \ })
  else
    call extend(palette, {
          \ 'airline_x': [ a:sect3[0] , a:sect3[1] , a:sect3[2] , a:sect3[3] , '' ] ,
          \ 'airline_y': [ a:sect2[0] , a:sect2[1] , a:sect2[2] , a:sect2[3] , '' ] ,
          \ 'airline_z': [ a:sect1[0] , a:sect1[1] , a:sect1[2] , a:sect1[3] , '' ] ,
          \ })
  endif

  return palette
endfunction