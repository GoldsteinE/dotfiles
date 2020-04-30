## Zsh configuration file.

## Add local files to PATH
PATH=$PATH:$HOME/.local/bin:$HOME/.cargo/bin

## Add completion functions to fpath
fpath=( ~/.zcompl "${fpath[@]}" )

## Variables by default
[ -z "$PAGER" ] && export PAGER=less
if command -v nvim >/dev/null 2>&1; then
	export EDITOR=nvim
else
	command -v nvim
	export EDITOR=vim
fi
alias vim="$EDITOR"
[ -z "$SUDO_PROMPT" ] && export SUDO_PROMPT="Enter password: "
export SHELL=/usr/bin/zsh
export PYTHONSTARTUP=~/.pythonrc
export haas=/home/goldstein/bin/arcadia/haas
export TERM="xterm-256color"
stty -ixon  # Disable ^S

## Enabling history.
export SAVEHIST=1000
export HISTFILE=~/.zhistory
setopt histignorealldups
setopt histignorespace
setopt histreduceblanks
setopt appendhistory

## Autocomplete initialization & automatic rehash & manual rehash.
autoload -U compinit && compinit
zstyle ":completion:*" rehash true
setopt nohashdirs
rehash

## Other shell options.
setopt autocd
setopt interactivecomments
zstyle ':completion:*' menu select
[ -f /etc/DIR_COLORS ] && eval $(dircolors -b /etc/DIR_COLORS)
export ZLSCOLORS="${LS_COLORS}"
zmodload zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*:processes' command 'ps -ax'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;32'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always
zstyle ':completion:*:processes-names' command 'ps -e -o comm='
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*'   force-list always

## Loading modules.
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
autoload -U zcalc

## Setting prompt.
autoload -U colors && colors
export PROMPT="%0(?..[%{$fg[yellow]%}%?%{$reset_color%}] )%{$fg[red]%}%n%{$reset_color%}@%{$fg[cyan]%}%M%{$reset_color%} %~ [%T] %{$fg[red]%}%0(#.#.$)%{$reset_color%} "

## Copied part for git
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats \
            '%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f'
zstyle ':vcs_info:*' formats       \
            '%F{5}[%F{2}%b%F{5}]%f'
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' enable git cvs svn
vcs_info_wrapper() {
        vcs_info
        if [ -n "$vcs_info_msg_0_" ]; then
                echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
        fi
}
RPROMPT=$'$(vcs_info_wrapper)'


## Stabilizing title
case $TERM in
	xterm*)
		precmd() { print -Pn "\e]0;$(whoami) [$(print -rD $PWD)] @ $(hostname)\a"; }
		;;
esac


## Aliases.
alias colordiff=~/bin/colordiff

alias reload-shell="exec /proc/self/exe --login"
alias ls="LC_COLLATE=C ls --color=auto -hF --group-directories-first"
alias la="ls -A"
alias ll="ls -Al"
alias fucking=sudo
alias LS=sl
alias pacman="pacman --color=auto"
alias less="less -M"
alias fuck='sudo $(history -1 | sed "s/^\s*[0-9]*\s*//" -)'
alias RM='shred -fzun 7'
alias u='$({ cat ~/.zhistory; history 0 | cut -d" " -f6- } | fzf)'

## Git aliases
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'
alias gs='git status'
alias gd='git diff'
alias gdd='git diff --staged'
alias gpl='git pull'
alias gps='git push'
alias gt='git tag'
alias gch='git checkout'
function ]() {
	git commit -m "$*"
}

function vimhelp() {
	vim +"help $1 | only"
}

## Enables 'cd -$n' command.
setopt autopushd
setopt pushdminus
setopt pushdignoredups
setopt pushdsilent
alias cd="cd >/dev/null"

## Commands options
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
 --color=fg:#f8f8f2,bg:#1d1f21,hl:#92c5f7
 --color=fg+:#f8f8f2,bg+:#293739,hl+:#92c5f7
 --color=info:#dad085,prompt:#89807d,pointer:#92c5f7
 --color=marker:#99cc99,spinner:#92c5f7,header:#a8ff60'

function ssh() {
	if [ "$#" -ne "0" ]; then
		command ssh "$@"
	else
		tmp_ssh_hostname="$({
			awk -F'[ ,:]' '/^[0-9a-zA-Z]/{sub(/\[/,"",$1); sub(/\]/,"",$1); print $1}' ~/.ssh/known_hosts
			cat ~/.ssh/config | grep -oP '^Host\s+\K[^*]$'
		} | fzf --height=30% --layout=reverse)"
		if [ -n "$ZSH_VERSION" ]; then
			print -s "ssh $tmp_ssh_hostname"
		else
			history -s "ssh $tmp_ssh_hostname"
		fi
		ssh $tmp_ssh_hostname
	fi
}

## Key bindings.
bindkey -e
typeset -A key
key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
#key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}
key[ControlLeft]=';5D'
key[ControlRight]=';5C'
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history
bindkey "${key[ControlLeft]}" backward-word
bindkey "${key[ControlRight]}" forward-word
bindkey '^ ' autosuggest-accept
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi
