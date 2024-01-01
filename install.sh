#!/bin/bash

# debug
set -x

NVIM_HOME=$HOME/.config/nvim
DEPS_HOME=$NVIM_HOME/deps
CTAGS_HOME=$NVIM_HOME/universal-ctags
OS="$(uname -s)"

source $DEPS_HOME/util.sh

IS_APT=0
IS_DNF=0
IS_BREW=0

# utils {

info() {
    local content="$*"
    printf "[lin.nvim] - %s\n" "$content"
}

err() {
    local content="$*"
    info "error! $content"
}

skip_info() {
    local old="$IFS"
    IFS='/'
    local target="'$*'"
    info "$target already exist, skip..."
    IFS=$old
}

backup() {
    local src=$1
    if [[ -f "$src" || -d "$src" ]]; then
        local target=$src.$(date +"%Y-%m-%d.%H-%M-%S")
        info "backup '$src' to '$target'"
        mv $src $target
    fi
}

install() {
    local command="$1"
    local target="$2"
    if ! type "$target" >/dev/null 2>&1; then
        info "install '$target' with command: '$command'"
        eval "$command"
    else
        skip_info $target
    fi
}

install_func() {
    local func="$1"
    local target="$2"
    if ! type "$target" >/dev/null 2>&1; then
        info "install '$target' with function: '$func'"
        eval "$func"
    else
        skip_info $target
    fi
}

install_ctags() {
    info "install universal-ctags from source"
    cd $NVIM_HOME
    if [ ! -d $CTAGS_HOME ]; then
        git clone https://github.com/universal-ctags/ctags.git $CTAGS_HOME
    fi
    cd $CTAGS_HOME
    ./autogen.sh
    ./configure
    make
    sudo make install
}

# }

# apt: ubuntu/debian {

install_apt_nvim() {
    info "install 'nvim'(appimage) from github.com"
    sudo apt-get -q -y install fuse
    wget https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
    sudo mkdir -p /usr/local/bin
    chmod u+x nvim.appimage
    sudo mv nvim.appimage /usr/local/bin/nvim
}

install_apt_node() {
    # see: https://github.com/nodesource/distributions
    info "install nodejs from deb.nodesource.com"
    sudo apt-get -q -y install ca-certificates gnupg
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
    NODE_MAJOR=20
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
    sudo apt-get -q update
    sudo apt-get -q -y install nodejs
}

install_apt_ctags() {
    sudo apt-get -q -y install libseccomp-dev
    sudo apt-get -q -y install libjansson-dev
    sudo apt-get -q -y install libyaml-dev
    sudo apt-get -q -y install libxml2-dev
    install_ctags
}

install_apt_git() {
    sudo apt-add-repository ppa:git-core/ppa
    sudo apt-get -q update
    sudo apt-get -q -y install git
}

install_apt() {
    info "install dependencies with apt"
    sudo locale-gen en_US
    sudo locale-gen en_US.UTF-8
    sudo update-locale

    # neovim
    install_func "install_apt_nvim" "nvim"

    # c++ toolchain
    install "sudo apt-get -q -y install build-essential" "gcc"
    install "sudo apt-get -q -y install build-essential" "make"
    install "sudo apt-get -q -y install autoconf" "autoconf"
    install "sudo apt-get -q -y install automake" "automake"
    install "sudo apt-get -q -y install pkg-config" "pkg-config"
    install "sudo apt-get -q -y install cmake" "cmake"

    # download tools
    install_func "install_apt_git" "git"
    install "sudo apt-get -q -y install curl" "curl"
    install "sudo apt-get -q -y install wget" "wget"

    # compress tools
    install "sudo apt-get -q -y install p7zip" "7z"
    install "sudo apt-get -q -y install gzip" "gzip"
    install "sudo apt-get -q -y install unzip" "unzip"
    install "sudo apt-get -q -y install unrar" "unrar"

    # luarocks
    install "sudo apt-get -q -y install luajit" "luajit"
    install "sudo apt-get -q -y install luarocks" "luarocks"

    # copy/paste tools
    install "sudo apt-get -q -y install xsel" "xsel"
    install "sudo apt-get -q -y install xclip" "xclip"

    # python3
    install "sudo apt-get -q -y install python3 python3-dev python3-venv python3-pip python3-docutils python3-pynvim" "python3"
    install "sudo apt-get -q -y install python3 python3-dev python3-venv python3-pip python3-docutils python3-pynvim" "pip3"

    # nodejs
    install_func "install_apt_node" "node"

    # ctags
    install_func "install_apt_ctags" "ctags"
}

# }

# homebrew {

