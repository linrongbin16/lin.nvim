#!/bin/bash

message() {
    local content="$*"
    printf "[lin.nvim] - %s\n" "$content"
}

skip_message() {
    local old="$IFS"
    IFS='/'
    local target="'$*'"
    message "$target already exist, skip..."
    IFS=$old
}

error_message() {
    local content="$*"
    message "error! $content"
}

try_backup() {
    local src=$1
    if [[ -f "$src" || -d "$src" ]]; then
        local target=$src.$(date +"%Y-%m-%d.%H-%M-%S.%6N")
        message "backup '$src' to '$target'"
        mv $src $target
    fi
}

install_or_skip() {
    local command="$1"
    local target="$2"
    if ! type "$target" >/dev/null 2>&1; then
        message "install '$target' with command: '$command'"
        eval "$command"
    else
        skip_message $target
    fi
}

install_universal_ctags() {
    local nvim_home=$HOME/.nvim
    local ctags_home=$nvim_home/universal-ctags

    message "install universal-ctags from source"
    cd $nvim_home
    git clone https://github.com/universal-ctags/ctags.git $ctags_home
    cd $ctags_home
    ./autogen.sh
    ./configure
    make
    sudo make install
}

install_rust_commands() {
    message 'install modern rust commands with cargo'
    install_or_skip "cargo install fd-find" "fd"
    install_or_skip "cargo install ripgrep" "rg"
    install_or_skip "cargo install --locked bat" "bat"
    install_or_skip "cargo install git-delta" "delta"
}
