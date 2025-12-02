#!/bin/bash

# set -x

install_nodejs() {
	# see: https://github.com/nodesource/distributions
	sudo apt-get -q -y install curl
	curl -fsSL https://deb.nodesource.com/setup_lts.x -o nodesource_setup.sh
	sudo -E bash nodesource_setup.sh
	sudo apt-get -q update
	sudo apt-get -q -y install nodejs
}

install_git() {
	sudo apt-add-repository ppa:git-core/ppa
	sudo apt-get -q update
	sudo apt-get -q -y install git
}

install_neovim() {
	sudo apt install snapd
	sudo snap install nvim --classic
}

install_go() {
    sudo add-apt-repository -y ppa:longsleep/golang-backports
    sudo apt update
    sudo apt-get install -q -y golang-go
}

info "install deps with apt"
sudo apt update
sudo locale-gen en_US
sudo locale-gen en_US.UTF-8
sudo update-locale

# c++ toolchain
install "sudo apt-get -q -y install build-essential" "gcc"
install "sudo apt-get -q -y install build-essential" "make"
install "sudo apt-get -q -y install autoconf" "autoconf"
install "sudo apt-get -q -y install automake" "automake"
install "sudo apt-get -q -y install pkg-config" "pkg-config"
install "sudo apt-get -q -y install cmake" "cmake"

# download tools
install "install_git" "git"
install "sudo apt-get -q -y install curl" "curl"
install "sudo apt-get -q -y install wget" "wget"

# compress tools
install "sudo apt-get -q -y install p7zip" "7z"
install "sudo apt-get -q -y install gzip" "gzip"
install "sudo apt-get -q -y install unzip" "unzip"

# copy/paste tools
install "sudo apt-get -q -y install xsel" "xsel"
install "sudo apt-get -q -y install xclip" "xclip"

# python3
install "sudo apt-get -q -y install python3 python3-dev python3-venv python3-pip python3-docutils" "python3"
install "sudo apt-get -q -y install python3 python3-dev python3-venv python3-pip python3-docutils" "pip3"

# nodejs
install "install_nodejs" "node"

# golang
install "install_go" "go"

# neovim
install "install_neovim" "nvim"
