# XDG Base Directory Specification
# http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export ZSH_CONFIG="$XDG_CONFIG_HOME/zsh"

# Make nvim default editor
export EDITOR=nvim

if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
  # enable wayland env variables for firefox
  export MOZ_DBUS_REMOTE=1
  export MOZ_ENABLE_WAYLAND=1
fi
