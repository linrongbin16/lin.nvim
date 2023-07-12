set guifont=NotoSansMono\ NFM:h13

if exists('g:neovide')
    let g:neovide_scroll_animation_length = 0.0
    let g:neovide_cursor_animation_length = 0.0
    let g:neovide_refresh_rate = 60
    let g:neovide_remember_window_size = v:true
    let g:neovide_input_macos_alt_is_meta = has('mac')
endif