# Debug
# Set-PSDebug -Trace 1

$NVIM_HOME = "$env:USERPROFILE\.nvim"

# utils

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

# dependency

function CoreDependency()
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

    # luarocks
    Install -command "scoop install luarocks" -target "luarocks"

    # ctags
    Install -command "scoop install universal-ctags" -target "ctags"

    # rust commands
    Install -command "scoop install fd" -target "fd"
    Install -command "scoop install ripgrep" -target "rg"
    Install -command "scoop install bat" -target "bat"
    Install -command "scoop install eza" -target "eza"

    # fzf
    Install -command "scoop install fzf" -target "fzf"
}

function RustDependency()
{
    Info 'install rust and modern commands'
    # rustc/cargo
    Install -command "scoop install rustup" -target "cargo"
    # modern commands
    Install -command "scoop install ripgrep" -target "rg"
    Install -command "scoop install fd" -target "fd"
    Install -command "scoop install bat" -target "bat"
    Install -command "scoop install eza" -target "eza"
}

function PythonDependency()
{
    Info "install python3 and pip3 packages"
    # python
    Install -command "scoop install python" -target "python3"
    Install -command "scoop install python" -target "pip3"

    # $PythonHasPep668 = python3 -c 'import sys; major=sys.version_info.major; minor=sys.version_info.minor; micro=sys.version_info.micro; r1=major >= 3 and minor > 11; r2=major >= 3 and minor == 11 and micro >= 1; print(1 if r1 or r2 else 0)'
    # if ($PythonHasPep668 -eq 1) {
    #     python3 -m pip install pynvim --user --break-system-packages
    # } else {
    python3 -m pip install pynvim --user
    # }
}

function NodejsDependency()
{
    Info "install node and npm packages"
    # nodejs
    Install -command "scoop install nodejs-lts" -target "node"
    # npm
    npm install --silent -g neovim
    Install -command "npm install --silent -g trash-cli" -target "trash"
}

function NerdFontDependency()
{
    Info "install 'Hack' nerd font"
    scoop bucket add nerd-fonts
    scoop install Hack-NF
    scoop install Hack-NF-Mono
    Info "please set 'Hack NFM' (or 'Hack Nerd Font Mono') as your terminal font"
}

function NvimConfig()
{
    Info "install $env:LOCALAPPDATA\nvim\init.lua for neovim on windows"
    Backup $env:LOCALAPPDATA\nvim
    Start-Process powershell "cmd /c mklink $env:LOCALAPPDATA\nvim $NVIM_HOME /D" -Verb RunAs -Wait

    # # nvim-treesitter
    # $NvimTreesitterHome = "$NVIM_HOME\lua\configs\nvim-treesitter\nvim-treesitter"
    # $NvimTreesitterEnsureInstalled = "$NvimTreesitterHome\ensure_installed.lua"
    # if (-not(TestReparsePoint $NvimTreesitterEnsureInstalled) -and -not(Test-Path $NvimTreesitterEnsureInstalled))
    # {
    #     Copy-Item -Path "$NvimTreesitterHome\ensure_installed_sample.lua" -Destination "$NvimTreesitterEnsureInstalled"
    # }

    # nvim-lspconfig
    $NvimLspconfigHome = "$NVIM_HOME\lua\configs\neovim\nvim-lspconfig"
    $NvimLspconfigSetupHandlers = "$NvimLspconfigHome\setup_handlers.lua"
    if (-not(TestReparsePoint $NvimLspconfigSetupHandlers) -and -not(Test-Path $NvimLspconfigSetupHandlers))
    {
        Copy-Item -Path "$NvimLspconfigHome\setup_handlers_sample.lua" -Destination "$NvimLspconfigSetupHandlers"
    }

    # mason-lspconfig.nvim
    $MasonLspconfigHome = "$NVIM_HOME\lua\configs\williamboman\mason-lspconfig-nvim"
    $MasonLspconfigEnsureInstalled = "$MasonLspconfigHome\ensure_installed.lua"
    if (-not(TestReparsePoint $MasonLspconfigEnsureInstalled) -and -not(Test-Path $MasonLspconfigEnsureInstalled))
    {
        Copy-Item -Path "$MasonLspconfigHome\ensure_installed_sample.lua" -Destination "$MasonLspconfigEnsureInstalled"
    }
    $MasonLspconfigSetupHandlers = "$MasonLspconfigHome\setup_handlers.lua"
    if (-not(TestReparsePoint $MasonLspconfigSetupHandlers) -and -not(Test-Path $MasonLspconfigSetupHandlers))
    {
        Copy-Item -Path "$MasonLspconfigHome\setup_handlers_sample.lua" -Destination "$MasonLspconfigSetupHandlers"
    }

    # mason-null-ls.nvim
    $MasonNulllsHome = "$NVIM_HOME\lua\configs\jay-babu\mason-null-ls-nvim"
    $MasonNulllsEnsureInstalled = "$MasonNulllsHome\ensure_installed.lua"
    if (-not(TestReparsePoint $MasonNulllsEnsureInstalled) -and -not(Test-Path $MasonNulllsEnsureInstalled))
    {
        Copy-Item -Path "$MasonNulllsHome\ensure_installed_sample.lua" -Destination "$MasonNulllsEnsureInstalled"
    }
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

Info "install for Windows"

# dependency
Info "install dependencies with scoop"

CoreDependency
RustDependency
PythonDependency
NodejsDependency
NerdFontDependency
NvimConfig

Info "install for Windows - done"
