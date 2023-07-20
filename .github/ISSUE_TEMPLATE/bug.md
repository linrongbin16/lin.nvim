---
name: Bug
about: Report bug for this project
title: ''
labels: bug
assignees: linrongbin16

---

# Description

Please describe the bug here.

# Platform

- OS : Windows 10, MacOS 13.4.2, Ubuntu 22.04 LTS (Linux), etc.
- Architecture: x86_64, apple m1 silicon chip arm64
- Neovim: v0.9.1 (latest stable).

# `:checkhealth`

```
==============================================================================
hop: require("hop.health").check()

Ensuring keys are unique ~
- OK Keys are unique

Checking for deprecated features ~
- OK All good

==============================================================================
lazy: require("lazy.health").check()

lazy.nvim ~
- OK Git installed
- OK no existing packages found by other package managers
- OK packer_compiled.lua not found

==============================================================================
mason: require("mason.health").check()

mason.nvim ~
- OK mason.nvim version v1.6.0
- OK PATH: prepend
- OK Providers: 
  mason.providers.registry-api
  mason.providers.client
- OK neovim version >= 0.7.0

mason.nvim [Registries] ~
- OK Registry `github.com/mason-org/mason-registry version: 2023-07-19-marked-liquid` is installed.

mason.nvim [Core utils] ~
- OK unzip: `UnZip 6.00 of 20 April 2009, by Info-ZIP.  Maintained by C. Spieler.  Send`
- OK wget: `GNU Wget 1.21.4 built on darwin22.4.0.`
- OK curl: `curl 8.1.2 (aarch64-apple-darwin22.4.0) libcurl/8.1.2 (SecureTransport) OpenSSL/3.1.1 zlib/1.2.11 brotli/1.0.9 zstd/1.5.5 libidn2/2.3.4 libssh2/1.11.0 nghttp2/1.55.1 librtmp/2.3`
- OK gzip: `Apple gzip 403.100.6`
- OK tar: `bsdtar 3.5.3 - libarchive 3.5.3 zlib/1.2.11 liblzma/5.0.5 bz2lib/1.0.8 `
- OK bash: `GNU bash, version 3.2.57(1)-release (arm64-apple-darwin22)`
- OK sh: `Ok`

mason.nvim [Languages] ~
- OK Ruby: `ruby 2.7.7p221 (2022-11-24 revision 168ec2b1e5) [arm64-darwin22]`
- WARNING Composer: not available
  - ADVICE:
    - spawn: composer failed with exit code - and signal -. composer is not executable
- WARNING PHP: not available
  - ADVICE:
    - spawn: php failed with exit code - and signal -. php is not executable
- OK luarocks: `/opt/homebrew/bin/luarocks 3.9.2`
- OK node: `v16.20.0`
- OK Go: `go version go1.20.5 darwin/amd64`
- OK npm: `8.19.4`
- WARNING julia: not available
  - ADVICE:
    - spawn: julia failed with exit code - and signal -. julia is not executable
- OK python: `Python 3.11.4`
- OK cargo: `cargo 1.69.0 (6e9a83356 2023-04-12)`
- OK java: `openjdk version "11.0.17" 2022-10-18 LTS`
- OK JAVA_HOME: `openjdk version "11.0.17" 2022-10-18 LTS`
- OK RubyGem: `3.1.6`
- OK javac: `javac 11.0.17`
- OK pip: `pip 23.0.1 from /opt/homebrew/lib/python3.11/site-packages/pip (python 3.11)`
- OK python venv: `Ok`

mason.nvim [GitHub] ~
- OK GitHub API rate limit. Used: 2. Remaining: 58. Limit: 60. Reset: Wed Jul 19 23:13:59 2023.
  Install and authenticate via gh-cli to increase rate limit.

==============================================================================
neoconf: require("neoconf.health").check()

neoconf.nvim ~
- OK **treesitter-nvim** is installed
- WARNING **TreeSitter jsonc** parser is not installed. Highlighting of jsonc files might be broken
- OK **neodev.nvim** is installed
- OK **lspconfig** is installed
- OK **lspconfig jsonls** is installed
- OK **lspconfig lua_ls** is installed

==============================================================================
null-ls: require("null-ls.health").check()

- OK vint: the command "vint" is executable.
- OK black: the command "black" is executable.
- OK prettier: the command "prettier" is executable.
- OK markdownlint: the command "markdownlint" is executable.
- OK markdownlint: the command "markdownlint" is executable.
- OK stylua: the command "stylua" is executable.

==============================================================================
nvim: require("nvim.health").check()

Configuration ~
- OK no issues found

Runtime ~
- OK $VIMRUNTIME: /opt/homebrew/Cellar/neovim/0.9.1/share/nvim/runtime

Performance ~
- OK Build type: Release

Remote Plugins ~
- OK Up to date

terminal ~
- key_backspace (kbs) terminfo entry: `key_backspace=^H`
- key_dc (kdch1) terminfo entry: `key_dc=\E[3~`
- $TERM_PROGRAM="iTerm.app"
- $COLORTERM="truecolor"

==============================================================================
nvim-treesitter: require("nvim-treesitter.health").check()

Installation ~
- OK `tree-sitter` found 0.20.8 (parser generator, only needed for :TSInstallFromGrammar)
- OK `node` found v16.20.0 (only needed for :TSInstallFromGrammar)
- OK `git` executable found.
- OK `cc` executable found. Selected from { vim.NIL, "cc", "gcc", "clang", "cl", "zig" }
  Version: Apple clang version 14.0.3 (clang-1403.0.22.14.1)
- OK Neovim was compiled with tree-sitter runtime ABI version 14 (required >=13). Parsers must be compatible with runtime ABI.

OS Info:
{
  machine = "arm64",
  release = "22.5.0",
  sysname = "Darwin",
  version = "Darwin Kernel Version 22.5.0: Thu Jun  8 22:22:20 PDT 2023; root:xnu-8796.121.3~7/RELEASE_ARM64_T6000"
} ~

Parser/Features         H L F I J
  - c                   ✓ ✓ ✓ ✓ ✓
  - html                ✓ ✓ ✓ ✓ ✓
  - java                ✓ ✓ ✓ ✓ ✓
  - javascript          ✓ ✓ ✓ ✓ ✓
  - json                ✓ ✓ ✓ ✓ .
  - kotlin              ✓ ✓ ✓ . ✓
  - lua                 ✓ ✓ ✓ ✓ ✓
  - markdown            ✓ . ✓ ✓ ✓
  - markdown_inline     ✓ . . . ✓
  - query               ✓ ✓ ✓ ✓ ✓
  - scala               ✓ ✓ ✓ . ✓
  - tsx                 ✓ ✓ ✓ ✓ ✓
  - typescript          ✓ ✓ ✓ ✓ ✓
  - vim                 ✓ ✓ ✓ . ✓
  - vimdoc              ✓ . . . ✓

  Legend: H[ighlight], L[ocals], F[olds], I[ndents], In[j]ections
         +) multiple parsers found, only one will be used
         x) errors found in the query, try to run :TSUpdate {lang} ~

==============================================================================
provider: health#provider#check

Clipboard (optional) ~
- OK Clipboard tool found: pbcopy

Python 3 provider (optional) ~
- `g:python3_host_prog` is not set.  Searching for python3 in the environment.
- Multiple python3 executables found.  Set `g:python3_host_prog` to avoid surprises.
- Executable: /opt/homebrew/bin/python3
- Other python executable: /usr/bin/python3
- Python version: 3.11.4
- pynvim version: 0.4.3
- OK Latest pynvim is installed.
```

# Screenshot

Upload the screenshot which contains the error message.

# `~/.config/nvim` Zip

Upload your `~/.config/nvim` folder (archive via zip).
