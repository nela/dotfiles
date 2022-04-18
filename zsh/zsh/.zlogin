#!/usr/bin/env zsh
# nvim:syntax=zsh
# nvim:filetype=zsh

# From: https://github.com/htr3n/zsh-config/blob/master/zlogin
# Execute code in the background to not affect the current session
(
    # <https://github.com/zimfw/zimfw/blob/master/login_init.zsh>
    setopt LOCAL_OPTIONS EXTENDED_GLOB
    autoload -U zrecompile
    local ZSHCONFIG=~/.zsh-config

    # Compile zcompdump, if modified, to increase startup speed.
    zcompdump="${ZSH_CACHE_DIR:-$HOME}/.zcompdump-${ZSH_VERSION}"
    if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
        zrecompile -pq "$zcompdump"
    fi
    # zcompile .zshrc
    zrecompile -pq ${ZDOTDIR:-${HOME}}/.zshrc
    zrecompile -pq ${ZDOTDIR:-${HOME}}/.zprofile
    zrecompile -pq ${ZDOTDIR:-${HOME}}/.zshenv
    # recompile all zsh or sh
    # for f in $ZSHCONFIG/**/*.*sh
    # do
    #     zrecompile -pq $f
    # done
) &!

## eval "$(rbenv init -)"
