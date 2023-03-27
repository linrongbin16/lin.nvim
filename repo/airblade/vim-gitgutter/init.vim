" disable default mappings
let g:gitgutter_map_keys = 0

" lower sign priority for diagnostic sign
let g:gitgutter_sign_priority = 1
" don't clobber diagnostic sign, default: 0
" let g:gitgutter_sign_allow_clobber = 0

" use rg to improve performance
if executable('rg')
    let g:gitgutter_grep = 'rg'
endif

" use float window for preview
let g:gitgutter_preview_win_floating = 1

" gitsigns style signs
" unicode symbols: https://symbl.cc/en/html-entities/
let g:gitgutter_sign_added = '┃'                    " '+'
let g:gitgutter_sign_modified = '┃'                 " '~'
let g:gitgutter_sign_removed = '▁'                  " '_'
let g:gitgutter_sign_removed_first_line = '▔'       " '‾'
" let g:gitgutter_sign_modified_removed = '~_'
" let g:gitgutter_sign_removed_above_and_below = '_¯'