install_brew() {
    info "install dependencies with brew"

    if ! type clang >/dev/null 2>&1; then
        xcode-select --install
    fi
    if ! type brew >/dev/null 2>&1; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    fi

    brew update

    # neovim
    install "brew install neovim" "nvim"

    # c++ toolchain
    install "brew install cmake" "cmake"
    install "brew install pkg-config" "pkg-config"

    # download tools
    install "brew install git" "git"
    install "brew install curl" "curl"
    install "brew install wget" "wget"

    # compress tools
    install "brew install gzip" "gzip"
    install "brew install p7zip" "7z"
    install "brew install unzip" "unzip"
    install "brew install unrar" "unrar"

    # luarocks
    install "brew install luarocks" "luarocks"

    # python3
    install "brew install python3" "python3"

    # nodejs
    install "brew install node" "node"

    # ctags
    install "brew install universal-ctags" "ctags"

    # rust commands
    install "brew install fd" "fd"
    install "brew install ripgrep" "rg"
    install "brew install bat" "bat"
    install "brew install eza" "eza"
}

# }

# dnf: fedora/centos {

install_dnf_ctags() {
    sudo dnf install -y libseccomp-devel
    sudo dnf install -y jansson-devel
    sudo dnf install -y libyaml-devel
    sudo dnf install -y libxml2-devel
    install_ctags
}

install_dnf() {
    message "install dependencies with dnf"
    sudo dnf check-update

    # neovim
    install "sudo dnf install -y neovim" "nvim"

    # c++ toolchain
    install "sudo dnf group install -y \"Development Tools\"" "gcc"
    install "sudo dnf group install -y \"Development Tools\"" "make"
    install "sudo dnf install -y autoconf" "autoconf"
    install "sudo dnf install -y automake" "automake"
    install "sudo dnf install -y pkg-config" "pkg-config"
    install "sudo dnf install -y cmake" "cmake"

    # download tools
    install "sudo dnf install -y git" "git"
    install "sudo dnf install -y curl" "curl"
    install "sudo dnf install -y wget" "wget"

    # compress tools
    install "sudo dnf install -y gzip" "gzip"
    install "sudo dnf install -y p7zip" "7z"
    install "sudo dnf install -y unzip" "unzip"
    install "sudo dnf install -y unrar" "unrar"

    # luarocks
    install "sudo dnf install -y luarocks" "luarocks"

    # copy/paste tools
    install "sudo dnf install -y xsel" "xsel"
    install "sudo dnf install -y xclip" "xclip"

    # python3
    install "sudo dnf install -y python3 python3-devel python3-pip python3-docutils python3-pynvim" "python3"
    install "sudo dnf install -y python3 python3-devel python3-pip python3-docutils python3-pynvim" "pip3"

    # nodejs
    install "sudo dnf install -y nodejs npm" "node"

    # ctags
    install_func "install_dnf_ctags" "ctags"
}

# }

# dependency

rust_dependency() {
    info "install rust and modern commands"
    install "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y" "cargo"
    . "$HOME/.cargo/env"
    install "cargo install fd-find" "fd"
    install "cargo install ripgrep" "rg"
    install "cargo install --locked bat" "bat"
    install "cargo install eza" "eza"
}

pip3_dependency() {
    if [ $IS_APT -eq 0 ]; then
        info "install python packages with pip3"
        python3 -m pip install pynvim --user --upgrade
    fi
    # install "python3 -m pip install pipx --user && python3 -m pipx ensurepath" "pipx"
    # export PATH="$PATH:$HOME/.local/bin"
    # install "pipx install trash-cli" "trash-put"
}

npm_dependency() {
    info "install node packages with npm"
    sudo npm install -g neovim
    install "sudo npm install -g trash-cli" "trash"
}

nerdfont_latest_release_tag() {
    local org="$1"
    local repo="$2"
    local uri="https://github.com/$org/$repo/releases/latest"
    curl -s -f -L $uri | grep "href=\"/$org/$repo/releases/tag" | grep -Eo 'href="/[a-zA-Z0-9#~.*,/!?=+&_%:-]*"' | head -n 1 | cut -d '"' -f2 | cut -d "/" -f6
}

install_nerdfont() {
    if [ "$OS" == "Darwin" ]; then
        local font_name=$2
        info "install $font_name nerd fonts with brew"
        brew tap homebrew/cask-fonts
        brew install --cask $font_name
    else
        mkdir -p ~/.local/share/fonts && cd ~/.local/share/fonts
        local org="ryanoasis"
        local repo="nerd-fonts"
        local font_file=$1
        local font_version=$(nerdfont_latest_release_tag $org $repo)
        local font_url="https://github.com/$org/$repo/releases/download/$font_version/$font_file"
        info "install $font_file($font_version) nerd fonts from github"
        if [ -f $font_file ]; then
            rm -rf $font_file
        fi
        curl -s -L $font_url -o $font_file
        if [ $? -ne 0 ]; then
            info "failed to download $font_file, skip..."
        else
            unzip -q -o $font_file
            info "install $font_file($font_version) nerd font from github - done"
        fi
        sudo fc-cache -f
    fi
}

