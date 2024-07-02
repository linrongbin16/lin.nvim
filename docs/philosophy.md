# Philosophy

## No-Manual Installation

All done by one-line command (not for Windows now), and work out of the box.

## IDE Features

- Modern UI: file explorer, tabs, icons, etc.
- Colors and highlightings.
- Auto-complete.
- Global Search.
- Format on save.
- Diagnostics & lint.
- And a lot more...

## Focus

- Focus on and only on editing.
- Performant, even with tons of things.
- Neat and clean looks.

## Compatibility

No effort is spent on maintaining Neovim's backward compatibility, this config assumes always running on the [latest stable neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim).

Support most popular desktop operating systems, i.e. Windows, Linux and Mac OS. For Linux, support the latest LTS distributions, for example the latest ubuntu-lts.

## Keymap

### CTRL+? Keys

`CTRL+?` (and `CMD+?` for macOS) keys follow most editors' behavior, i.e. use `CTRL+A` to select all, `CTRL+C` to copy, `CTRL+P` to paste, `CTRL+S` to save file, `CTRL+Z` to undo, etc. And copy/paste work with system clipboard.

### Vim Keys

- Initial letter of each word as key mapping sequence.
- Same prefix for the same group of functionality.
- Fewer keys for higher frequency.
- Follow classic, popular behavior, or plugin author's recommendation.

Specifically, we have the below rules:

- `<Leader>` as a prefix for commands.
- Especially `<Space>` as a prefix for telescope/fzf commands.
- `g` as a prefix for LSP symbol navigations.
- `]`/`[` as prefix for next/previous navigations.
- `,`/`.`(or `<`/`>`) for right👉/left👈(or down👇/up👆) directions.
- Capitalized last letter as vim command bang, or lower frequency variant.
