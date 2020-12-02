#!/bin/sh
set -e

BINARIES_VERSION='0.1.1'

die() {
	echo "$@" >&2
	exit 1
}

require() {
	if ! command -v "$1" >/dev/null 2>&1; then
		die "please, install $1"
	fi
}

# Shield against incomplete downloads
main() {
	require zsh
	require git
	require curl

	echo "Downloading binaries..." >&2
	mkdir -p "$HOME/.binaries"
	cd "$HOME/.binaries"
	curl -fL "https://github.com/GoldsteinE/binaries/releases/downloads/$BINARIES_VERSION/binaries.tar.gz" | tar xzf -
	export PATH="$PATH:$HOME/.binaries/bin"	

	echo "Downloading dotfiles..." >&2
	yadm clone 'git@github.com:GoldsteinE/dotfiles.git'

	echo "Ensuring that shada dir exists..." >&2
	mkdir -p "$HOME/.config/nvim/shada"

	echo "Ready! Feel free to 'exec zsh' now"
}

main
