# Debug
# Set-PSDebug -Trace 1

$NVIM_HOME = "$env:LOCALAPPDATA\nvim"

# utils

function Message([string]$content)
{
    Write-Host "[lin.nvim] - $content"
}

function SkipMessage([string]$target)
{
    Message "'${target}' already exist, skip..."
}

function ErrorMessage([string] $content)
{
    Message "error! $content"
}

function InstallOrSkip([string]$command, [string]$target)
{
    if (Get-Command -Name $target -ErrorAction SilentlyContinue)
    {
        SkipMessage $target
    } else
    {
        Message "install '${target}' with command: '${command}'"
        Invoke-Expression $command
    }
}

# Test if symlink
function TestReparsePoint([string]$path)
{
    $file = Get-Item $path -Force -ea SilentlyContinue
    return [bool]($file.Attributes -band [IO.FileAttributes]::ReparsePoint)
}

function TryBackup([string]$src)
{
    if ((TestReparsePoint $src) -or (Test-Path $src))
    {
        $now = Get-Date -Format "yyyy-MM-dd.HH-mm-ss.fffffff"
        $dest = -join ($src, ".", $now)
        Rename-Item $src $dest
        Message "backup '$src' to '$dest'"
    }
}

# dependency

function CoreDependency()
{
    scoop bucket add extras
    scoop install mingw
    scoop install uutils-coreutils

    # neovim
    InstallOrSkip -command "scoop install neovim" -target "nvim"

    # shell
    InstallOrSkip -command "scoop install which" -target "which"
    InstallOrSkip -command "scoop install gawk" -target "awk"
    InstallOrSkip -command "scoop install sed" -target "sed"

    # c++ toolchain
    InstallOrSkip -command "scoop install llvm" -target "clang"
    InstallOrSkip -command "scoop install make" -target "make"
    InstallOrSkip -command "scoop install cmake" -target "cmake"

    # download tools
    InstallOrSkip -command "scoop install git" -target "git"
    InstallOrSkip -command "scoop install curl" -target "curl"
    InstallOrSkip -command "scoop install wget" -target "wget"

    # compress tools
    InstallOrSkip -command "scoop install 7zip" -target "7z"
    InstallOrSkip -command "scoop install gzip" -target "gzip"
    InstallOrSkip -command "scoop install unzip" -target "unzip"
    InstallOrSkip -command "scoop install unrar" -target "unrar"

    # luarocks
    InstallOrSkip -command "scoop install luarocks" -target "luarocks"

    # ctags
    InstallOrSkip -command "scoop install universal-ctags" -target "ctags"
}

function RustDependency()
{
    message 'install rust and modern commands'
    # rustc/cargo
    InstallOrSkip -command "scoop install rustup" -target "cargo"
    # modern commands
    InstallOrSkip -command "cargo install ripgrep" -target "rg"
    InstallOrSkip -command "cargo install fd-find" -target "fd"
    InstallOrSkip -command "cargo install --locked bat" -target "bat"
    InstallOrSkip -command "cargo install eza" -target "eza"
}

function GoDependency()
{
    message 'install go and modern commands'
    # go
    InstallOrSkip -command "scoop install go" -target "go"
    # commands
    InstallOrSkip -command "scoop install extras/lazygit" -target "lazygit"
}

function PythonDependency()
{
    Message "install python3 and pip3 packages"
    # python
    InstallOrSkip -command "scoop install python" -target "python3"
    InstallOrSkip -command "scoop install python" -target "pip3"
    python3 -m pip install pynvim --user --upgrade
}

function NodejsDependency()
{
    Message "install node and npm packages"
    # nodejs
    InstallOrSkip -command "scoop install nodejs-lts" -target "node"
    # npm
    npm install -g neovim
    InstallOrSkip -command "npm install -g trash-cli" -target "trash"
}

function NerdFontDependency()
{
    Message "install 'Hack' nerd font"
    scoop bucket add nerd-fonts
    scoop install Hack-NF
    scoop install Hack-NF-Mono
    Message "please set 'Hack NFM' (or 'Hack Nerd Font Mono') as your terminal font"
}

function NvimConfig()
{
    Message "install $NVIM_HOME for neovim on windows"
    TryBackup $env:USERPROFILE\.nvim
    Start-Process powershell "cmd /c mklink $env:USERPROFILE\.nvim $NVIM_HOME /D" -Verb RunAs -Wait

    # nvim-treesitter
    $NvimTreesitterHome = "$NVIM_HOME\lua\configs\nvim-treesitter\nvim-treesitter"
    $NvimTreesitterEnsureInstalled = "$NvimTreesitterHome\ensure_installed.lua"
    if (-not(TestReparsePoint $NvimTreesitterEnsureInstalled) -and -not(Test-Path $NvimTreesitterEnsureInstalled))
    {
        Copy-Item -Path "$NvimTreesitterHome\ensure_installed_sample.lua" -Destination "$NvimTreesitterEnsureInstalled"
    }

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

    # neoconf
    $Neoconf = "$NVIM_HOME\neoconf.json"
    if (-not(TestReparsePoint $Neoconf) -and -not(Test-Path $Neoconf))
    {
        Copy-Item -Path "$NVIM_HOME\neoconf_sample.json" -Destination "$Neoconf"
    }

    # install plugins on first start
    cmd /c nvim -E -c "Lazy! sync" -c "qall!" /wait
}

Message "install for Windows"

# dependency
Message "install dependencies with scoop"

CoreDependency
RustDependency
GoDependency
PythonDependency
NodejsDependency
NerdFontDependency
NvimConfig

Message "install for Windows - done"