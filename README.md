# lin.nvim : Lin Rongbin's Neovim Distribution

lin.nvim is a highly configured [neovim](https://neovim.io/) distribution integrated with tons of utilities for development, inspired by [spf13-vim](https://github.com/spf13/spf13-vim).

**_[neovide](https://neovide.dev/) is highly recommended as a high-performance neovim GUI client._**

# Table of Contents

- [Introduction](#introduction)
  - [Screenshots](#screenshots)
  - [Feature](#feature)
- [Installation](#installation)
  - [Requirement](#requirement)
  - [UNIX/Linux/macOS](#unixlinuxmacos)
  - [Windows](#windows)
  - [More Options](#more-options)
  - [Upgrade](#upgrade)
- [User Guide](#user-guide)
  - [Global Key Mappings](#global-key-mappings)
    - [Hot Keys](#hot-keys)
    - [Control/Command+? Keys](#controlcommand-keys)
  - [UI](#ui)
    - [File Explorer](#file-explorer)
    - [Tabline](#tabline)
    - [Font](#font)
  - [IDE-like Editing Features](#ide-like-editing-features)
    - [Code Complete](#code-complete)
    - [Jumps](#jumps)
    - [Symbols](#symbols)
    - [Code Format](#code-format)
    - [Code Actions](#code-actions)
    - [Git](#git)
  - [LSP Servers Manager](#lsp-servers-manager)
  - [Search](#search)
    - [Text Search](#text-search)
    - [File Search](#file-search)
    - [Git Search](#git-search)
    - [Other Search](#other-search)
  - [Editing Enhancement](#editing-enhancement)
    - [Easy Comment](#easy-comment)
    - [Cursor Motion](#cursor-motion)
    - [Word Movement](#word-movement)
    - [Better Repeat](#better-repeat)
    - [Better Matching](#better-matching)
    - [Auto Pair and Close HTML Tag](#auto-pair-and-close-html-tag)
  - [Customization](#customization)
- [Appendix](#appendix)
  - [Embedded Language Servers](#embedded-language-servers)
  - [Color Schemes](#color-schemes)
- [Contribute](#contribute)

# Introduction

Aim to be out-of-box, IDE-like editing experience, high performance, light weight and friendly to neovim users. Focus on and only on editing, no compile/package/debug.

Solve below issues:

- Time-costing vim configurations - All behaviors follow the community's best practice and most popular editors (just like [vscode](https://code.visualstudio.com/)).
- Lack of IDE-like editing features - Language server protocol(LSP) support by [nvim-cmp](https://github.com/hrsh7th/nvim-cmp), a bunch of language servers are embedded.
- Don't know how to choose/configure/manage vim plugins - All plugins are carefully selected and well-cooperated for the best performance and user experience, covered most modern editor features (again, just like vscode).
- Duplicate installation on different OS and machines - All done by one-line command (not on Windows for now), and all OS behave the same (the only difference is using command-key on macOS instead of alt-key on Windows/Linux).
- Naive UI - Pretty color schemes, icons, opened tabs, file explorer, and file status integrated.

## Screenshots

<p align="center">
  <img alt="edit-markdown.png" src="https://raw.githubusercontent.com/linrongbin16/lin.vim.github.io/main/screen-snapshots/edit-markdown.png" width="100%">
  </br>
  <em style="fontsize:50%">Simple but pretty UI</em>
</p>

<p align="center">
  <img alt="python3-complete.png" src="https://raw.githubusercontent.com/linrongbin16/lin.vim.github.io/main/screen-snapshots/python-complete.png" width="100%">
  </br>
  <em style="fontsize:50%">Code complete for python3</em>
</p>

<p align="center">
  <img alt="outline-terminal.jpg" src="https://raw.githubusercontent.com/linrongbin16/lin.vim.github.io/main/screen-snapshots/outline-terminal.jpg" width="100%">
  </br>
  <em style="fontsize:50%">Outlines and Terminal</em>
</p>

<p align="center">
  <img alt="fast-cursor-movement.png" src="https://raw.githubusercontent.com/linrongbin16/lin.vim.github.io/main/screen-snapshots/fast-cursor-movement1.png" width="100%">
  </br>
  <em style="fontsize:50%">Fast cursor movement</em>
</p>

<p align="center">
  <img alt="search-text.png" src="https://raw.githubusercontent.com/linrongbin16/lin.vim.github.io/main/screen-snapshots/search-text.png" width="100%">
  </br>
  <em style="fontsize:50%">Search text</em>
</p>

<p align="center">
  <img alt="search-files.png" src="https://raw.githubusercontent.com/linrongbin16/lin.vim.github.io/main/screen-snapshots/search-files.png" width="100%">
  </br>
  <em style="fontsize:50%">Search files</em>
</p>

<p align="center">
  <img alt="markdown-preview.png" src="https://raw.githubusercontent.com/linrongbin16/lin.vim.github.io/main/screen-snapshots/markdown-preview1.png" width="100%">
  </br>
  <em style="fontsize:50%">Markdown preview</em>
</p>

### Feature

- One-line command installation (not on windows for now).
- Work on multiple OS platforms:
  - Windows.
  - macOS.
  - Linux (Ubuntu/Debian/Fedora/Manjaro).
- Modern editor UI:
  - File explorer.
  - Icons.
  - [Color schemes](#color-schemes) are selected randomly at the start.
  - Status line.
  - Tab line and buffer explorer.
  - Outline/Tags.
- IDE-like editing features supported by [nvim-cmp](https://github.com/hrsh7th/nvim-cmp):
  - Code complete.
  - Diagnostic.
  - Lint.
  - Code format.
  - Jump between symbols.
  - Code Actions.
- LSP servers manager supported by [mason.nvim](https://github.com/williamboman/mason.nvim), [a bunch of language servers](#embedded-language-servers) are embedded by default.
- Search engine supported by [fzf.vim](https://github.com/junegunn/fzf.vim):
  - Text search.
  - File search.
  - Git search.
  - Other search.
- Other [editing enhancements](#editing-enhancement).
- Custom configuration.

# Installation

## Requirement

Since neovim community is under active development, only the latest stable [neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim)]\(https://github.com/neovim/neovim/wiki/Installing-Neovim) is guaranteed supported.

## UNIX/Linux/macOS

```bash
    git clone https://github.com/linrongbin16/lin.nvim ~/.vim && cd ~/.vim && ./install.sh
```

Notice:

1.  The `install.sh` will automatically install below dependencies with system package manager:

    - [git](https://git-scm.com/).
    - [neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim).
    - [clang](https://clang.llvm.org/)(for macOS) or [gcc](https://gcc.gnu.org/)(for Linux), [make](https://www.gnu.org/software/make/), [pkg-config](https://www.freedesktop.org/wiki/Software/pkg-config/), [cmake](https://cmake.org/), [autoconf](https://www.gnu.org/software/autoconf/) and [automake](https://www.gnu.org/software/automake/).
    - [python3](https://www.python.org/) (python2 is not supported) and some pip packages.
    - [node.js](https://nodejs.org/) and some npm packages.
    - [golang](https://go.dev/).
    - [rust](https://www.rust-lang.org/) and some modern commands: [fd](https://github.com/sharkdp/fd), [rg](https://github.com/BurntSushi/ripgrep), [bat](https://github.com/sharkdp/bat), etc.
    - [curl](https://curl.se/), [wget](https://www.gnu.org/software/wget/), [unzip](https://linux.die.net/man/1/unzip) and [gzip](https://www.gnu.org/software/gzip/).
    - [universal-ctags](https://github.com/universal-ctags/ctags).
    - [hack nerd font](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Hack.zip).

2.  For now supported platforms are:
    - Debian/Ubuntu based Linux: use `apt` and `snap` as package installer.
    - Fedora/Centos based Linux: use `dnf` as package installer.
    - Archlinux based Linux: use `pacman` as package installer.
    - MacOS: use `brew` as package installer, please install [Xcode](https://guide.macports.org/chunked/installing.html) and [homebrew](https://brew.sh/) as pre-requirements.
    - Other \*NIX systems such as Gentoo, BSD are not supported yet.

## Windows

1.  Install [Visual Studio](https://www.visualstudio.com/) with below 2 components:

    - .NET Desktop Development
    - Desktop development with C++

<p align="center">
  <img alt="install-windows-visual-studio2.png" src="https://raw.githubusercontent.com/linrongbin16/lin.vim.github.io/main/screen-snapshots/install-windows-visual-studio2.png" width="100%">
  <em style="fontsize:50%">Select .NET and C++ components</em>
</p>

2.  Install [64-bit Git for Windows Setup](https://git-scm.com/downloads) with below 3 options:

    - In the **_Select Components_** step, select **_Associate .sh files to be run with Bash_**.
    - In the **_Adjusting your PATH environment_** step, select **_Use Git and optional Unix tools from the Command Prompt_**.
    - In the **_Configuring the terminal emulator to use with Git Bash_** step, select **_Use Windows's default console window_**. This will add `git.exe` and Linux built-in commands (such as `bash.exe`, `cp.exe`, `mv.exe`, `cd.exe`, `ls.exe`, etc) to `$env:PATH`.

<p align="center">
  <img alt="install-windows-git1.png" src="https://raw.githubusercontent.com/linrongbin16/lin.vim.github.io/main/screen-snapshots/install-windows-git1.png" width="65%">
  </br>
  <em style="fontsize:50%">Treat .sh files as bash script</em>
</p>
<p align="center">
  <img alt="install-windows-git2.png" src="https://raw.githubusercontent.com/linrongbin16/lin.vim.github.io/main/screen-snapshots/install-windows-git2.png" width="65%">
  </br>
  <em style="fontsize:50%">Enable both git and Linux built-in commands</em>
</p>
<p align="center">
  <img alt="install-windows-git3.png" src="https://raw.githubusercontent.com/linrongbin16/lin.vim.github.io/main/screen-snapshots/install-windows-git3.png" width="65%">
  </br>
  <em style="fontsize:50%">Add git and Linux commands to environment path</em>
</p>

3.  Install other 64-bit dependencies:

    - [neovim](https://github.com/neovim/neovim/releases/latest) (`nvim-win64.msi`): add `nvim.exe` to `$env:PATH`.
    - [cmake](https://github.com/Kitware/CMake/releases/latest) (`cmake-{x.y.z}-windows-x86_64.msi`): add `cmake.exe` to `$env:PATH`.
    - [make-for-win32](https://sourceforge.net/projects/gnuwin32/files/make/3.81/make-3.81-bin.zip/download) (`make-{x.y}-bin.zip`): add `make.exe`to`$env:PATH`.
    - [python3](https://www.python.org/downloads/windows/) (`python-{x.y.z}-amd64.exe`): manually copy `python.exe` to `python3.exe`, then add `python3.exe` to `$env:PATH` (Since windows python3 installer only provide `python.exe`).
    - [rust](https://www.rust-lang.org/tools/install) (`rustup-init.exe (64-bit)`): add `rustc.exe`, `cargo.exe` to `$env:PATH`.
    - [golang](https://go.dev/dl/) (`go{x.y.z}.windows-amd64.msi`): add `go.exe` to `$env:PATH`.
    - [nodejs](https://nodejs.org/en/download/) (`node-v{x.y.z}-x64.msi`): add `node.exe`, `npm.exe` to `$env:PATH`.
    - [7-zip](https://www.7-zip.org/): add `7z.exe` to `$env:PATH`.
    - [universal-ctags](https://github.com/universal-ctags/ctags-win32/releases) (`ctags-p{x.y.d.z}-x64.zip`): add `ctags.exe`, `readtags.exe` to `$env:PATH`.

4.  Install [Hack NFM](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Hack.zip).

5.  Run PowerShell commands as Administrator:

```powershell
    git clone https://github.com/linrongbin16/lin.nvim $env:UserProfile\.vim && cd $env:UserProfile\.vim && .\install.ps1
```

Notice:

1.  If you are using WSL, `C:\Windows\System32\bash.exe` could lead you to WSL instead of the `bash.exe` from [Git for Windows](https://git-scm.com/). Make sure the git path is ahead of `C:\Windows\System32`, so git bash will be first detected (`wsl.exe` could connect to WSL as well so no need to worry about losing `C:\Windows\System32\bash.exe`).

<p align="center">
  <img alt="install-windows-git-path.png" src="https://raw.githubusercontent.com/linrongbin16/lin.vim.github.io/main/screen-snapshots/install-windows-git-path.png" width="65%">
  </br>
  <em style="fontsize:50%">Move git path ahead of C:\Windows\System32</em>
</p>

2.  Disable Windows App alias `python.exe` or `python3.exe`, this could lead you to the wrong python from Windows Store.

<p align="center">
  <img alt="install-windows-app-alias.png" src="https://raw.githubusercontent.com/linrongbin16/lin.vim.github.io/main/screen-snapshots/install-windows-app-alias.png" width="65%">
  </br>
  <em style="fontsize:50%">Disable python.exe and python3.exe</em>
</p>

## More Options

The `install.sh` (and `install.ps1`) provide 3 installation modes:

- Full mode (default mode): with `./install.sh`, it installs all features for the best user experience, which consumes unignorable CPU, memory, disk and graphics.
- Limit mode: for low-performance devices (such as old PC). With `./install.sh --limit`, it disables extra highlights, color schemes, language support and editing enhancements.
- Basic mode: for extremely restricted environment (such as production environment), which has limited network access or user authentication. With `./install.sh --basic`, it only installs pure vim configurations, without any third-party software or vim plugins.

And more options:

- `--static-color=TEXT`: make color scheme static, instead of random selection on startup. For example: `--static-color=darkblue`.
- `--disable-color`: disable extra color schemes, and random selection on startup.
- `--disable-highlight`: disable extra highlights. Such as RGB and mark under cursor, etc.
- `--disable-language`: disable language support. Such as auto-complete and language servers, etc.
- `--disable-editing`: disable editing enhancements. Such as easy comments, cursor motion, etc.
- `--disable-plugin=TEXT`: disable specific vim plugin in format 'organization/repository', this is a multiple option. For example: `--disable-plugin=RRethy/vim-hexokinase --disable-plugin=alvan/vim-closetag`.

Notice:

- In full mode, you could use '--disable-xxx' options to disable some specific features.
- Option '--disable-highlight --disable-color --disable-language --disable-editing' is equivalent to '--limit'.

The `install.ps1` especially provides two more options for Windows:

- `--depends=TEXT`: download and install specific dependency in 3rd step of [windows installation](#windows). Use `--depends=all` to run for all dependencies. For example: `--depends=vim`, `--depends=universal-ctags`.
- `--nerdfont=TEXT`: download specific [nerd font](https://github.com/ryanoasis/nerd-fonts/releases/latest). For example: `--nerdfont=Hack`, `--nerdfont=SourceCodePro`.

> Use a package manager (such as [chocolatey](https://chocolatey.org/) and [scoop](https://scoop.sh/)) could be a better choice, just make sure they're available in `$env:PATH`.

## Upgrade

For distribution, please re-install by:

```bash
    cd ~/.vim
    git pull origin master
    ./install.sh
```

For vim plugins, please open (neo)vim and update by:

```vim
    :PlugUpdate!
```

# User Guide

In this section, vim editing modes are specified with:

- **🇳** - Normal mode.
- **🇻** - Visual mode.
- **🇮** - Insert mode.

Meta-key (`M`), alt-key (`A`) on Windows/Linux, and command-key (`D`) on macOS are collectively referred as:

- `M`

## Global Key Mappings

#### Hot Keys

- `F1` **🇳** - Toggle file explorer, see [Simple but pretty UI](#screenshots).
- `F2` **🇳** - Toggle undo-tree.
- `F3` **🇳** - Toggle outline/tags, see [Outlines and Terminal](#screenshots).
- `F4` **🇳** - Switch between C/C++ headers and sources.
- `F7` **🇳** - Toggle git blame info on current line.
- `F8` **🇳** - Open markdown preview.
- `F9` **🇳** - Toggle terminal.
- `F10` **🇳** - Toggle buffers explorer.

#### Control/Command+? Keys

Control+? keys are configured following most editors' behavior under windows:

- `<C-a>` **🇳** **🇻** **🇮** - Select all.
- `<C-c>` **🇳** **🇻** **🇮** - Copy to clipboard.
- `<C-x>` **🇳** **🇻** **🇮** - Cut to clipboard.
- `<C-v>` **🇳** **🇻** **🇮** - Paste from clipboard.
- `<C-s>` **🇳** **🇻** **🇮** - Save file.
- `<C-y>` **🇳** **🇻** **🇮** - Redo.
- `<C-z>` **🇳** **🇻** **🇮** - Undo.
- `<C-q>` **🇳** - Turn into visual block mode, same as vim's original _ctrl+v_ (since we remapped it to paste).

Additionally for macOS, command+? keys are configured following the same behavior (control+? keys are also enabled):

- `<D-a>` **🇳** **🇻** **🇮** - Same as `<C-a>`.
- `<D-c>` **🇳** **🇻** **🇮** - Same as `<C-c>`.
- `<D-x>` **🇳** **🇻** **🇮** - Same as `<C-x>`.
- `<D-v>` **🇳** **🇻** **🇮** - Same as `<C-v>`.
- `<D-s>` **🇳** **🇻** **🇮** - Same as `<C-s>`.
- `<D-y>` **🇳** **🇻** **🇮** - Same as `<C-y>`.
- `<D-z>` **🇳** **🇻** **🇮** - Same as `<C-z>`.

Copy/paste across different vim instances through remote ssh could be difficult, so introduce two shortcuts using local cache:

- `<Leader>y` **🇻** - Copy selected text to cache.
- `<Leader>p` **🇳** - Paste from cache to current cursor.

You could configure all global key mappings in _~/.vim/settings.vim_.

## UI

#### File Explorer

File explorer is supported by [nvim-tree.lua](https://github.com/kyazdani42/nvim-tree.lua). Please refer to [:help nvim-tree.view.mappings](https://github.com/nvim-tree/nvim-tree.lua/blob/master/doc/nvim-tree-lua.txt) for default key mappings. Only a few keys are added for more convenience:

Navigation:

- `h` **🇳** - Collapse directory.
- `l` **🇳** - Expand directory or open file.

Copy/paste/cut:

- `C` **🇳** - Copy file/directory into an internal clipboard, just like in Windows ctrl+c.
- `X` **🇳** - Cut file/directory into an internal clipboard, just like in Windows ctrl+x.
- `V` **🇳** - Paste file/directory from an internal clipboard to current directory, just like in Windows ctrl+v.

Adjust explorer width:

- `<M-.>`/`<M-Right>`/`<C-.>`/`<C-Right>` **🇳** - Make explorer bigger size.
- `<M-,>`/`<M-Left>`/`<C-,>`/`<C-Left>` **🇳** - Make explorer smaller size.

You could configure these key mappings in _~/.vim/repository/kyazdani42/nvim-tree.lua.vim_.

#### Tabline

Notice that on different platforms, terminals and GUI clients, some ctrl/meta+keys could be overwritten. So introduced several ways of mappings to make sure of the availability.

- `<Leader>bn`/`<M-.>`/`<C-.>`/`<M-Right>`/`<C-Right>` **🇳** - Go to next(right) buffer.
- `<Leader>bp`/`<M-,>`/`<C-,>`/`<M-Left>`/`<C-Left>` **🇳** - Go to previous(left) buffer.
- `<Leader>bd` **🇳** - Close current buffer without closing vim window.

Navigation:

- `<M-1>`/`<C-1>` **🇳** - Go to buffer-1.
- `<M-2>`/`<C-2>` **🇳** - Go to buffer-2.
- `<M-3>`/`<C-3>` **🇳** - Go to buffer-3.
- `<M-4>`/`<C-4>` **🇳** - Go to buffer-4.
- `<M-5>`/`<C-5>` **🇳** - Go to buffer-5.
- `<M-6>`/`<C-6>` **🇳** - Go to buffer-6.
- `<M-7>`/`<C-7>` **🇳** - Go to buffer-7.
- `<M-8>`/`<C-8>` **🇳** - Go to buffer-8.
- `<M-9>`/`<C-9>` **🇳** - Go to buffer-9.
- `<M-0>`/`<C-0>` **🇳** - Go to the last buffer.

Re-order:

- `<M-S-Right>`/`<C-S-Right>` **🇳** - Re-order(move) current buffer to next(right) position.
- `<M-S-Left>`/`<C-S-Left>` **🇳** - Re-order(move) current buffer to previous(left) position.

Mouse:

- `<LeftMouse>` **🇳** - Go to target buffer.
- `<MiddleMouse>` **🇳** - Close target buffer.

Support by [barbar.nvim](https://github.com/romgrk/barbar.nvim).

#### Font

By default [Hack Nerd Font Mono](https://github.com/ryanoasis/nerd-fonts/releases) is enabled. Please install other nerd fonts and edit _~/.vim/settings.vim_ to customize fonts.

## IDE-like Editing Features

#### Code Complete

- `<C-n>`/`<Down>` **🇮** - Navigate to next suggestion.
- `<C-p>`/`<Up>` **🇮** - Navigate to previous suggestion.
- `<TAB>`/`<CR>` **🇮** - Confirm current suggestion.
- `<ESC>`/`<C-[>` **🇮** - Close suggestion.
- `<C-f>` **🇮** - Navigate to next(right) snippet placeholder.
- `<C-b>` **🇮** - Navigate to previous(left) snippet placeholder.

#### Jumps

- `[d` **🇳** - Go to previous(up) diagnostic location.
- `]d` **🇳** - Go to next(down) diagnostic location.
- `gd` **🇳** - Go to definition.
- `gD` **🇳** - Go to declaration.
- `gt` **🇳** - Go to type definition.
- `gi` **🇳** - Go to implemention.
- `gr` **🇳** - Go to references.

#### Symbols

- `K` **🇳** - Show hover information.
- `<C-k>` **🇳** - Show signature help.
- `<Leader>rs` **🇳** - Rename symbol.

#### Code Format

- `<Leader>cf` **🇳** - Format code on whole buffer in normal mode.
- `<Leader>cf` **🇻** - Format selected code in visual mode.

#### Code Actions

- `<Leader>ca` **🇳** - Run code actions under cursor in normal mode.
- `<Leader>ca` **🇻** - Run code actions on selected code in visual mode.

#### Git

- `]c` **🇳** - Go to next(down) git chunk in current buffer.
- `[c` **🇳** - Go to previous(up) git chunk in current buffer.
- `<Leader>gb` **🇳** - Toggle git blame info for current line.

## LSP Servers Manager

By default, [a bunch of language servers](#embedded-language-servers) are already embedded. But sooner or later you need to manage these LSP servers yourself, the manager is supported by [mason.nvim](https://github.com/williamboman/mason.nvim).

To ensure LSP servers and formatters embedded, [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim), [null-ls.nvim](https://github.com/jose-elias-alvarez/null-ls.nvim) and [mason-null-ls.nvim](https://github.com/jay-babu/mason-null-ls.nvim) are introduced as well.

You could add new or configure embedded LSP servers in _~/.vim/lsp-settings.vim_.

### Search

Search engine is supported by [fzf.vim](https://github.com/junegunn/fzf.vim). All fzf commands are configured with the prefix **Fzf**, for example `:Files` are renamed to `:FzfFiles`, `:Rg` are renamed to `:FzfRg`.

#### Text Search

- `<Space>gr` **🇳** - Search text by self-defined command `:LinFzfRg`.
- `<Space>gw` **🇳** - Search word text under cursor by self-defined command `:LinFzfRgCWord`.
- `<Space>l` **🇳** - Search lines on opened buffers by `:FzfLines`.
- `<Space>t` **🇳** - Search tags by `:FzfTags`.
- `<Space>sh` **🇳** - Search searched history by `:FzfHistory/`.
- `<Space>ch` **🇳** - Search vim command history by `:FzfHistory:`.

#### File Search

- `<Space>f`/`<C-p>` **🇳** - Search files by `:FzfFiles`.
- `<Space>b` **🇳** - Search opened buffers by `:FzfBuffers`.
- `<Space>hf` **🇳** - Search history files (v:oldfiles) and opened buffers by `:FzfHistory`.

#### Git Search

- `<Space>gc` **🇳** - Search git commits by `:FzfCommits`.
- `<Space>gf` **🇳** - Search git files rby `:FzfGFile`.
- `<Space>gs` **🇳** - Search git status (also diff files by preview) by `:FzfGFiles?`.

#### Other Search

- `<Space>mk` **🇳** - Search marks by `:FzfMarks`.
- `<Space>mp` **🇳** - Search normal mode vim key mappings by `:FzfMaps`.
- `<Space>vc` **🇳** - Search vim commands by `:FzfCommands`.
- `<Space>ht` **🇳** - Search help tags by `:FzfHelptags`.

Please visit [fzf.vim](https://github.com/junegunn/fzf.vim) for more information.

## Editing Enhancement

#### Easy Comment

Line-wise comment:

- `gcc` **🇳** - Toggle current line.
- `[count]gcc` **🇳** - Toggle _\[count]_ number of lines.
- `gc{motion}` **🇳** - Toggle two lines with motion(jk).
- `gc[count]{motion}` **🇳** - Toggle region with _\[count]_(optional) times motion.
- `gc` **🇻** - Toggle selected region in virual mode.

Block-wise comment:

- `gbc` **🇳** - Toggle current line.
- `[count]gbc` **🇳** - Toggle _\[count]_ number of lines.
- `gb{motion}` **🇳** - Toggle two lines with motion.
- `gb[count]{motion}` **🇳** - Toggle region with _\[count]_(optional) times motion.
- `gb` **🇻** - Toggle selected region in virual mode.

Support by [Comment.nvim](https://github.com/numToStr/Comment.nvim).

#### Cursor Motion

See [Fast cursor movement](#screenshots).

- `<Leader>f{char}` **🇳** - Move by a single {char}.
- `<Leader>s{char}{char}` **🇳** - Move by two consequent {char}{char}.
- `<Leader>w` **🇳** - Move by word.
- `<Leader>l` **🇳** - Move by line.

Support by [hop.nvim](https://github.com/phaazon/hop.nvim).

#### Word Movement

(Neo)vim word movement cannot recognize the real literal word, such as camel case, mixed digits, characters, punctuations, etc.
So introduce better word motions:

- `<Leader>w`/`<Leader>W` **🇳** - word/WORD forward(right), exclusive.
- `<Leader>bb`/`<Leader>B` **🇳** - word/WORD backward(left), exclusive.
- `<Leader>e`/`<Leader>E` **🇳** - Forward to the end of word/WORD, inclusive.
- `<Leader>ge`/`<Leader>gE` **🇳** - Backward to the end of word/WORD, inclusive.

Support by [vim-wordmotion](https://github.com/chaoren/vim-wordmotion).

#### Better Repeat

Better repeat(`.`) operation, supported by [vim-repeat](https://github.com/tpope/vim-repeat).

#### Better Matching

Better matching includes HTML tags, if-endif, and other things, supported by [vim-matchup](https://github.com/andymass/vim-matchup).

#### Auto Pair and Close HTML Tag

Auto pair and close html tags, supported by [nvim-autopairs](https://github.com/windwp/nvim-autopairs) and [vim-closetag](https://github.com/alvan/vim-closetag).

## Customization

Please check neovim entry _~/.config/nvim/init.vim_ (_~/AppData/Local/nvim/init.vim_ on windows).
It load below components:

- Plugins (_~/.vim/plugins.vim_) - Vim plugins managed by [vim-plug](https://github.com/junegunn/vim-plug).
- Standalones (_~/.vim/standalone/\*.vim_) - Standalone vim settings.
- Repositories (_~/.vim/repository/{org}/{repo}.vim_) - Vim settings for each plugin.
- Colors (_~/.vim/color-settings.vim_) - Color scheme settings.
- Other settings (_~/.vim/settings.vim_) - Other settings GUI font, global key mappings, etc.

For basic install mode, there're only standalone vim settings, see [More Options](#more-options).

# Appendix

## Embedded Language Servers

- clangd: C/C++.
- cmake: CMake.
- cssls/cssmodules_ls: CSS.
- eslint: Javascript/Typescript.
- gopls: Go.
- grammarly: Article writing.
- graphql: GraphQL.
- html: HTML/XML.
- jsonls: JSON.
- tsserver: Javascript/Typescript/JavascriptReact/TypescriptReact.
- sumneko_lua: Lua.
- [marksman](https://github.com/artempyanykh/marksman): Markdown.
- pyright: Python3 (Python2 is not supported).
- rust_analyzer: Rust.
- sqlls: SQL.
- taplo: TOML.
- yamlls: YAML.
- vimls: Vim.

## Color Schemes

- [solarized](https://github.com/lifepillar/vim-solarized8)
- [monokai](https://github.com/crusoexia/vim-monokai)
- [dracula](https://github.com/dracula/vim)
- [neodark](https://github.com/KeitaNakamura/neodark.vim)
- [srcery](https://github.com/srcery-colors/srcery-vim)
- [palenight](https://github.com/drewtempelmeyer/palenight.vim)
- [onedark](https://github.com/joshdick/onedark.vim)
- [rigel](https://github.com/Rigellute/rigel)
- [edge](https://github.com/sainnhe/edge)
- [gruvbox-material](https://github.com/sainnhe/gruvbox-material)
- [everforest](https://github.com/sainnhe/everforest)
- [sonokai](https://github.com/sainnhe/sonokai)
- [material](https://github.com/kaicataldo/material.vim)
- [nightfox](https://github.com/EdenEast/nightfox.nvim)
- [github](https://github.com/projekt0n/github-nvim-theme)
- [tokyonight](https://github.com/folke/tokyonight.nvim)
- [kanagawa](https://github.com/rebelot/kanagawa.nvim)

# Contribute

Please open an issue/PR for anything about lin.nvim.

Like lin.nvim? Consider

<a href="https://www.buymeacoffee.com/linrongbin16" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>

Or

<p align="center">
  <img alt="wechat-pay.jpeg" src="https://raw.githubusercontent.com/linrongbin16/lin.vim.github.io/main/screen-snapshots/wechat-pay.jpeg" width="45%">
&nbsp; &nbsp; &nbsp; &nbsp;
  <img alt="alipay.jpeg" src="https://raw.githubusercontent.com/linrongbin16/lin.vim.github.io/main/screen-snapshots/alipay.jpeg" width="45%">
</p>
