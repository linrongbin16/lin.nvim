# File Explorer

?> Supported by [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim).

File explorer is a sidebar on the left side in Neovim editor, shows current working directory and let user easily operate the file systems.

<!-- Screenshots are recorded with 150x40 kitty terminal -->

<img width="70%" alt="image" src="https://github.com/linrongbin16/lin.nvim/assets/6496887/53cb0723-f05f-46c3-89de-7eeb56ccb806">

## Global Key Mappings

There're two global key mappings for easier working with neo-tree:

- `<Leader>nt` 🄽 - Toggle file explorer by `:Neotree`.
- `<Leader>nf` 🄽 - Find/locate current file in file explorer by `:Neotree reveal`.

## Local Key Mappings

Neo-tree also provide a lot of buffer-local key mappings (which only works inside the neo-tree buffer), we keep most of them by default, only a few are changed:

### Added Keys

- `l` 🄽 - Open file/directory.
- `h` 🄽 - Close directory.
- `<C-f>` 🄽 - Fuzzy finder.
- `[c`/`]c` 🄽 - Navigate to previous(👆)/next(👇) git changes.

?> Edit the plugin settings in [lua/configs/nvim-neo-tree/neo-tree-nvim](https://github.com/linrongbin16/lin.nvim/tree/main/lua/configs/nvim-neo-tree/neo-tree-nvim) directory.

?> For full key mappings, please refer to neo-tree's document: [neo-tree-mappings](https://github.com/nvim-neo-tree/neo-tree.nvim/blob/main/doc/neo-tree.txt).
