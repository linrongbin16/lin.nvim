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
    InstallOrSkip -command "scoop install neovim" -target "nvim"

    InstallOrSkip -command "scoop install which" -target "which"
    InstallOrSkip -command "scoop install gawk" -target "awk"
    InstallOrSkip -command "scoop install sed" -target "sed"

    InstallOrSkip -command "scoop install make" -target "make"
    InstallOrSkip -command "scoop install cmake" -target "cmake"

    InstallOrSkip -command "scoop install git" -target "git"
    InstallOrSkip -command "scoop install curl" -target "curl"
    InstallOrSkip -command "scoop install wget" -target "wget"

    InstallOrSkip -command "scoop install 7zip" -target "7z"
    InstallOrSkip -command "scoop install gzip" -target "gzip"
    InstallOrSkip -command "scoop install unzip" -target "unzip"
    InstallOrSkip -command "scoop install unrar" -target "unrar"

    # ctags
    InstallOrSkip -command "scoop install universal-ctags" -target "ctags"
}

function RustDependency()
{
    message 'install rust and modern commands'
    # rust
    InstallOrSkip -command "scoop install rustup" -target "cargo"
    # cargo
    InstallOrSkip -command "cargo install ripgrep" -target "rg"
    InstallOrSkip -command "cargo install fd-find" -target "fd"
    InstallOrSkip -command "cargo install --locked bat" -target "bat"
}

function GoDependency()
{
    message 'install go and modern commands'
    # go
    InstallOrSkip -command "scoop install go" -target "go"
    # commands
    InstallOrSkip -command "go install github.com/jesseduffield/lazygit@latest" -target "lazygit"
}

function PythonDependency()
{
    Message "install python3 and pip3 packages"
    # python
    InstallOrSkip -command "scoop install python" -target "python3"
    # pip
    # python3 -m pip install pynvim --user --upgrade
    # InstallOrSkip -command "python3 -m pip install pipx --user && python3 -m pipx ensurepath" -target "pipx"
    # $env:Path=(
    #     [System.Environment]::GetEnvironmentVariable("Path","Machine"),
    #     [System.Environment]::GetEnvironmentVariable("Path","User")
    # ) -match '.' -join ';'
    # pipx install trash-cli
    # pipx upgrade trash-cli
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

function GuiFontDependency()
{
    Message "install patched font 'Hack-NF'"
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
    # lsp management
    $MasonLspconfigHome = "$NVIM_HOME\lua\configs\williamboman\mason-lspconfig-nvim"
    $MasonLspconfigEnsureInstalled = "$MasonLspconfigHome\ensure_installed.lua"
    if (-not(TestReparsePoint $MasonLspconfigEnsureInstalled) -and -not(Test-Path $MasonLspconfigEnsureInstalled)) {
        Copy-Item -Path "$MasonLspconfigHome\ensure_installed_sample.lua" -Destination "$MasonLspconfigEnsureInstalled"
    }
    $MasonLspconfigSetupHandlers = "$MasonLspconfigHome\setup_handlers.lua"
    if (-not(TestReparsePoint $MasonLspconfigSetupHandlers) -and -not(Test-Path $MasonLspconfigSetupHandlers)) {
        Copy-Item -Path "$MasonLspconfigHome\setup_handlers_sample.lua" -Destination "$MasonLspconfigSetupHandlers"
    }
    $MasonNulllsHome = "$NVIM_HOME\lua\configs\jay-babu\mason-null-ls-nvim"
    $MasonNulllsEnsureInstalled = "$MasonNulllsHome\ensure_installed.lua"
    if (-not(TestReparsePoint $MasonNulllsEnsureInstalled) -and -not(Test-Path $MasonNulllsEnsureInstalled)) {
        Copy-Item -Path "$MasonNulllsHome\ensure_installed_sample.lua" -Destination "$MasonNulllsEnsureInstalled"
    }
    $MasonNulllsSetupHandlers = "$MasonNulllsHome\setup_handlers.lua"
    if (-not(TestReparsePoint $MasonNulllsSetupHandlers) -and -not(Test-Path $MasonNulllsSetupHandlers)) {
        Copy-Item -Path "$MasonNulllsHome\setup_handlers_sample.lua" -Destination "$MasonNulllsSetupHandlers"
    }
    $Neoconf = "$NVIM_HOME\neoconf.json"
    if (-not(TestReparsePoint $Neoconf) -and -not(Test-Path $Neoconf)) {
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
GuiFontDependency
NvimConfig

Message "install for Windows - done"