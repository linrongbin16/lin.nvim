# lin.nvim : Lin Rongbin's Neovim Distribution

<p>
<a href="https://github.com/neovim/neovim/releases/tag/stable"><img alt="Neovim-stable" src="https://img.shields.io/badge/require-stable-blue" /></a>
<a href="https://github.com/linrongbin16/lin.nvim/search?l=lua"><img alt="Language" src="https://img.shields.io/github/languages/top/linrongbin16/lin.nvim" /></a>
<a href="https://github.com/linrongbin16/lin.nvim/commits/main/"><img alt="CodeSize" src="https://img.shields.io/github/languages/code-size/linrongbin16/lin.nvim" /></a>
<a href="https://github.com/linrongbin16/lin.nvim/actions/workflows/ci.yml"><img alt="ci.yml" src="https://img.shields.io/github/actions/workflow/status/linrongbin16/lin.nvim/ci.yml?label=ci" /></a>
</p>

> Leave Vim behind, this is the next generation of [lin.vim](https://github.com/linrongbin16/lin.vim).

lin.nvim is a highly configured [Neovim](https://neovim.io/) distribution integrated with tons of utilities for development, inspired by [spf13-vim](https://github.com/spf13/spf13-vim).

<img width="70%" alt="image" src="https://github.com/linrongbin16/lin.nvim/assets/6496887/41e72ef7-22ac-416d-aeef-9be9b720489c"/>

## Introduction

Aim to be out-of-box, IDE-like editing experience, performant, lightweight and friendly to most Neovim users. Focus on and only on editing, no compiling/packaging/debugging.

This ultra config solves below issues:

- Duplicate installation on different OS and machines? - All done by one-line command (not on Windows for now), same behaviors on all platforms.
- Time-costing configurations? - All configs follow community best practice, vim tradition and most popular editors (just like [vscode](https://code.visualstudio.com/)).
- Lack of IDE-like features (auto-complete, diagnostics, code-format, lint)? - [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig), [nvim-cmp](https://github.com/hrsh7th/nvim-cmp), [mason.nvim](https://github.com/williamboman/mason.nvim), [none-ls.nvim](https://github.com/nvimtools/none-ls.nvim) and a bunch of language extensions are embedded.
- Naive UI? - File explorer, git status, tabs, icons and most popular colorschemes integrated (again, just like vscode).
- More efficient editing? - Most popular editing improving plugins embedded, and well cooperated for best user experience and performance.

Check out [features](/features.md) for what it can do, [colorschemes](/colorschemes.md) for pretty colorschemes and icons, the [philosophy](/philosophy.md) I follow when maintaining this distro.

## Get started

### MacOS/Linux

?> For Mac OS, please install [Xcode](https://developer.apple.com/xcode/) and [homebrew](https://brew.sh/) as pre-requirements.

```bash
git clone https://github.com/linrongbin16/lin.nvim ~/.nvim && cd ~/.nvim && ./install
```

And that's all of it.

### Windows

1. Enable [Windows developer mode](https://learn.microsoft.com/en-us/windows/apps/get-started/enable-your-device-for-development#activate-developer-mode).

2. Install [Visual Studio](https://www.visualstudio.com/) with MSVC components:

   - .NET Desktop Development
   - Desktop development with C++

   <img width="70%" alt="image" src="https://github.com/linrongbin16/lin.nvim/assets/6496887/bca811b5-8b1a-42c0-9283-c38e75f2f06a"/>

3. Run PowerShell command:

   ```powershell
   # scoop
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   irm get.scoop.sh | iex

   git clone https://github.com/linrongbin16/lin.nvim $env:USERPROFILE\.nvim
   cd $env:USERPROFILE\.nvim
   .\install.ps1
   ```

For more details, please check out [Installation](/install.md).

### Patched Font

Patched font is mandatory for displaying icons.

Even [Hack Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/c173f661a0ed03bc537d31a79670bc03b586251d/patched-fonts/Hack) is been installed during installation, you still need to manually config it in your terminal, such as [gnome-terminal](https://help.gnome.org/users/gnome-terminal/stable/) (Ubuntu), [item2](https://iterm2.com/) (MacOS), [Windows Terminal](https://github.com/microsoft/terminal) (Windows), [kitty](https://sw.kovidgoyal.net/kitty/), [alacritty](https://github.com/alacritty/alacritty), [wezterm](https://wezfurlong.org/wezterm/), etc.

## User guide

Check out [user guide](/user_guide.md) for full features, plugins, key mappings and customizations.

## Contribute

Please open [issue](https://github.com/linrongbin16/lin.nvim/issues)/[PR](https://github.com/linrongbin16/lin.nvim/pulls) for anything about lin.nvim.

Like lin.nvim? Consider

[![Github Sponsor](https://img.shields.io/badge/-Sponsor%20Me%20on%20Github-magenta?logo=github&logoColor=white)](https://github.com/sponsors/linrongbin16)
[![Wechat Pay](https://img.shields.io/badge/-Tip%20Me%20on%20WeChat-brightgreen?logo=wechat&logoColor=white)](/sponsor.md)
[![Alipay](https://img.shields.io/badge/-Tip%20Me%20on%20Alipay-blue?logo=alipay&logoColor=white)](/sponsor.md)
