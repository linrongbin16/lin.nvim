#!/bin/bash

# debug
# set -x

NVIM_HOME=$HOME/.nvim
CONFIG_NVIM_HOME=$HOME/.config/nvim
DEPS_HOME=$NVIM_HOME/deps
OS="$(uname -s)"

OPT_WITH_LSP=0

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

rust_dependency() {
    message "install rustc/cargo"
    install_or_skip "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y" "rustc"
    install_or_skip "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y" "cargo"
    message 'install modern rust commands with cargo'
    install_or_skip "cargo install fd-find" "fd"
    install_or_skip "cargo install ripgrep" "rg"
    install_or_skip "cargo install --locked bat" "bat"
    install_or_skip "cargo install git-delta" "delta"
}

pip3_dependency() {
    message "install python packages with pip3"
    sudo python3 -m pip install pynvim
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

nvim_config() {
    message "install ~/.config/nvim/init.vim for neovim"
    try_backup $CONFIG_NVIM_HOME
    mkdir -p $HOME/.config
    ln -s $NVIM_HOME $CONFIG_NVIM_HOME
    nvim -E -c "Lazy! sync" -c "qall!"
}

# parse options
# show_help() {
#     cat $DEPS_HOME/help.txt
# }
#
# unknown_option_error() {
#     error_message "unknown option, please try --help for more information."
#     exit 1
# }

# check arguments
# args_length=$#
# args=("$@")
# for ((i = 0; i < args_length; i++)); do
#     a="${args[i]}"
#     case "$a" in
#     -h | --help)
#         show_help
#         exit 0
#         ;;
#     --with-lsp)
#         OPT_WITH_LSP=1
#         ;;
#     *)
#         unknown_option_error
#         ;;
#     esac
# done

message "install for $OS"

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

rust_dependency
pip3_dependency
npm_dependency
guifont_dependency
nvim_config

message "install for $OS - done"