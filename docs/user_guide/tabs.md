# Tabs

?> Supported by [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) and [snacks.nvim](https://github.com/folke/snacks.nvim).

Tabs is the tabline at the top of the Neovim editor, shows opened buffers/files.

<!-- Screenshots are recorded with 150x40 kitty terminal -->

<img width="70%" alt="image" src="https://github.com/linrongbin16/lin.nvim/assets/6496887/e7b249fc-bcd7-4868-a634-eecfc1a5808b">

Here're some most useful keys:

## Navigation

- `<Leader>1` ~ `<Leader>9`, `<Leader>0` 🄽 - Go to the 1st ~ 9th buffer, and the last buffer.
- `]b`/`[b` 🄽 - Go to next(👉)/previous(👈) buffer.
- `<Leader>bd`/`<Leader>bD` 🄽 - Close current buffer by `require("snacks").bufdelete()`, or forcibly with `{force=true}` option.

## Move/Re-order

- `<Leader>.`/`<Leader>,` 🄽 - Move/re-order current buffer to next(👉)/previous(👈) position.

## Mouse

- `<LeftMouse>` 🄽 - Go to buffer.
- `<RightMouse>` 🄽 - Close buffer.