nerdfont_dependency() {
    install_nerdfont "Hack.zip" "font-hack-nerd-font"
    # install_nerdfont "FiraCode.zip" "font-fira-code-nerd-font"
    info "please set 'Hack NFM' (or 'Hack Nerd Font Mono') for your terminal font"
}

nvim_config() {
    info "install ~/.config/nvim/init.vim for neovim"
    mkdir -p $HOME/.config
    backup $HOME/.nvim
    ln -s $NVIM_HOME $HOME/.nvim

    # nvim-treesitter
    local nvim_treesitter_home="$NVIM_HOME/lua/configs/nvim-treesitter/nvim-treesitter"
    local nvim_treesitter_ensure_installed="$nvim_treesitter_home/ensure_installed.lua"
    if [ ! -f $nvim_treesitter_ensure_installed ]; then
        cp $nvim_treesitter_home/ensure_installed_sample.lua $nvim_treesitter_ensure_installed
    fi

    # nvim-lspconfig
    local nvim_lspconfig_home="$NVIM_HOME/lua/configs/neovim/nvim-lspconfig"
    local nvim_lspconfig_setup_handlers="$nvim_lspconfig_home/setup_handlers.lua"
    if [ ! -f $nvim_lspconfig_setup_handlers ]; then
        cp $nvim_lspconfig_home/setup_handlers_sample.lua $nvim_lspconfig_setup_handlers
    fi

    # mason-lspconfig.nvim
    local mason_lspconfig_home="$NVIM_HOME/lua/configs/williamboman/mason-lspconfig-nvim"
    local mason_lspconfig_ensure_installed="$mason_lspconfig_home/ensure_installed.lua"
    if [ ! -f $mason_lspconfig_ensure_installed ]; then
        cp $mason_lspconfig_home/ensure_installed_sample.lua $mason_lspconfig_ensure_installed
    fi
    local mason_lspconfig_setup_handlers="$mason_lspconfig_home/setup_handlers.lua"
    if [ ! -f $mason_lspconfig_setup_handlers ]; then
        cp $mason_lspconfig_home/setup_handlers_sample.lua $mason_lspconfig_setup_handlers
    fi

    # mason-null-ls.nvim
    local mason_null_ls_home="$NVIM_HOME/lua/configs/jay-babu/mason-null-ls-nvim"
    local mason_null_ls_ensure_installed="$mason_null_ls_home/ensure_installed.lua"
    if [ ! -f $mason_null_ls_ensure_installed ]; then
        cp $mason_null_ls_home/ensure_installed_sample.lua $mason_null_ls_ensure_installed
    fi
    local mason_null_ls_setup_handlers="$mason_null_ls_home/setup_handlers.lua"
    if [ ! -f $mason_null_ls_setup_handlers ]; then
        cp $mason_null_ls_home/setup_handlers_sample.lua $mason_null_ls_setup_handlers
    fi

    # conform.nvim
    local conform_home="$NVIM_HOME/lua/configs/stevearc/conform-nvim"
    local conform_formatters_by_ft="$conform_home/formatters_by_ft.lua"
    if [ ! -f $conform_formatters_by_ft ]; then
        cp $conform_home/formatters_by_ft_sample.lua $conform_formatters_by_ft
    fi

    # # nvim-lint
    # local nvim_lint_home="$NVIM_HOME/lua/configs/mfussenegger/nvim-lint"
    # local nvim_lint_linters_by_ft="$nvim_lint_home/linters_by_ft.lua"
    # if [ ! -f $nvim_lint_linters_by_ft ]; then
    #     cp $nvim_lint_home/linters_by_ft_sample.lua $nvim_lint_linters_by_ft
    # fi
}

info "install for $OS"

# dependency
case "$OS" in
Linux)
    if [ -f "/etc/arch-release" ] || [ -f "/etc/artix-release" ]; then
        $DEPS_HOME/pacman.sh $DEPS_HOME
    elif [ -f "/etc/fedora-release" ] || [ -f "/etc/redhat-release" ]; then
        install_dnf
        IS_DNF=1
    elif [ -f "/etc/gentoo-release" ]; then
        # not implement
    else
        # assume apt
        install_apt
        IS_APT=1
    fi
    ;;
Darwin)
    install_brew
    IS_BREW=1
    ;;
FreeBSD | NetBSD | OpenBSD)
    # not implement
    ;;
*)
    info "$OS is not supported, exit..."
    exit 1
    ;;
esac

rust_dependency
pip3_dependency
npm_dependency
nerdfont_dependency
nvim_config

info "install for $OS - done"
