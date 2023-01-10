lua<<EOF
local lin_keymap = {
  -- navigation
  { key = "l",              action = "edit" },          -- open folder or edit file
  { key = "h",              action = "close_node" },    -- close folder

  -- copy/paste/cut
  { key = "X",              action = "cut" },
  { key = "C",              action = "copy" },
  { key = "V",              action = "paste" },
}

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require'nvim-tree'.setup {
  open_on_setup = true,
  open_on_setup_file = false,
  view = {
    width = 40,
    side = "left",
    signcolumn = "yes",
    mappings = {
      custom_only = false,
      list = lin_keymap,
    },
  },
  renderer = {
    highlight_git = true,
    indent_markers = {
      enable = true,
    },
    icons = {
      webdev_colors = true,
      git_placement = "signcolumn",
      glyphs = {
        default = "",
        symlink = "",
      },
    },
  },
  update_focused_file = {
    enable      = true,
    update_root = true,
  },
  git = {
    enable = true,
    ignore = false,
  },
}
EOF

function! s:LinDefineNvimTreeKeys(k) abort
    execute printf('nnoremap <silent> <buffer> <%s-,> :<C-u>NvimTreeResize -10<CR>', a:k)
    execute printf('nnoremap <silent> <buffer> <%s-Left> :<C-u>NvimTreeResize -10<CR>', a:k)
    execute printf('nnoremap <silent> <buffer> <%s-.> :<C-u>NvimTreeResize +10<CR>', a:k)
    execute printf('nnoremap <silent> <buffer> <%s-Right> :<C-u>NvimTreeResize +10<CR>', a:k)
endfunction

function! s:LinNvimTreeSettings() abort
    " key mapping

    " resize explorer width
    call s:LinDefineNvimTreeKeys('D')
    call s:LinDefineNvimTreeKeys('A')
    call s:LinDefineNvimTreeKeys('M')
    call s:LinDefineNvimTreeKeys('C')
endfunction

augroup LinNvimTreeAuGroup
    autocmd!
    autocmd FileType NvimTree call s:LinNvimTreeSettings()
augroup END
