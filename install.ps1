#Requires -RunAsAdministrator

# Debug
# Set-PSDebug -Trace 1

$NVIM_HOME = "$env:USERPROFILE\.nvim"
$APPDATA_LOCAL_HOME = "$env:USERPROFILE\AppData\Local"
$APPDATA_LOCAL_NVIM_HOME = "$APPDATA_LOCAL_HOME\nvim"
$DEPS_HOME = "$NVIM_HOME\deps"

$MODE_NAME = "full" # default mode
$OPT_BASIC = $False

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

function RequiresAnArgumentError([string]$name)
{
    ErrorMessage "option '$name' requires an argument."
    exit 1
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
    Message "install modern rust commands with cargo"
    InstallOrSkip -command "cargo install ripgrep" -target "rg"
    InstallOrSkip -command "cargo install fd-find" -target "fd"
    # fzf preview syntax highlight
    InstallOrSkip -command "cargo install --locked bat" -target "bat"
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

# # Get the ID and security principal of the current user account
# $currentID = [System.Security.Principal.WindowsIdentity]::GetCurrent();
# $currentPrincipal = New-Object System.Security.Principal.WindowsPrincipal($currentID);
# # Get the security principal for the administrator role
# $adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator;
#
# # If we are not running as an administrator, relaunch as administrator
# if (!($currentPrincipal.IsInRole($adminRole)))
# {
#     # Create a new process that run as administrator
#     $installer=$script:MyInvocation.MyCommand.Path
#     Start-Process powershell "& '$installer' $args" -Verb RunAs
#
#     # Exit from the current process
#     Exit;
# }

# check arguments
$argsLength = $args.Length
for ($i = 0; $i -lt $argsLength; $i++)
{
    $a = $args[ $i ];
    if ($a.StartsWith("-h") -or $a.StartsWith("--help"))
    {
        ShowHelp
        exit 0
    } elseif ($a.StartsWith("-b") -or $a.StartsWith("--basic"))
    {
        $MODE_NAME = "basic"
        $OPT_BASIC = $True
    } elseif ($a.StartsWith("-l") -or $a.StartsWith("--limit"))
    {
        $MODE_NAME = "limit"
    } elseif ($a.StartsWith("--use-color") -or $a.StartsWith("--no-color") -or $a.StartsWith("--no-hilight") -or $a.StartsWith("--no-lang") -or $a.StartsWith("--no-edit") -or $a.StartsWith("--no-ctrl") -or $a.StartsWith("--no-plug") -or $a.StartsWith('--with-lsp'))
    {
        # Nothing here
    } else
    {
        UnknownOptionError
    }
}

Message "install with $MODE_NAME mode"

if ($OPT_BASIC)
{
    InstallBasic
} else
{
    # dependency
    Message "install dependencies for windows"
    CargoDependency
    Pip3Dependency
    NpmDependency

    # vim settings
    Message "install settings for vim"
    python3 $NVIM_HOME\generator.py $args
    if ($LastExitCode -ne 0)
    {
        exit 1
    }
    cmd /c nvim -E -u "$NVIM_HOME\temp\init-tool.vim" -c "Lazy! sync" -c "qall!" /wait
}

Message "install with $MODE_NAME mode - done"
