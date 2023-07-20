#!/bin/bash

# debug
# set -x

NVIM_HOME=$HOME/.config/nvim
DEPS_HOME=$NVIM_HOME/deps
OS="$(uname -s)"

source $DEPS_HOME/util.sh

# dependency

golang_dependency() {
    message "install go and modern commands"
    # https://github.com/canha/golang-tools-install-script
    cd $NVIM_HOME
    if [ ! -d golang-tools-install-script ]; then
        git clone --depth=1 https://github.com/canha/golang-tools-install-script
    fi
    install_or_skip "cd golang-tools-install-script && bash ./goinstall.sh" "go"
    cd $NVIM_HOME
    export PATH="$HOME/go/bin:$HOME/.go/bin:$PATH"
    install_or_skip "go install github.com/jesseduffield/lazygit@latest" "lazygit"
}

rust_dependency() {
    message "install rust and modern commands"
    install_or_skip "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y" "cargo"
    . "$HOME/.cargo/env"
    message 'install modern rust commands with cargo'
    install_or_skip "cargo install fd-find" "fd"
    install_or_skip "cargo install ripgrep" "rg"
    install_or_skip "cargo install --locked bat" "bat"
}

pip3_dependency() {
    message "install python packages with pip3"
    # python3 -m pip install pynvim --user --upgrade
    # install_or_skip "python3 -m pip install pipx --user && python3 -m pipx ensurepath" "pipx"
    # export PATH="$PATH:$HOME/.local/bin"
    # install_or_skip "pipx install trash-cli" "trash-put"
}

npm_dependency() {
    message "install node packages with npm"
    sudo npm install -g neovim
    install_or_skip "sudo npm install -g trash-cli" "trash"
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
        sudo fc-cache -fv
    fi
}

nvim_config() {
    message "install ~/.config/nvim/init.vim for neovim"
    mkdir -p $HOME/.config
    try_backup $HOME/.nvim
    ln -s $NVIM_HOME $HOME/.nvim
    # lsp management
    local mason_lspconfig_home="$NVIM_HOME/lua/configs/williamboman/mason-lspconfig-nvim"
    local mason_lspconfig_ensure_installed="$mason_lspconfig_home/ensure_installed.lua"
    if [ ! -f $mason_lspconfig_ensure_installed ]; then
        cp $mason_lspconfig_home/ensure_installed_sample.lua $mason_lspconfig_ensure_installed
    fi
    local mason_lspconfig_setup_handlers="$mason_lspconfig_home/setup_handlers.lua"
    if [ ! -f $mason_lspconfig_setup_handlers ]; then
        cp $mason_lspconfig_home/setup_handlers_sample.lua $mason_lspconfig_setup_handlers
    fi
    local mason_null_ls_home="$NVIM_HOME/lua/configs/jay-babu/mason-null-ls-nvim"
    local mason_null_ls_ensure_installed="$mason_null_ls_home/ensure_installed.lua"
    if [ ! -f $mason_null_ls_ensure_installed ]; then
        cp $mason_null_ls_home/ensure_installed_sample.lua $mason_null_ls_ensure_installed
    fi
    local mason_null_ls_setup_handlers="$mason_null_ls_home/setup_handlers.lua"
    if [ ! -f $mason_null_ls_setup_handlers ]; then
        cp $mason_null_ls_home/setup_handlers_sample.lua $mason_null_ls_setup_handlers
    fi
    local neoconf="$NVIM_HOME/neoconf.json"
    if [ ! -f $neoconf ]; then
        cp $NVIM_HOME/neoconf_sample.json $neoconf
    fi
    # install plugins on first start
    nvim -E -c "Lazy! sync" -c "qall!"
}

message "install for $OS"

# dependency
case "$OS" in
Linux)
    if [ -f "/etc/arch-release" ] || [ -f "/etc/artix-release" ]; then
        $DEPS_HOME/pacman.sh $DEPS_HOME
    elif [ -f "/etc/fedora-release" ] || [ -f "/etc/redhat-release" ]; then
        $DEPS_HOME/dnf.sh $DEPS_HOME
    elif [ -f "/etc/gentoo-release" ]; then
        $DEPS_HOME/emerge.sh $DEPS_HOME
    else
        # assume apt
        $DEPS_HOME/apt.sh $DEPS_HOME
    fi
    ;;
FreeBSD)
    $DEPS_HOME/pkg.sh $DEPS_HOME
    ;;
NetBSD)
    $DEPS_HOME/pkgin.sh $DEPS_HOME
    ;;
OpenBSD)
    $DEPS_HOME/pkg_add.sh $DEPS_HOME
    ;;
Darwin)
    $DEPS_HOME/brew.sh $DEPS_HOME
    ;;
*)
    message "$OS is not supported, exit..."
    exit 1
    ;;
esac

rust_dependency
golang_dependency
pip3_dependency
npm_dependency
guifont_dependency
nvim_config

message "install for $OS - done"