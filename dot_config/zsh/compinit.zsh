autoload -Uz compinit

zcompdump_file=${ZSH_CONFIG:-$HOME}/.zcompdump

current_day=$(date +'%j')

# Get the last modification day of .zcompdump (portable version)
if [ -e "$zcompdump_file" ]; then
  mod_day=$(date -r "$zcompdump_file" +'%j')
else
  mod_day=0
fi

# Compare days and decide whether to regenerate the cache
if [ "$current_day" != "$mod_day" ]; then
  compinit
else
  compinit -C
fi
