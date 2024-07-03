# Other Settings

There're several config files for Neovim's settings/options:

- [lua/builtin/options.lua](https://github.com/linrongbin16/lin.nvim/blob/237cebf9a9f08cb23bea40c0127844aa6ab4d5e0/lua/builtin/options.lua?plain=1): Basic Neovim options such as `autoindent`, `clipboard`, `updatetime`, `hlsearch`, etc.
- [lua/builtin/diagnostic.lua](https://github.com/linrongbin16/lin.nvim/blob/237cebf9a9f08cb23bea40c0127844aa6ab4d5e0/lua/builtin/diagnostic.lua?plain=1): Neovim diagnostic configurations.
- [lua/builtin/lsp.lua](https://github.com/linrongbin16/lin.nvim/blob/237cebf9a9f08cb23bea40c0127844aa6ab4d5e0/lua/builtin/lsp.lua?plain=1): Neovim LSP configurations.
- [lua/builtin/others.lua](https://github.com/linrongbin16/lin.nvim/blob/237cebf9a9f08cb23bea40c0127844aa6ab4d5e0/lua/builtin/others.lua?plain=1): Other Neovim settings such as `guifont`, `winblend`, `pumblend` and some global key mappings.

There're 4 hooks that helps customize these settings:

- `preinit.vim` and `lua/preinit.lua`: Once provided, this vim/lua script will been loaded just after Neovim start, before everything else. You can simply copy and rename [preinit_sample.vim](https://github.com/linrongbin16/lin.nvim/blob/237cebf9a9f08cb23bea40c0127844aa6ab4d5e0/preinit_sample.vim?plain=1) and [lua/preinit_sample.lua](https://github.com/linrongbin16/lin.nvim/blob/237cebf9a9f08cb23bea40c0127844aa6ab4d5e0/lua/preinit_sample.lua?plain=1) to enable it.
- `postinit.vim` and `lua/postinit.lua`: Once provided, this vim/lua script will been loaded after all the other configurations finished loading. You can simply copy and rename [postinit_sample.vim](https://github.com/linrongbin16/lin.nvim/blob/237cebf9a9f08cb23bea40c0127844aa6ab4d5e0/postinit_sample.vim?plain=1) and [lua/postinit_sample.lua](https://github.com/linrongbin16/lin.nvim/blob/237cebf9a9f08cb23bea40c0127844aa6ab4d5e0/lua/postinit_sample.lua?plain=1) to enable it.
