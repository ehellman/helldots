alias jctl="journalctl -p 3 -xb"

alias ls='eza --color=auto --icons --group-directories-first'
alias l='ls -lhF'
alias la='ls -lhAF'
alias tree='ls --tree'
alias cd='z'

alias cat='bat --wrap character'
alias ping='gping'
alias yay='paru'


function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
		zoxide add "$cwd"
	fi
	rm -f -- "$tmp"
}
