# Developed by article https://htr3n.github.io/2018/07/faster-zsh/
# Authors repo: https://github.com/htr3n/zsh-config

# https://blog.patshead.com/2011/04/improve-your-oh-my-zsh-startup-time-maybe.html
# https://www.zsh.org/mla/users/2021/msg00879.html
skip_global_compinit=1

# http://disq.us/p/f55b78
setopt noglobalrcs

export SYSTEM=$(uname -s)
export ZDOTDIR="$HOME/dotfiles/zsh"

if [[ "${SYSTEM}" == "Darwin" ]]; then
  export XDG_DATA_HOME="${HOME}/.local/share"
  export XDG_CACHE_HOME="${HOME}/.cache"
  export XDG_CONFIG_HOME="${HOME}/.config"
  export XDG_STATE_HOME="${HOME}/.local/state"
fi

export XDG_BIN_HOME="${HOME}/.local/bin"
export XDG_LIB_HOME="${HOME}/.local/lib"

export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME}/zsh"
[ -d "$ZSH_CACHE_DIR" ] || mkdir -p "$ZSH_CACHE_DIR"

##### PATH #####
path=(
  /usr/local/{bin,sbin}
  $path
  $XDG_BIN_HOME
)
[[ -d /opt/homebrew ]] && path=(/opt/homebrew/{bin,sbin} $path)

typeset -gU cdpath fpath path

##### Cargo #####
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

##### Source .zprofile for top-level non-login shells #####
# https://github.com/sorin-ionescu/prezto/blob/master/runcoms/zshenv
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR}/.zprofile"
fi
