#Requires -RunAsAdministrator

# Debug
# Set-PSDebug -Trace 1

$VIM_HOME = "$env:USERPROFILE\.vim"
$APPDATA_LOCAL_HOME = "$env:USERPROFILE\AppData\Local"
$NVIM_HOME = "$APPDATA_LOCAL_HOME\nvim"
$INSTALL_HOME = "$VIM_HOME\installer"
$PACKER_HOME = "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim"

$MODE_NAME = "full" # default mode
$OPT_BASIC = $False

# utils

function Message([string]$content) {
    Write-Host "[lin.nvim] - $content"
}

function ErrorMessage([string] $content) {
    Message "error! $content"
}

function InstallOrSkip([string]$command, [string]$target) {
    if (Get-Command -Name $target -ErrorAction SilentlyContinue) {
        Message "'${target}' already exist, skip..."
    }
    else {
        Message "install '${target}' with command: '${command}'"
        Invoke-Expression $command
    }
}

# Test if symlink
function TestReparsePoint([string]$path) {
    $file = Get-Item $path -Force -ea SilentlyContinue
    return [bool]($file.Attributes -band [IO.FileAttributes]::ReparsePoint)
}

function TryBackup([string]$src) {
    if ((TestReparsePoint $src) -or (Test-Path $src)) {
        $now = Get-Date -Format "yyyy-MM-dd.HH-mm-ss.fffffff"
        $dest = -join ($src, ".", $now)
        Rename-Item $src $dest
        Message "backup '$src' to '$dest'"
    }
}

function RequiresAnArgumentError([string]$name) {
    ErrorMessage "option '$name' requires an argument."
    exit 1
}

function UnknownOptionError() {
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

function PackerDependency() {
    if (-not (Test-Path $PACKER_HOME)) {
	    Message "install 'packer.nvim' from github"
        git clone https://github.com/wbthomason/packer.nvim $PACKER_HOME
    } else {
	    Message "'packer.nvim' already exist, skip..."
    }
}

function CargoDependency() {
    Message "install modern rust commands with cargo"
    InstallOrSkip -command "cargo install ripgrep" -target "rg"
    InstallOrSkip -command "cargo install fd-find" -target "fd"
    # fzf preview syntax highlight
    InstallOrSkip -command "cargo install --locked bat" -target "bat"
}

function Pip3Dependency() {
    Message "install python packages with pip3"
    pip3 install pynvim click
}

function NpmDependency() {
    Message "install node packages with npm"
    npm install -g neovim
}

# basic

function InstallBasic() {
    $BasicPath = "$env:USERPROFILE\.vim\config\basic.vim"
    $NvimInitVimPath = "$NVIM_HOME\init.vim"
    Message "install $APPDATA_LOCAL_HOME\nvim\init.vim for neovim on windows"
    TryBackup $NvimInitVimPath
    TryBackup $NVIM_HOME
    cmd /c mklink $NVIM_HOME $VIM_HOME
    cmd /c mklink $NvimInitVimPath $BasicPath
}

function ShowHelp() {
    Get-Content -Path "$INSTALL_HOME\help.txt" | Write-Host
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

# parse options

$argsLength = $args.Length

for ($i = 0; $i -lt $argsLength; $i++) {
    $a = $args[ $i ];
    if ($a.StartsWith("-h") -or $a.StartsWith("--help")) {
        ShowHelp
        exit 0
    }
    elseif ($a.StartsWith("-b") -or $a.StartsWith("--basic")) {
        $MODE_NAME = "basic"
        $OPT_BASIC = $True
    }
    elseif ($a.StartsWith("-l") -or $a.StartsWith("--limit")) {
        $MODE_NAME = "limit"
    }
    elseif ($a.StartsWith("--static-color") -or $a.StartsWith("--disable-color") -or $a.StartsWith("--disable-highlight") -or $a.StartsWith("--disable-language") -or $a.StartsWith("--disable-editing") -or $a.StartsWith("--disable-ctrl-keys") -or $a.StartsWith("--disable-plugin")) {
        # Nothing here
    }
    else {
        UnknownOptionError
    }
}

Message "install with $MODE_NAME mode"

if ($OPT_BASIC) {
    InstallBasic
}
else {
    # dependency
    Message "install dependencies for windows"
    PackerDependency
    CargoDependency
    Pip3Dependency
    NpmDependency

    # vim settings
    Message "install settings for vim"
    python3 $VIM_HOME\generator.py $args
    if ($LastExitCode -ne 0) {
        exit 1
    }
    cmd /c nvim -E --headless -u "$VIM_HOME\template\init-tool.vim" -c 'autocmd User PackerComplete quitall' -c 'PackerSync' /wait
}

Message "install with $MODE_NAME mode - done"
