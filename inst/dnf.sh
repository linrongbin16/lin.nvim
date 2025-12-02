#!/bin/bash

# set -x

info "install deps with dnf"
sudo dnf check-update

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

# copy/paste tools
install "sudo dnf install -y xsel" "xsel"
install "sudo dnf install -y xclip" "xclip"

# python3
install "sudo dnf install -y python3 python3-devel python3-pip python3-docutils" "python3"
install "sudo dnf install -y python3 python3-devel python3-pip python3-docutils" "pip3"

# nodejs
install "sudo dnf install -y nodejs npm" "node"

# golang
install "sudo dnf install -y golang" "go"

# neovim
install "sudo dnf install -y neovim" "nvim"
