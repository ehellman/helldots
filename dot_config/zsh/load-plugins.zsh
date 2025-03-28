[ -f $ZSH_PLUGIN_DIR/powerlevel10k/powerlevel10k.zsh-theme ] && source $ZSH_PLUGIN_DIR/powerlevel10k/powerlevel10k.zsh-theme;
[ -f $ZSH_PLUGIN_DIR/zsh-defer/zsh-defer.plugin.zsh ] && source $ZSH_PLUGIN_DIR/zsh-defer/zsh-defer.plugin.zsh;
[ -f $ZSH_PLUGIN_DIR/zsh-autosuggestions.zsh ] && zsh-defer source $ZSH_PLUGIN_DIR/zsh-autosuggestions.zsh;
[ -f $ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && zsh-defer source $ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh;
[ -f $ZSH_PLUGIN_DIR/zsh-system-clipboard/zsh-system-clipboard.zsh ] && zsh-defer source $ZSH_PLUGIN_DIR/zsh-system-clipboard/zsh-system-clipboard.zsh;
