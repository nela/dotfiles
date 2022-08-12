# nvim:syntax=zsh
# nvim:filetype=zsh

##### PATH #####
# [[ ":${PATH}:" != *":/usr/local/bin:"* ]] && export PATH="/usr/local/bin:${PATH}"
# [[ ":${PATH}:" != *":/usr/local/sbin:"* ]] && export PATH="/usr/local/sbin:${PATH}"
# [[ ":${PATH}:" != *":${HOME}/.local/bin:"* ]] && export PATH="${HOME}/.local/bin:${PATH}"
# [[ ":${PATH}:" != *":${PNPM_GLOBAL_BIN}:"* ]] && export PATH="${PNPM_GLOBAL_BIN}:${PATH}"

##### XDG #####
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_BIN_HOME="${HOME}/.local/bin"
export XDG_LIB_HOME="${HOME}/.local/lib"
export XDG_STATE_HOME="${HOME}/.local/state"
export XDG_REPO_HOME="${HOME}/.local/repositories"

##### PNPM #####
export PNPM_STORE="${XDG_LIB_HOME}/pnpm-store"
export PNPM_GLOBAL="${XDG_LIB_HOME}/pnpm-global"
export PNPM_GLOBAL_BIN="${XDG_BIN_HOME}/pnpm-global"
export PNPM_STATE="${XDG_DATA_HOME}/pnpm-state"

##### Custom #####
export DOTS="${HOME}/dotfiles"
export NVIM="${DOTS}/nvim/.config/nvim"
export ZSHRC="${ZSH}/.zshrc"
export NELAPYS="${XDG_DATA_HOME}/nelapys"
export EDITOR="nvim"
export VENV_HOME="${XDG_DATA_HOME}/nelapys"
[ -d /usr/local/Cellar/asdf ] \
  && export ASDF_DIR="/usr/local/Cellar/asdf" \
  || export ASDF_DIR="${XDG_REPO_HOME}/asdf"
export ASDF_DATA_DIR="${XDG_DATA_HOME}/asdf"

##### Locale #####
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_COLLATE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LC_MONETARY=en_US.UTF-8
export LC_NUMERIC=en_US.UTF-8
export LC_TIME=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LESSCHARSET=utf-8

export LESSHISTFILE="${XDG_CACHE_HOME}/less/lesshst"

##### Zsh #####
# Keep this at the very end
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"
export ZCOMPCACHE="$XDG_CACHE_HOME/zsh/zcompcache"

[ -d "$ZSH_CACHE_DIR" ] || mkdir -p "$ZSH_CACHE_DIR"
[ -d "$ZCOMPCACHE" ] || mkdir -p "$ZCOMPCACHE"

path=(
  /usr/local/{bin,sbin}
  $XDG_BIN_HOME
  $ASDF_DIR
  $path
)

# eliminates duplicates in *paths
typeset -gU cdpath fpath path
