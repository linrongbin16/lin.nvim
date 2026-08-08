# Other Settings

There're several config files for Neovim's settings/options:

- `lua/prelude/option.lua`: Basic Neovim options such as `autoindent`, `clipboard`, `updatetime`, `hlsearch`, etc.
- `lua/prelude/diagnostic.lua`: Neovim diagnostic configurations.
- `lua/prelude/lsp.lua`: Neovim LSP configurations.
- `lua/prelude/misc.lua`: Other Neovim settings such as `guifont`, `winblend`, `pumblend` and some global key mappings.

There're 4 hooks that helps customize these settings:

- `preinit.vim` and `lua/preinit.lua`: Once provided, this vim/lua script will been loaded just after Neovim start, before everything else. You can simply copy and rename `preinit_sample.vim` and `lua/preinit_sample.lua` to enable it.
- `postinit.vim` and `lua/postinit.lua`: Once provided, this vim/lua script will been loaded after all the other configurations finished loading. You can simply copy and rename `postinit_sample.vim` and `lua/postinit_sample.lua` to enable it.
