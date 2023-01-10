lua<<EOF
  local lspconfig = require('lspconfig')
  lspconfig.clangd.setup({})
  lspconfig.tsserver.setup({})
  lspconfig.html.setup({})
  lspconfig.cssls.setup({})
  lspconfig.sumneko_lua.setup({})
EOF
