# lin.nvim : Lin Rongbin's Neovim Distribution

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
- More efficient? - Most popular improve editing plugins
  embeded, and well cooperated for best user experience and performance.

When maintaining this config, I always follow some [philosophy](https://github.com/linrongbin16/lin.nvim/wiki/Philosophy).

## Features

<details>
  <summary>Click to expand</summary>
  </br>

### Auto-complete

https://github.com/linrongbin16/lin.nvim/assets/6496887/511b2012-5b2f-4e00-a28b-52dcf1a81000

### Diagnostics

<img width="100%" alt="image" src="https://github.com/linrongbin16/lin.nvim/assets/6496887/899c0e25-6307-494a-9bcf-82028251a914">

### Global search (on both files and text)

https://github.com/linrongbin16/lin.nvim/assets/6496887/ac082f93-b60d-452a-a339-bad30a08bca0

### Outline structure and undotree

https://github.com/linrongbin16/lin.nvim/assets/6496887/0adf8628-ccba-4082-a4ca-12490fce26b1

### Float terminal

https://github.com/linrongbin16/lin.nvim/assets/6496887/ac1a98da-a56f-4396-a938-0c447f57f358

### Tabline/buffers

https://github.com/linrongbin16/lin.nvim/assets/6496887/7fbbb203-7591-4dc6-97b8-eaa21b2172ec

### Highlight words

https://github.com/linrongbin16/lin.nvim/assets/6496887/30d12964-ac78-41e8-bb56-2f6f00ae6831

### CSS color

<img width="100%" alt="image" src="https://github.com/linrongbin16/lin.nvim/assets/6496887/e0df23f8-efe1-44ca-b442-7c177f06cfad">

### Cursor motion

https://github.com/linrongbin16/lin.nvim/assets/6496887/abfc287c-3cda-463d-b329-cff82c9131a5

### Markdown preview

https://github.com/linrongbin16/lin.nvim/assets/6496887/bbad07d8-7971-4f5d-8977-c71a40a51097

</details>

## Get started

### MacOS/Linux

```bash
git clone https://github.com/linrongbin16/lin.nvim ~/.nvim && cd ~/.nvim && ./install.sh
```

And that's all of it.

> Note: macOS use `brew` as package installer, please install [Xcode](https://developer.apple.com/xcode/) and [homebrew](https://brew.sh/) as pre-requirements.

For more details, please check out [MacOS/Linux installation](https://github.com/linrongbin16/lin.nvim/wiki/Install,-Upgrade-&-Uninstall#macoslinux).

### Windows

Please check out [Windows installation](https://github.com/linrongbin16/lin.nvim/wiki/Install,-Upgrade-&-Uninstall#windows).

### User guide

Please check out [user guide](https://github.com/linrongbin16/lin.nvim/wiki/User-Guide).

## Contribute

Please open issue/PR for anything about lin.nvim.

Like lin.nvim? Consider

[![buymeacoffee](https://img.shields.io/badge/-Buy%20Me%20a%20Coffee-ff5f5f?logo=ko-fi&logoColor=white)](https://www.buymeacoffee.com/linrongbin16)
[![Wechat Pay](https://img.shields.io/badge/-Tip%20Me%20on%20WeChat-brightgreen?logo=wechat&logoColor=white)](https://linrongbin16.github.io/lin.nvim.dev/docs/sponsor)
[![Alipay](https://img.shields.io/badge/-Tip%20Me%20on%20Alipay-blue?logo=alipay&logoColor=white)](https://linrongbin16.github.io/lin.nvim.dev/docs/sponsor)
