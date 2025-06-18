# Debug
# Set-PSDebug -Trace 1

$NVIM_HOME = "$env:USERPROFILE\.nvim"

# utils {

function Info([string]$content)
{
  Write-Host "[lin.nvim] - $content"
}

function Err([string] $content)
{
  Info "error! $content"
}

function SkipInfo([string]$target)
{
  Info "'${target}' already exist, skip..."
}

function Install([string]$command, [string]$target)
{
  if (Get-Command -Name $target -ErrorAction SilentlyContinue)
  {
    SkipInfo $target
  } else
  {
    Info "install '${target}' with command: '${command}'"
    Invoke-Expression $command
  }
}

# Test if symlink
function TestReparsePoint([string]$path)
{
  $file = Get-Item $path -Force -ea SilentlyContinue
  return [bool]($file.Attributes -band [IO.FileAttributes]::ReparsePoint)
}

function Backup([string]$src)
{
  if ((TestReparsePoint $src) -or (Test-Path $src))
  {
    $now = Get-Date -Format "yyyy-MM-dd.HH-mm-ss.fffffff"
    $dest = -join ($src, ".", $now)
    Rename-Item $src $dest
    Info "backup '$src' to '$dest'"
  }
}

# utils }

# dependencies {

function CoreDeps()
{
  scoop bucket add extras
  scoop install mingw
  scoop install uutils-coreutils

  # neovim
  Install -command "scoop install neovim" -target "nvim"

  # shell
  Install -command "scoop install which" -target "which"
  Install -command "scoop install gawk" -target "awk"
  Install -command "scoop install sed" -target "sed"

  # c++ toolchain
  Install -command "scoop install llvm" -target "clang"
  Install -command "scoop install make" -target "make"
  Install -command "scoop install cmake" -target "cmake"

  # download tools
  Install -command "scoop install git" -target "git"
  Install -command "scoop install curl" -target "curl"
  Install -command "scoop install wget" -target "wget"

  # compress tools
  Install -command "scoop install 7zip" -target "7z"
  Install -command "scoop install gzip" -target "gzip"
  Install -command "scoop install unzip" -target "unzip"

  # develop tools
  Install -command "scoop install lazygit" -target "lazygit"
  Install -command "scoop install fzf" -target "fzf"
}

function RustDeps()
{
  Info 'install rust and modern commands'
  # rustc/cargo
  Install -command "scoop install rustup" -target "cargo"
  Install -command "scoop install rustup" -target "rustc"
  # modern commands
  Install -command "cargo install ripgrep" -target "rg"
  Install -command "cargo install fd-find" -target "fd"
  Install -command "cargo install --locked bat" -target "bat"
  Install -command "cargo install eza" -target "eza"
}

function NpmDeps()
{
  Info "install node/npm packages"
  # nodejs
  Install -command "scoop install nodejs" -target "node"
  # npm
  npm install --silent -g neovim
  Install -command "npm install --silent -g trash-cli" -target "trash"
}

function NvimConfig()
{
  Info "install $env:LOCALAPPDATA\nvim\init.lua for neovim on windows"
  Backup $env:LOCALAPPDATA\nvim
  cmd /c mklink $env:LOCALAPPDATA\nvim $NVIM_HOME /D

  # nvim-lspconfig
  $NvimLspconfigHome = "$NVIM_HOME\lua\configs\neovim\nvim-lspconfig"
  $NvimLspconfigSetupHandlers = "$NvimLspconfigHome\setup_handlers.lua"
  if (-not(TestReparsePoint $NvimLspconfigSetupHandlers) -and -not(Test-Path $NvimLspconfigSetupHandlers))
  {
    Copy-Item -Path "$NvimLspconfigHome\setup_handlers_sample.lua" -Destination "$NvimLspconfigSetupHandlers"
  }

  # mason-null-ls.nvim
  $MasonNulllsHome = "$NVIM_HOME\lua\configs\jay-babu\mason-null-ls-nvim"
  $MasonNulllsSetupHandlers = "$MasonNulllsHome\setup_handlers.lua"
  if (-not(TestReparsePoint $MasonNulllsSetupHandlers) -and -not(Test-Path $MasonNulllsSetupHandlers))
  {
    Copy-Item -Path "$MasonNulllsHome\setup_handlers_sample.lua" -Destination "$MasonNulllsSetupHandlers"
  }

  # conform.nvim
  $ConformHome = "$NVIM_HOME\lua\configs\stevearc\conform-nvim"
  $ConformFormattersByFt = "$ConformHome\formatters_by_ft.lua"
  if (-not(TestReparsePoint $ConformFormattersByFt) -and -not(Test-Path $ConformFormattersByFt))
  {
    Copy-Item -Path "$ConformHome\formatters_by_ft_sample.lua" -Destination "$ConformFormattersByFt"
  }

  # # nvim-lint
  # $NvimLintHome="$NVIM_HOME\lua\configs\mfussenegger\nvim-lint"
  # $NvimLintLintersByFt="$NvimLintHome\linters_by_ft.lua"
  # if (-not(TestReparsePoint $NvimLintLintersByFt) -and -not(Test-Path $NvimLintLintersByFt))
  # {
  #     Copy-Item -Path "$NvimLintHome\linters_by_ft_sample.lua" -Destination "$NvimLintLintersByFt"
  # }
}

# dependencies }

Info "install for Windows"

# dependency
Info "install dependencies with scoop"

CoreDeps
RustDeps
NpmDeps
NvimConfig

Info "install for Windows - done"
