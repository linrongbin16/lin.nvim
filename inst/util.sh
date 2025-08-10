#!/bin/bash

# set -x

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

install_go() {
	git clone --depth=1 https://github.com/kerolloz/go-installer
	export GOROOT="$HOME/.go" # where go is installed
	export GOPATH="$HOME/go"  # user workspace
	bash ./go-installer/go.sh
	export PATH="$PATH:$GOROOT/bin"
	export PATH="$PATH:$GOPATH/bin"
}

install_fzf() {
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install --bin
	sudo cp ~/.fzf/bin/fzf /usr/local/bin/fzf
	fzf --version
}

install_gtrash() {
	go install github.com/umlx5h/gtrash@latest
}

install_lazygit() {
	go install github.com/jesseduffield/lazygit@latest
}

install_bun() {
	curl -fsSL https://bun.com/install | bash
}

install_deno() {
	curl -fsSL https://deno.land/install.sh | sh -s -- -y
}
