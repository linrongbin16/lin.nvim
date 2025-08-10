#!/bin/bash

# set -x

info "install deps with pacman"
sudo pacman -Syy

# c++ toolchain
install "yes | sudo pacman -S base-devel" "gcc"
install "yes | sudo pacman -S base-devel" "make"
install "yes | sudo pacman -S autoconf" "autoconf"
install "yes | sudo pacman -S automake" "automake"
install "yes | sudo pacman -S pkg-config" "pkg-config"
install "yes | sudo pacman -S cmake" "cmake"

# download tools
install "yes | sudo pacman -S git" "git"
install "yes | sudo pacman -S curl" "curl"
install "yes | sudo pacman -S wget" "wget"

# compress tools
install "yes | sudo pacman -S gzip" "gzip"
install "yes | sudo pacman -S p7zip" "7z"
install "yes | sudo pacman -S unzip" "unzip"

# copy/paste tools
install "yes | sudo pacman -S xsel" "xsel"
install "yes | sudo pacman -S xclip" "xclip"

# python3
install "yes | sudo pacman -S python python-pip" "python3"
install "yes | sudo pacman -S python python-pip" "pip3"

# node
install "yes | sudo pacman -S nodejs npm" "node"

# golang
install "yes | sudo pacman -S go" "go"

# neovim
install "yes | sudo pacman -S neovim" "nvim"
