lua<<EOF
local keymap = vim.keymap.set
local saga = require('lspsaga')

saga.init_lsp_saga()
EOF
