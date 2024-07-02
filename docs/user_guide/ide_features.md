# IDE Features

?> Programming language related functions rely on a [LSP server](https://microsoft.github.io/language-server-protocol/implementors/servers/), please check out [LSP server management](/user_guide/lsp_server_management.md).

## Auto-Complete

?> Supported by [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) and some extensions.

<!-- Screenshots are recorded with 150x40 kitty terminal -->

<img width="70%" alt="image" src="https://github.com/linrongbin16/lin.nvim/assets/6496887/fdd9a455-2583-4a77-b9b5-4c27bfa74667">

- `<C-N>`/`<C-P>`, `<Down>`/`<Up>` 🄸 - Navigate to next(👇) suggestion.
- `<C-U>`/`<C-D>` 🄸 - Scroll up(👆)/down(👇) the suggestion docs.
- `<TAB>`/`<CR>` 🄸 - Confirm current suggestion.
- `<ESC>`/`<C-[>` 🄸 - Close suggestion.
- `<C-F>`/`<C-B>` 🄸 - Navigate to next(👉)/previous(👈) snippet placeholder.

## Symbol Navigation

?> Supported by [fzfx.nvim](https://github.com/linrongbin16/fzfx.nvim).

<!-- Screenshots are recorded with 150x40 kitty terminal -->

<img width="70%" alt="image" src="https://github.com/linrongbin16/lin.nvim/assets/6496887/0830c66c-cd97-41f5-b048-80a8d8d3462b">

- `gd` 🄽 - Go to definitions.
- `gr` 🄽 - Go to references.
- `gi` 🄽 - Go to implementations.
- `gt` 🄽 - Go to type definitions.
- `<Leader>ic` 🄽 - Go to incoming calls.
- `<Leader>og` 🄽 - Go to outgoing calls.

?> For full key mappings, please refer to [fzfx's usage](https://github.com/linrongbin16/fzfx.nvim?#-usage).

## Code Format

?> Supported by [conform.nvim](https://github.com/stevearc/conform.nvim).

Code format runs on file save asynchronously by default. To manually trigger code format:

- `<Leader>cf` 🄽 🅇 - Synchronously format code on current buffer (normal mode) or on visual selections (visual mode).

?> Edit the plugin settings in [lua/configs/stevearc/conform-nvim](https://github.com/linrongbin16/lin.nvim/tree/main/lua/configs/stevearc/conform-nvim) directory.

?> Check out [LSP server management - Formatters](/user_guide/lsp_server_management.md#formatters) for how to configure code formatters.

## Diagnostics

Navigate different diagnostics:

- `[d`/`]d` 🄽 - Go to previous(👆)/next(👇) diagnostic item.
- `[e`/`]e` 🄽 - Go to previous(👆)/next(👇) error.
- `[w`/`]w` 🄽 - Go to previous(👆)/next(👇) warning.

Run code actions:

- `<Leader>ca` 🄽 🅇 - Run code actions under cursor (normal mode) or on visual selections (visual mode).

?> Check out [LSP server management](/user_guide/lsp_server_management.md) for how to configure LSP servers and linters.
