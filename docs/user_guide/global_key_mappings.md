# Global Key Mappings

## Plugin Keys

- `<Leader>nt` 🄽 - Toggle file explorer by `:Neotree`.
- `<Leader>nf` 🄽 - Find/locate current file in file explorer by `:Neotree reveal`.
- `<Leader>ol` 🄽 - Toggle structure/symbols outlines by `:Outline!!`.
- `<Leader>mp` 🄽 - Open markdown preview by `:MarkdownPreview`.
- `<Leader>ms` 🄽 - Open lsp server manager by `:Mason`.
- `<Leader>lz` 🄽 - Open plugin manager by `:Lazy`.
- `<Leader>lg` 🄽 - Open lazygit by `:LazyGit`.
- `<Leader>wk` 🄽 - Open key bindings by `:WhichKey`.

## Vim Keys

### Save Files

- `<Leader>ww` 🄽 - Save file without formatting, e.g. `:noa w<CR>`.

### Quit

- `<Leader>qq` 🄽 - `:qall!<CR>`.

### Folding

- `<Leader>zz` 🄽 - Toggle folding.

### Copy/Paste over SSH

> Copy/paste over SSH can be difficult since system clipboard is not syncronized. Here introduce two shortcuts using local cache:

- `<Leader>yy` 🅇 - Copy visual selected to `~/.nvim/.copypaste`.
- `<Leader>pp` 🄽 - Paste from `~/.nvim/.copypaste` to current cursor.
