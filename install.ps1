# Debug
# Set-PSDebug -Trace 1

$NVIM_HOME = "$env:USERPROFILE\.nvim"
$APPDATA_LOCAL_HOME = "$env:USERPROFILE\AppData\Local"
$APPDATA_LOCAL_NVIM_HOME = "$APPDATA_LOCAL_HOME\nvim"

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

    InstallOrSkip -command "scoop install llvm" -target "clang"
    InstallOrSkip -command "scoop install llvm" -target "clang++"
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
    python3 -m pip install pynvim --user --upgrade
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
    Start-Process powershell "npm install -g neovim" -Verb RunAs -Wait
    InstallOrSkip -command "Start-Process powershell 'npm install -g trash-cli' -Verb RunAs -Wait" -target "trash"
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
    Message "install $APPDATA_LOCAL_HOME\nvim for neovim on windows"
    TryBackup $APPDATA_LOCAL_NVIM_HOME
    cmd /c mklink $APPDATA_LOCAL_NVIM_HOME $NVIM_HOME /D
    cmd /c nvim -E -c "Lazy! sync" -c "qall!" /wait
}

Message "install for Windows"

# dependency
Message "install dependencies for Windows"

CoreDependency
RustDependency
GoDependency
PythonDependency
NodejsDependency
GuiFontDependency
NvimConfig

Message "install for Windows - done"