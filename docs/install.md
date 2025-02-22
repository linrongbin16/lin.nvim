# Install, Uninstall & Update

## Support Platforms

- Windows: use [scoop](https://scoop.sh/) as package manager.
- MacOS: use [homebrew](https://brew.sh/) as package manager, please install [Xcode](https://developer.apple.com/xcode/) as pre-requirements.
- Debian/Ubuntu based Linux: use `apt` as package manager. Note: Windows WSL2 will also be detected as Ubuntu.
- Fedora/Centos based Linux: use `dnf` as package manager.
- ArchLinux based Linux: use `pacman` as package manager.
- Other \*NIX such as gentoo, bsd are not supported yet.

### Third-Party Dependencies

`install` (`install.ps1`) script installs below dependencies with package manager, only when they don't exist.

- [Git](https://git-scm.com/).
- [Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim).
- Programming languages:
  - C/C++ toolchain: [clang](https://clang.llvm.org/)/[gcc](https://gcc.gnu.org/), [make](https://www.gnu.org/software/make/), [pkg-config](https://www.freedesktop.org/wiki/Software/pkg-config/), [autoconf](https://www.gnu.org/software/autoconf/), [automake](https://www.gnu.org/software/automake/) and [cmake](https://cmake.org/).
  - [Rust](https://www.rust-lang.org/) and modern commands: [rg](https://github.com/BurntSushi/ripgrep), [fd](https://github.com/sharkdp/fd), [bat](https://github.com/sharkdp/bat), [eza](https://github.com/eza-community/eza).
  - [Python3](https://www.python.org/) and pip packages: [pynvim](https://github.com/neovim/pynvim).
  - [Node.js](https://nodejs.org/) and npm packages: [neovim](https://github.com/neovim/node-client), [trash-cli](https://github.com/sindresorhus/trash).
- Download tools: [curl](https://curl.se/), [wget](https://www.gnu.org/software/wget/).
- Decompression tools: [unzip](https://linux.die.net/man/1/unzip), [gzip](https://www.gnu.org/software/gzip/), [7-zip](https://www.7-zip.org/).
<!-- - Tags: [universal-ctags](https://github.com/universal-ctags/ctags). -->
- Patched-fonts: [hack nerd font](https://github.com/ryanoasis/nerd-fonts/releases/latest).

## Installation

### MacOS/Linux

!> For macOS please install [Xcode](https://developer.apple.com/xcode/) and [homebrew](https://brew.sh/) as pre-requirements.

```bash
git clone https://github.com/linrongbin16/lin.nvim ~/.nvim && cd ~/.nvim && ./install
```

And that's all of it.

### Windows

#### Install MSVC

!> Please choose x86_64 (e.g. 64 bit) for all below dependencies.

- [Enable developer mode](https://learn.microsoft.com/en-us/windows/apps/get-started/enable-your-device-for-development#activate-developer-mode).
- Install [Visual Studio](https://www.visualstudio.com/) with MSVC components:

  - .NET Desktop Development
  - Desktop development with C++

  ![image](https://github.com/linrongbin16/lin.nvim/assets/6496887/bca811b5-8b1a-42c0-9283-c38e75f2f06a)

#### Install [7-zip](https://www.7-zip.org/)

#### Install [Python 3](https://www.python.org/downloads/)

<details>
<summary>Click here to see how to install python3 only for current user.</summary>

- Select "Customize Installation", unselect "Use admin privileges when installing py.exe".

  <img width="70%" alt="image" src="https://github.com/user-attachments/assets/e8aa9163-459e-4741-8561-c46efc2efdb5"/>

- Select all optional features without "for all users (requires admin privileges)".

  <img width="70%" alt="image" src="https://github.com/user-attachments/assets/648ec440-b0ec-4373-9c66-7bf32e48d899"/>

- Unselect "Install Python 3.12 for all users", select "Add Python to environment variables" and "Precompile standard library", choose the install directory in your user directory (for example `C:\Users\linrongbin\opt\Python312`).

  <img width="70%" alt="image" src="https://github.com/user-attachments/assets/568773e3-be4b-4b19-b444-c4880437a521"/>

- Go to the install directory (`C:\Users\linrongbin\opt\Python312`) and copy `python.exe` to `python3.exe`, and you will have `python3.exe` command in Windows PowerShell/cmd.

- Disable "python.exe" and "python3.exe" app aliases for Windows 10+. Go to Windows "Settings" => "Apps" => "App execution aliases", unselect "python.exe" and "python3.exe".

  <img width="80%" alt="image" src="https://github.com/user-attachments/assets/e6e2422d-953d-44b5-8f5e-820e2f355680"/>

  <img width="80%" alt="image" src="https://github.com/user-attachments/assets/f78d4dc2-b167-4981-9fa0-598edf8af0d5"/>

  <img width="80%" alt="image" src="https://github.com/user-attachments/assets/17baf876-e072-49eb-bed2-4b2436d85ad1"/>

</details>

#### Install [Node.js](https://nodejs.org/)

<details>
<summary>Click here to see how to install node only for current user.</summary>

- In "Destination Folder", choose the install directory in you user directory (for example `C:\Users\linrongbin\opt\nodejs\`).

  <img width="70%" alt="image" src="https://github.com/user-attachments/assets/abccc9b6-2b42-4679-a182-420554a6483b"/>

</details>

#### Run PowerShell

Run below PowerShell commands:

```powershell
# scoop
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex

git clone https://github.com/linrongbin16/lin.nvim $env:USERPROFILE\.nvim
cd $env:USERPROFILE\.nvim
.\install.ps1
```

## Upgrade

1. Pull latest origin main and re-install.

   - For MacOS/Linux

     ```bash
     rm -rf ~/.nvim/lazy && rm -rf ~/.nvim/mason
     cd ~/.nvim && git pull origin main && ./install
     ```

   - For Windows

     ```powershell
     rm $env:USERPROFILE\.nvim\lazy
     rm $env:USERPROFILE\.nvim\mason
     cd $env:USERPROFILE\.nvim
     git pull origin main
     .\install.ps1
     ```

2. Open Neovim and upgrade plugins.

   ```vim
   :Lazy update
   ```

## Uninstall

Remove below directories:

- For MacOS/Linux

  - `~/.nvim`
  - `~/.config/nvim`
  - `~/.local/share/nvim`

- For Windows

  - `$env:USERPROFILE\.nvim`
  - `$env:LOCALAPPDATA\nvim` (or check the output of `:lua print(vim.fn.stdpath('config'))` in Neovim).
  - `$env:LOCALAPPDATA\nvim-data` (or check the output of `:lua print(vim.fn.stdpath('data'))` in Neovim).
