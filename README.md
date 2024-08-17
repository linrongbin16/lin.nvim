<!-- markdownlint-disable MD001 MD013 MD034 MD033 MD051 -->

# lin.nvim : Lin Rongbin's Neovim Distribution

<p>
<a href="https://github.com/neovim/neovim/releases/tag/stable"><img alt="Neovim-stable" src="https://img.shields.io/badge/require-stable-blue" /></a>
<a href="https://github.com/linrongbin16/lin.nvim/search?l=lua"><img alt="Language" src="https://img.shields.io/github/languages/top/linrongbin16/lin.nvim" /></a>
<a href="https://github.com/linrongbin16/lin.nvim/commits/main/"><img alt="CodeSize" src="https://img.shields.io/github/languages/code-size/linrongbin16/lin.nvim" /></a>
<a href="https://github.com/linrongbin16/lin.nvim/actions/workflows/ci.yml"><img alt="ci.yml" src="https://img.shields.io/github/actions/workflow/status/linrongbin16/lin.nvim/ci.yml?label=ci" /></a>
</p>

> Leave Vim behind, this is the next generation of [lin.vim](https://github.com/linrongbin16/lin.vim).

lin.nvim is a highly configured [Neovim](https://neovim.io/) distribution integrated with tons of utilities for development, inspired by [spf13-vim](https://github.com/spf13/spf13-vim).

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
- [Get started](#get-started)
  - [MacOS/Linux](#macoslinux)
  - [Windows](#windows)
  - [Patched GUI Font](#patched-gui-font)
- [User guide](#user-guide)

## Introduction

Aim to be out-of-box, IDE-like editing experience, performant, lightweight and friendly to most Neovim users. Focus on and only on editing, no compiling/packaging/debugging.

This ultra config solves below issues:

- Duplicate installation on different OS and machines? - All done by one-line command (not on Windows for now), same behaviors on all platforms.
- Time-costing configurations? - All configs follow community best practice, vim tradition and most popular editors (just like [vscode](https://code.visualstudio.com/)).
- Lack of IDE-like features (auto-complete, diagnostics, code-format, lint)? - [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig), [nvim-cmp](https://github.com/hrsh7th/nvim-cmp), [mason.nvim](https://github.com/williamboman/mason.nvim), [none-ls.nvim](https://github.com/nvimtools/none-ls.nvim) and a bunch of language extensions are embedded.
- Naive UI? - File explorer, git status, tabs, icons and most popular colorschemes integrated (again, just like vscode).
- More efficient editing? - Most popular editing improving plugins embedded, and well cooperated for best user experience and performance.

Check out [features](https://linrongbin16.github.io/lin.nvim/#/features) for what it can do, [colorschemes](https://linrongbin16.github.io/lin.nvim/#/colorschemes) for pretty colorschemes and icons, the [philosophy](https://linrongbin16.github.io/lin.nvim/#/philosophy) I follow when maintaining this distro.

## Get started

### MacOS/Linux

> [!NOTE]
>
> For MacOS please install [Xcode](https://developer.apple.com/xcode/) and [homebrew](https://brew.sh/) as pre-requirements.

```bash
git clone https://github.com/linrongbin16/lin.nvim ~/.nvim && cd ~/.nvim && ./install
```

And that's all of it.

### Windows

1. Enable [Windows developer mode](https://learn.microsoft.com/en-us/windows/apps/get-started/enable-your-device-for-development#activate-developer-mode) for Windows.

2. Install [Visual Studio](https://www.visualstudio.com/) with MSVC components:

   - .NET Desktop Development
   - Desktop development with C++

   ![image](https://github.com/linrongbin16/lin.nvim/assets/6496887/bca811b5-8b1a-42c0-9283-c38e75f2f06a)

3. Install [Python3](https://www.python.org/downloads/) only for current user.

   <details>
   <summary>Click here to see how to install python3 only for current user.</summary>

   - Select "Customize Installation", unselect "Use admin privileges when installing py.exe".

     <img width="70%" alt="image" src="https://github.com/user-attachments/assets/e8aa9163-459e-4741-8561-c46efc2efdb5"/>

   - Select all optional features without "for all users (requires admin privileges)".

     <img width="70%" alt="image" src="https://github.com/user-attachments/assets/648ec440-b0ec-4373-9c66-7bf32e48d899"/>

   - Unselect "Install Python 3.12 for all users", select "Add Python to environment variables" and "Precompile standard library", choose the install directory in your user directory (for example `C:\Users\linrongbin\opt\Python312`).

     <img width="70%" alt="image" src="https://github.com/user-attachments/assets/568773e3-be4b-4b19-b444-c4880437a521"/>

   - Disable "python.exe" and "python3.exe" app aliases for Windows 10+. Go to Windows "Settings" => "Apps" => "App execution aliases", unselect "python.exe" and "python3.exe".

     <img width="80%" alt="image" src="https://github.com/user-attachments/assets/e6e2422d-953d-44b5-8f5e-820e2f355680"/>

     <img width="80%" alt="image" src="https://github.com/user-attachments/assets/f78d4dc2-b167-4981-9fa0-598edf8af0d5"/>

     <img width="80%" alt="image" src="https://github.com/user-attachments/assets/17baf876-e072-49eb-bed2-4b2436d85ad1"/>

   </details>

4. Install [Node.js](https://nodejs.org/) only for current user.

   <details>
   <summary>Click here to see how to install node.js only for current user.</summary>

   - In "Destination Folder" step, choose the install directory in you user directory (for example `C:\Users\linrongbin\opt\nodejs\`).

     <img width="70%" alt="image" src="https://github.com/user-attachments/assets/abccc9b6-2b42-4679-a182-420554a6483b"/>

   </details>

5. Run PowerShell command:

   ```powershell
   # scoop
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   irm get.scoop.sh | iex

   git clone https://github.com/linrongbin16/lin.nvim $env:USERPROFILE\.nvim
   cd $env:USERPROFILE\.nvim
   .\install.ps1
   ```

Check out [installation](https://linrongbin16.github.io/lin.nvim/#/install) for more details.

### Patched Font

Patched font is mandatory for displaying icons.

Even [Hack Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/c173f661a0ed03bc537d31a79670bc03b586251d/patched-fonts/Hack) is been installed during installation, you still need to manually config it in your terminal, such as [gnome-terminal](https://help.gnome.org/users/gnome-terminal/stable/) (Ubuntu), [item2](https://iterm2.com/) (MacOS), [Windows Terminal](https://github.com/microsoft/terminal) (Windows), [kitty](https://sw.kovidgoyal.net/kitty/), [alacritty](https://github.com/alacritty/alacritty), [wezterm](https://wezfurlong.org/wezterm/), etc.

## User guide

Check out [user guide](https://linrongbin16.github.io/lin.nvim/#/user_guide) for full features, plugins, key mappings and customizations.

## Contribute

Please open [issue](https://github.com/linrongbin16/lin.nvim/issues)/[PR](https://github.com/linrongbin16/lin.nvim/pulls) for anything about lin.nvim.

Like lin.nvim? Consider

[![Github Sponsor](https://img.shields.io/badge/-Sponsor%20Me%20on%20Github-magenta?logo=github&logoColor=white)](https://github.com/sponsors/linrongbin16)
[![Wechat Pay](https://img.shields.io/badge/-Tip%20Me%20on%20WeChat-brightgreen?logo=wechat&logoColor=white)](https://linrongbin16.github.io/lin.nvim/#/sponsor?id=wechat-pay)
[![Alipay](https://img.shields.io/badge/-Tip%20Me%20on%20Alipay-blue?logo=alipay&logoColor=white)](https://linrongbin16.github.io/lin.nvim/#/sponsor?id=alipay)
