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

	tarball="$(mktemp --suffix=.tar.gz)"
	# shellcheck disable=SC2064
	trap "rm '$tarball'" EXIT INT TERM

	echo "Downloading binaries..." >&2
	curl "https://github.com/GoldsteinE/binaries/release/tag/$BINARIES_VERSION" -o "$tarball"

	echo "Unpacking binaries..." >&2
	mkdir -p "$HOME/.binaries"
	cd "$HOME/.binaries"
	tar xzf "$tarball"
	export PATH="$PATH:$HOME/.binaries/bin"	

	echo "Downloading dotfiles..." >&2
	yadm clone 'git@github.com:GoldsteinE/dotfiles.git'

	echo "Ensuring that shada dir exists..." >&2
	mkdir -p "$HOME/.config/nvim/shada"

	echo "Ready! Feel free to 'exec zsh' now"
}

main
