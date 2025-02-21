# Global Key Mappings

## OS Standards

The **CTRL** keys is the popular standard in windows system (and also popular among linux desktops), all key mappings are avoid confliction from them:

- `CTRL-A`: Select all.
- `CTRL-C`: Copy.
- `CTRL-V`: Paste.
- `CTRL-X`: Cut.
- `CTRL-S`: Save file.
- `CTRL-Z`: Undo.
- ...

And for the **CMD** keys in mac system, key mappings are avoid as well:

- `CMD-A`: Select all.
- `CMD-C`: Copy.
- `CMD-V`: Paste.
- `CMD-X`: Cut.
- `CMD-S`: Save file.
- `CMD-Z`: Undo.
- ...

> You can use `source $VIMRUNTIME/mswin.vim` to enable windows standard keys, `source $VIMRUNTIME/macmap.vim` to enable mac standard keys.

## Plugin Commands

- `<Leader>nt` 🄽 - Toggle file explorer by `:Neotree`.
- `<Leader>nf` 🄽 - Find/locate current file in file explorer by `:Neotree reveal`.
- `<Leader>ol` 🄽 - Toggle structure/symbols outlines by `:Outline!!`.
- `<Leader>mp` 🄽 - Open markdown preview by `:MarkdownPreview`.
- `<Leader>ms` 🄽 - Open lsp server manager by `:Mason`.
- `<Leader>lz` 🄽 - Open plugin manager by `:Lazy`.
- `<Leader>lg` 🄽 - Open lazygit by `:LazyGit`.
- `<Leader>wk` 🄽 - Open key bindings by `:WhichKey`.

## Misc

### Save Files

- `<Leader>ww` 🄽 - Save file without formatting, e.g. `:noa w<CR>`.

### Quit

- `<Leader>qq` 🄽 - `:qall!<CR>`.

### Folding

- `<Leader>zz` 🄽 - Toggle folding.

### Copy/Paste over SSH

> Copy/paste over SSH can be difficult since system clipboard is not synchronized. Here introduce two shortcuts using local cache:

- `<Leader>yy` 🅇 - Copy visual selected to `~/.nvim/.copypaste`.
- `<Leader>pp` 🄽 - Paste from `~/.nvim/.copypaste` to current cursor.
