alias jctl="journalctl -p 3 -xb"

alias ls='eza --color=auto --icons --group-directories-first'
alias l='ls -lhF'
alias la='ls -lhAF'
alias tree='ls --tree'
alias cd='z'

alias cat='bat --wrap character'
alias ping='gping'
alias yay='paru'

alias t='tmux'
alias ta='tmux attach'
alias tl='tmux list-sessions'
alias tk='tmux kill-session -t'

function n() {
  APPNAME=$(gum choose --header "Which nvim configuration would you like to use?" "hellman" "lazyvim" "lazydev")
  NVIM_APPNAME=nvim-$APPNAME nvim "$@"
}

alias nvim='NVIM_APPNAME=nvim-hellman nvim'

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
		zoxide add "$cwd"
	fi
	rm -f -- "$tmp"
}
