# File Explorer

?> Supported by [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim).

File explorer is a sidebar on the left side in Neovim editor, shows current working directory and let user easily operate the file systems.

<img width="70%" alt="image" src="https://github.com/linrongbin16/lin.nvim/assets/6496887/76d06496-8e81-4efb-b928-f1ab0fa78f1e">

Here're some most useful keys:

## Editing

- `l` (new) 🄽 - Open file/directory.
- `h` (new) 🄽 - Close directory.
- `<C-w>t` (new, default `<C-t>` is removed) 🄽 - Open file in new tab.
- `<C-w>v` (new, default `<C-v>` is removed) 🄽 - Open file in vsplit.
- `<C-w>s` (new, default `<C-x>` is removed) 🄽 - Open file in split.
- `.` (new) 🄽 - Set to current root directory.
- `<BS>` (new) 🄽 - Go to upper directory.

## Operation

- `a` (default) 🄽 - Create file/directory, add trailing slash `/` (or backslash `\\` on Windows) to create a directory. You can also use `A` to create a directory.
- `d` (default) 🄽 - Moving to trash bin. You can also use `D` to delete (`rm`).
- `c` (default) 🄽 - Copy.
- `x` (default) 🄽 - Cut.
- `p` (default) 🄽 - Paste from previously `c`/`x`.
- `r`/`m` (default) 🄽 - Rename/move file/directory.
- `R` (default) 🄽 - Refresh.
- `P` (default) 🄽 - Toggle preview.

## Other

- `W` (new, default `z` is removed) 🄽 - Collapse all directories.
- `E` (new, default `e` is removed) 🄽 - Expand all directories.
- `<Leader>.`/`<Leader>,` (new) 🄽 - Resize explorer width bigger/smaller.
- `]c`/`[c` (new), `]g`/`[g` (default) 🄽 - Go to next(👇)/previous(👆) git item.
- `q` (default) 🄽 - Quit.
- `?` (default) 🄽 - Help.

?> Edit the plugin settings in [lua/configs/nvim-neo-tree/neo-tree-nvim](https://github.com/linrongbin16/lin.nvim/tree/main/lua/configs/nvim-neo-tree/neo-tree-nvim) directory.

?> For full key mappings, please refer to neo-tree's document: [neo-tree-mappings](https://github.com/nvim-neo-tree/neo-tree.nvim/blob/main/doc/neo-tree.txt).
