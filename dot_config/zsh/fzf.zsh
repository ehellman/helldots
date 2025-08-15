# fzf 

TOKYONIGHT_MOON="
  --color=bg+:#2d3f76
  --color=bg:#1e2030
  --color=border:#589ed7
  --color=fg:#c8d3f5
  --color=gutter:#1e2030
  --color=header:#ff966c
  --color=hl+:#65bcff
  --color=hl:#65bcff
  --color=info:#545c7e
  --color=marker:#ff007c
  --color=pointer:#ff007c
  --color=prompt:#65bcff
  --color=query:#c8d3f5:regular
  --color=scrollbar:#589ed7
  --color=separator:#ff966c
  --color=spinner:#ff007c
"

TOKYONIGHT_NIGHT="
  --color=bg+:#283457
  --color=bg:#16161e
  --color=border:#27a1b9
  --color=fg:#c0caf5
  --color=gutter:#16161e
  --color=header:#ff9e64
  --color=hl+:#2ac3de
  --color=hl:#2ac3de
  --color=info:#545c7e
  --color=marker:#ff007c
  --color=pointer:#ff007c
  --color=prompt:#2ac3de
  --color=query:#c0caf5:regular
  --color=scrollbar:#27a1b9
  --color=separator:#ff9e64
  --color=spinner:#ff007c
"

TOKYONIGHT_STORM="
  --color=bg+:#2e3c64
  --color=bg:#1f2335
  --color=border:#29a4bd
  --color=fg:#c0caf5
  --color=gutter:#1f2335
  --color=header:#ff9e64
  --color=hl+:#2ac3de
  --color=hl:#2ac3de
  --color=info:#545c7e
  --color=marker:#ff007c
  --color=pointer:#ff007c
  --color=prompt:#2ac3de
  --color=query:#c0caf5:regular
  --color=scrollbar:#29a4bd
  --color=separator:#ff9e64
  --color=spinner:#ff007c
"

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --cycle \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --height 60% \
  --preview-window=right:70% \
  --border=none \
  --bind=ctrl-u:half-page-up,ctrl-d:half-page-down,ctrl-x:jump \
  --bind=ctrl-f:preview-page-down,ctrl-b:preview-page-up \
  --bind=ctrl-a:beginning-of-line,ctrl-e:end-of-line \
  --bind=ctrl-j:down,ctrl-k:up \
  $TOKYONIGHT_NIGHT \
"
source <(fzf --zsh)

