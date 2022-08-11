###############################################################################
# Key Bindings
###############################################################################

# Key bindings can be customized in this section. For instance, to use
# vim hjkl in menu selection (during completion)
# (Doesn't work well with interactive mode)

# Should be called before compinit
zmodload zsh/complist

# Shift tab for reverse menu complete
bindkey -M menuselect '^[[Z' reverse-menu-complete
# bindkey -M menuselect 'h' vi-backward-char
# bindkey -M menuselect 'k' vi-up-line-or-history
# bindkey -M menuselect 'j' vi-down-line-or-history
# bindkey -M menuselect 'l' vi-forward-char
#
# Clear screen
# bindkey -M menuselect '^xg' clear-screen
# Insert
# bindkey -M menuselect '^xi' vi-insert
# Hold
# bindkey -M menuselect '^xh' accept-and-hold
# Next
# bindkey -M menuselect '^xn' accept-and-infer-next-history
# Undo
# bindkey -M menuselect '^xu' undo


bindkey -v
# down-line-or-history #
# autoload -U history-search-end

# zle -N history-beginning-search-backward-end history-search-end
# zle -N history-beginning-search-forward-end history-search-end

bindkey -M viins '^P' history-beginning-search-backward #-end
bindkey -M viins '^N' history-beginning-search-forward #-end

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=247'

bindkey '^A' autosuggest-accept
bindkey '^K' autosuggest-clear
bindkey '^X' autosuggest-execute
bindkey '^F' autosuggest-fetch
