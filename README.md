# lin.nvim : Lin Rongbin's Neovim Distribution

[![Neovim-v0.9.1](https://img.shields.io/badge/Neovim-v0.9.1-blueviolet.svg?style=flat-square&logo=Neovim&logoColor=green)](https://github.com/neovim/neovim/releases/tag/stable)
[![License](https://img.shields.io/github/license/linrongbin16/lin.nvim?style=flat-square&logo=GNU)](https://github.com/linrongbin16/lin.nvim/blob/main/LICENSE)
![Linux](https://img.shields.io/badge/Linux-%23.svg?style=flat-square&logo=linux&color=FCC624&logoColor=black)
![macOS](https://img.shields.io/badge/macOS-%23.svg?style=flat-square&logo=apple&color=000000&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-%23.svg?style=flat-square&logo=windows&color=0078D6&logoColor=white)

[![Top Language](https://img.shields.io/github/languages/top/linrongbin16/lin.nvim?style=flat-square)](https://github.com/linrongbin16/lin.nvim/search?l=lua)
![Repo Size](https://img.shields.io/github/repo-size/linrongbin16/lin.nvim?style=flat-square&)
[![Commit Activity](https://img.shields.io/github/commit-activity/m/linrongbin16/lin.nvim?style=flat-square)](https://github.com/linrongbin16/lin.nvim/graphs/commit-activity)
[![Last Commit](https://img.shields.io/github/last-commit/linrongbin16/lin.nvim/main)](https://github.com/linrongbin16/lin.nvim/commits/main)
[![Contributors](https://img.shields.io/github/contributors/linrongbin16/lin.nvim?style=flat-square)](https://github.com/linrongbin16/lin.nvim/graphs/contributors)

> Leave Vim behind, this is the next generation of [lin.vim](https://github.com/linrongbin16/lin.vim).

lin.nvim is a highly configured [Neovim](https://neovim.io/) distribution
integrated with tons of utilities for development, inspired by [spf13-vim](https://github.com/spf13/spf13-vim).

<p align="center">
  <img
    alt="start-ui.jpg"
    src="https://github.com/linrongbin16/lin.nvim/assets/6496887/41e72ef7-22ac-416d-aeef-9be9b720489c"
    width="100%"
  />
</p>

<!-- <img width="1728" alt="image" src="https://github.com/linrongbin16/lin.nvim/assets/6496887/41e72ef7-22ac-416d-aeef-9be9b720489c"> -->
<!-- ![image](https://github.com/linrongbin16/lin.nvim/assets/6496887/db296d82-b83a-4fe7-a05f-0e2263c43e9c) -->
<!-- ![image](https://github.com/linrongbin16/lin.nvim/assets/6496887/309f2399-65e6-4036-bcca-484424f1ab10) -->

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Get started](#get-started)
  - [MacOS/Linux](#macoslinux)
  - [Windows](#windows)
- [User guide](#user-guide)
  - [Patched GUI Font](#patched-gui-font)

## Introduction

Aim to be out-of-box, IDE-like editing experienced, performant, lightweight and
friendly to most Neovim users. Focus on and only on editing, no compiling/packaging/debugging.

The ultra config to solve these issues:

- Duplicate installation on different OS and machines? All done by one-line
  command (not on Windows for now), same behaviors on all platforms.
- Time-costing configurations? All configs follow community best practice, vim
  trandition and most popular editors (just like [vscode](https://code.visualstudio.com/)).
- Lack of IDE-like features (auto-complete, diagnostics, code-format,
  lint)? [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig),
  [nvim-cmp](https://github.com/hrsh7th/nvim-cmp),
  [mason.nvim](https://github.com/williamboman/mason.nvim),
  [null-ls.nvim](https://github.com/jose-elias-alvarez/null-ls.nvim) and a bunch of language extensions are embeded.
- Naive UI? - File explorer, git status, opened buffers,
  icons and most popular colorschemes integrated (again, just like vscode).
- More efficient? - Most popular editing improving plugins
  embeded, and well cooperated for best user experience and performance.

When maintaining this config, I always follow some [philosophy](https://github.com/linrongbin16/lin.nvim/wiki/Philosophy).

## Features

Please check out [Features](https://github.com/linrongbin16/lin.nvim/wiki/Features) & [Colorschemes](https://github.com/linrongbin16/lin.nvim/wiki/Colorschemes).

## Get started

### MacOS/Linux

```bash
git clone https://github.com/linrongbin16/lin.nvim ~/.config/nvim && cd ~/.config/nvim && ./install.sh
```

And that's all of it.

> Note: for macOS please install [Xcode](https://developer.apple.com/xcode/) as pre-requirements.

### Windows

1. Enable [Windows developer mode](https://learn.microsoft.com/en-us/windows/apps/get-started/enable-your-device-for-development#activate-developer-mode) for Windows.

2. Install [Visual Studio](https://www.visualstudio.com/) with MSVC components:

   - .NET Desktop Development
   - Desktop development with C++

   ![image](https://github.com/linrongbin16/lin.nvim/assets/6496887/bca811b5-8b1a-42c0-9283-c38e75f2f06a)

3. run PowerShell command:

   ```powershell
   # scoop
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   irm get.scoop.sh | iex

   git clone https://github.com/linrongbin16/lin.nvim $env:LOCALAPPDATA\nvim
   cd $env:LOCALAPPDATA\nvim
   .\install.ps1
   ```

For more details, please check out [Installation](https://github.com/linrongbin16/lin.nvim/wiki/Install,-Upgrade-&-Uninstall).

## User guide

### Patched GUI Font

Patched GUI font is mandatory for icons, the most popular patched fonts are
[nerd fonts](https://www.nerdfonts.com/) and [patched fonts for powerline](https://github.com/powerline/fonts).

Even `install.sh` (`install.ps1`) already installed the
[Hack Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/c173f661a0ed03bc537d31a79670bc03b586251d/patched-fonts/Hack),
you still need to manually config it in your terminal, e.g.
[gnome-terminal](https://help.gnome.org/users/gnome-terminal/stable/) (Ubuntu),
[item2](https://iterm2.com/) (MacOS),
[Windows Terminal](https://github.com/microsoft/terminal) (Windows 10),
[kitty](https://sw.kovidgoyal.net/kitty/),
[alacritty](https://github.com/alacritty/alacritty),
[wezterm](https://wezfurlong.org/wezterm/), etc.

Please check out
[User Guide](https://github.com/linrongbin16/lin.nvim/wiki/User-Guide) for full
features, key mappings and customizations.

## Contribute

Please open [issue](https://github.com/linrongbin16/lin.nvim/issues)/[PR](https://github.com/linrongbin16/lin.nvim/pulls) for anything about lin.nvim.

Like lin.nvim? Consider

[![Github Sponsor](https://img.shields.io/badge/-Sponsor%20Me%20on%20Github-magenta?logo=github&logoColor=white)](https://github.com/sponsors/linrongbin16)
[![Wechat Pay](https://img.shields.io/badge/-Tip%20Me%20on%20WeChat-brightgreen?logo=wechat&logoColor=white)](https://github.com/linrongbin16/lin.nvim/wiki/Sponsor)
[![Alipay](https://img.shields.io/badge/-Tip%20Me%20on%20Alipay-blue?logo=alipay&logoColor=white)](https://github.com/linrongbin16/lin.nvim/wiki/Sponsor)
