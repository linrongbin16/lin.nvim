" ======== Init ========

" pre init
if filereadable(stdpath('config').'/preinit.vim')
    execute 'source '.stdpath('config').'/preinit.vim'
endif
lua pcall(require, 'preinit')

" options
execute 'source '.stdpath('config').'/lua/builtin/options.vim'
lua require("builtin.lsp")

" plugins
lua require("configs.folke.lazy-nvim.config")

" others
lua require("builtin.colors")
lua require("builtin.others")

" post init
if filereadable(stdpath('config').'/postinit.vim')
    execute 'source '.stdpath('config').'/postinit.vim'
endif
lua pcall(require, 'postinit')