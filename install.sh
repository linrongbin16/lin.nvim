#!/bin/bash

# debug
# set -x

NVIM_HOME=$HOME/.nvim
CONFIG_NVIM_HOME=$HOME/.config/nvim
DEPS_HOME=$NVIM_HOME/deps
OS="$(uname -s)"

MODE_NAME='full' # default mode
OPT_BASIC=0

source $DEPS_HOME/util.sh

# dependency

# vim-hexokinase has been replaced with nvim-colorizer.lua, so golang is no longer needed as a dependency.
# golang_dependency() {
# 	# https://github.com/kerolloz/go-installer
# 	install_or_skip "bash <(curl -sL https://git.io/go-installer)" "go"
# 	if [ -d $HOME/.go/bin ]; then
# 		export PATH=$HOME/.go/bin:$PATH
# 	fi
# }

pip3_dependency() {
    message "install python packages with pip3"
    sudo python3 -m pip install pynvim click
}

npm_dependency() {
    message "install node packages with npm"
    sudo npm install -g neovim
}

nerdfont_latest_release_tag() {
    local org="$1"
    local repo="$2"
    local uri="https://github.com/$org/$repo/releases/latest"
    curl -f -L $uri | grep "href=\"/$org/$repo/releases/tag" | grep -Eo 'href="/[a-zA-Z0-9#~.*,/!?=+&_%:-]*"' | head -n 1 | cut -d '"' -f2 | cut -d "/" -f6
}

guifont_dependency() {
    if [ "$OS" == "Darwin" ]; then
        message "install hack nerd font with brew"
        brew tap homebrew/cask-fonts
        brew install --cask font-hack-nerd-font
    else
        mkdir -p ~/.local/share/fonts && cd ~/.local/share/fonts
        local org="ryanoasis"
        local repo="nerd-fonts"
        local font_file=Hack.zip
        local font_version=$(nerdfont_latest_release_tag $org $repo)
        local font_url="https://github.com/$org/$repo/releases/download/$font_version/$font_file"
        message "install hack($font_version) nerd font from github"
        if [ -f $font_file ]; then
            rm $font_file
        fi
        curl -L $font_url -o $font_file
        if [ $? -ne 0 ]; then
            message "failed to download $font_file, skip..."
        else
            unzip -o $font_file
            message "install hack($font_version) nerd font from github - done"
        fi
    fi
}

# basic
install_basic() {
    message "install ~/.config/nvim/init.vim for neovim"
    try_backup $CONFIG_NVIM_HOME/init.vim
    try_backup $CONFIG_NVIM_HOME
    mkdir -p $HOME/.config
    ln -s $NVIM_HOME $CONFIG_NVIM_HOME
    ln -s $NVIM_HOME/conf/basic.vim $CONFIG_NVIM_HOME/init.vim
}

show_help() {
    cat $DEPS_HOME/help.txt
}

# parse options

requires_an_argument_error() {
    error_message "option '$a' requires an argument."
    exit 1
}

unknown_option_error() {
    error_message "unknown option, please try --help for more information."
    exit 1
}

# check arguments
args_length=$#
args=("$@")
for ((i = 0; i < args_length; i++)); do
    a="${args[i]}"
    case "$a" in
    -h | --help)
        show_help
        exit 0
        ;;
    -b | --basic)
        MODE_NAME='basic'
        OPT_BASIC=1
        ;;
    -l | --limit)
        MODE_NAME='limit'
        ;;
    --use-color* | --no-plug* | --no-hilight | --no-lang | --no-edit | --no-ctrl | --no-color)
        # nothing here
        ;;
    *)
        unknown_option_error
        ;;
    esac
done

message "install with $MODE_NAME mode"
if [ $OPT_BASIC -gt 0 ]; then
    install_basic
else
    # dependency
    case "$OS" in
    Linux)
        if [ -f "/etc/arch-release" ] || [ -f "/etc/artix-release" ]; then
            $DEPS_HOME/pacman.sh
        elif [ -f "/etc/fedora-release" ] || [ -f "/etc/redhat-release" ]; then
            $DEPS_HOME/dnf.sh
        elif [ -f "/etc/gentoo-release" ]; then
            $DEPS_HOME/emerge.sh
        else
            # assume apt
            $DEPS_HOME/apt.sh
        fi
        ;;
    FreeBSD)
        $DEPS_HOME/pkg.sh
        ;;
    NetBSD)
        $DEPS_HOME/pkgin.sh
        ;;
    OpenBSD)
        $DEPS_HOME/pkg_add.sh
        ;;
    Darwin)
        $DEPS_HOME/brew.sh
        ;;
    *)
        message "$OS is not supported, exit..."
        exit 1
        ;;
    esac
    pip3_dependency
    npm_dependency
    guifont_dependency

    # vim settings
    message "install settings for vim"
    python3 $NVIM_HOME/generator.py "$@"
    if [ $? -ne 0 ]; then
        exit 1
    fi
    nvim -E -u $NVIM_HOME/temp/init-tool.vim -c "Lazy! sync" -c "qall!"
fi
message "install with $MODE_NAME mode - done"
