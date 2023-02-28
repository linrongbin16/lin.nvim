#Requires -RunAsAdministrator

# Debug
# Set-PSDebug -Trace 1

$NVIM_HOME = "$env:USERPROFILE\.nvim"
$APPDATA_LOCAL_HOME = "$env:USERPROFILE\AppData\Local"
$APPDATA_LOCAL_NVIM_HOME = "$APPDATA_LOCAL_HOME\nvim"
$DEPS_HOME = "$NVIM_HOME\deps"

$OPT_WITH_OPT = $False

# utils

function Message([string]$content)
{
    Write-Host "[lin.nvim] - $content"
}

function ErrorMessage([string] $content)
{
    Message "error! $content"
}

function InstallOrSkip([string]$command, [string]$target)
{
    if (Get-Command -Name $target -ErrorAction SilentlyContinue)
    {
        Message "'${target}' already exist, skip..."
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

function UnknownOptionError()
{
    ErrorMessage "unknown option, please try --help for more information."
    exit 1
}

# function TryDelete([string]$src) {
#     if ((TestReparsePoint $src) -or (Test-Path $src)) {
#         (Get-Item $src).Delete()
#         Message "delete '$src'"
#     }
# }

# dependency

function CargoDependency()
{
    # if rustc/cargo exists, try using cargo install rust commands
    if ((Get-Command -Name 'rustc' -ErrorAction SilentlyContinue) -and (Get-Command -Name 'cargo' -ErrorAction SilentlyContinue)) {
        Message "install modern rust commands with cargo"
        InstallOrSkip -command "cargo install ripgrep" -target "rg"
        InstallOrSkip -command "cargo install fd-find" -target "fd"
        # fzf preview syntax highlight
        InstallOrSkip -command "cargo install --locked bat" -target "bat"
    }
}

function Pip3Dependency()
{
    Message "install python packages with pip3"
    python3 -m pip install pynvim
}

function NpmDependency()
{
    Message "install node packages with npm"
    npm install -g neovim
}

# basic

function InstallBasic()
{
    $basicVim = "$NVIM_HOME\conf\basic.vim"
    $initVim = "$APPDATA_LOCAL_NVIM_HOME\init.vim"
    Message "install $APPDATA_LOCAL_NVIM_HOME\init.vim for neovim on windows"
    TryBackup $initVim
    TryBackup $APPDATA_LOCAL_NVIM_HOME
    cmd /c mklink $APPDATA_LOCAL_NVIM_HOME $NVIM_HOME
    cmd /c mklink $initVim $basicVim
}

function ShowHelp()
{
    Get-Content -Path "$DEPS_HOME\help.txt" | Write-Host
}

# check arguments
$argsLength = $args.Length
for ($i = 0; $i -lt $argsLength; $i++)
{
    $a = $args[ $i ];
    if ($a.StartsWith("-h") -or $a.StartsWith("--help"))
    {
        ShowHelp
        exit 0
    }
    elseif ($a.StartsWith('--with-lsp'))
    {
        $OPT_WITH_OPT=$True
    }
    else
    {
        UnknownOptionError
    }
}

Message "install for windows"

# dependency
Message "install dependencies for windows"
CargoDependency
Pip3Dependency
NpmDependency

# with lsp servers
if ($OPT_WITH_OPT ) {
    Message "install language servers for nvim..."
    python3 $NVIM_HOME\generator.py $args
}
cmd /c nvim -E -c "Lazy! sync" -c "qall!" /wait

Message "install for windows - done"
