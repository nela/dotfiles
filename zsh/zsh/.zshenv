# Developed by article https://htr3n.github.io/2018/07/faster-zsh/
# Authors repo: https://github.com/htr3n/zsh-config

# https://blog.patshead.com/2011/04/improve-your-oh-my-zsh-startup-time-maybe.html
# https://www.zsh.org/mla/users/2021/msg00879.html
skip_global_compinit=1

# http://disq.us/p/f55b78
setopt noglobalrcs

export SYSTEM=$(uname -s)
export ZSH="$HOME/dotfiles/zsh"
export ZDOTDIR="$HOME/dotfiles/zsh/zsh"

# echo 'sourcing zshenv'
# echo $ZDOTDIR

# https://github.com/sorin-ionescu/prezto/blob/master/runcoms/zshenv
# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR}/.zprofile"
fi



# [[ ":${PATH}:" != *":/usr/local/bin:"* ]] && export PATH="/usr/local/bin:${PATH}"
# [[ ":${PATH}:" != *":/usr/local/sbin:"* ]] && export PATH="/usr/local/sbin:${PATH}"
# [[ ":${PATH}:" != *":${HOME}/.local/bin:"* ]] && export PATH="${HOME}/.local/bin:${PATH}"

# export XDG_DATA_HOME="${HOME}/.local/share"
# export XDG_CACHE_HOME="${HOME}/.cache"
# export XDG_CONFIG_HOME="${HOME}/.config"
# export XDG_BIN_HOME="${HOME}/.local/bin"
# export XDG_LIB_HOME="${HOME}/.local/lib"
#
# export DOTS="${HOME}/dotfiles"
# export NVIM="${DOTS}/nvim/.config/nvim"
# export ZSH="${DOTS}/zsh"
# export ZSHRC="${ZSH}/.zshrc"
# export REPOS="${HOME}/.repos"
# # export LANG_SERVERS="${XDG_DATA_HOME}/lang-servers/"
# export NELAPYS="${XDG_DATA_HOME}/nelapys"
# export EDITOR="nvim"
#
# export PNPM_STORE="${XDG_LIB_HOME}/pnpm-store"
# export PNPM_GLOBAL="${XDG_LIB_HOME}/pnpm-global"
# export PNPM_GLOBAL_BIN="${XDG_BIN_HOME}/pnpm-global"
# export PNPM_STATE="${XDG_DATA_HOME}/pnpm-state"
#
# # [[ ":${PATH}:" != *":${PNPM_GLOBAL_BIN}:"* ]] && export PATH="${PNPM_GLOBAL_BIN}:${PATH}"
#
# export LANG=en_US.UTF-8
# export LANGUAGE=en_US.UTF-8
# export LC_ALL=en_US.UTF-8
# export LC_ALL="en_US.UTF-8"
#
# # Keep this at the very end
# export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
#
# export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"
# [ -d "$ZSH_CACHE_DIR" ] || mkdir -p "$ZSH_CACHE_DIR"
#
# export ZCOMPCACHE="$XDG_CACHE_HOME/zsh/zcompcache"
# [ -d "$ZCOMPCACHE" ] || mkdir -p "$ZCOMPCACHE"


# export PATH="/usr/local/bin:${PATH}"
# export PATH="/usr/local/sbin:${PATH}"
# export PATH="${XDG_BIN_HOME}:${PATH}"
# export PATH="${PNPM_GLOBAL_BIN}:${PATH}"
