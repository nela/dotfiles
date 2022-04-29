###############################################
# Minimal devbox .bashrc. Add user custom stuff
# ##############################################

export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.local/cache"
export XDG_BIN_HOME="${HOME}/.local/bin"
export XDG_STATE_HOME="${HOME}/.local/state"
export XDG_LIB_HOME="${HOME}/.local/lib"
export XDG_REPO_HOME="${HOME}/.local/repositories"

export DOTS="${HOME}/dotfiles"
# export REPOS="${HOME}/repos"
export NVIM="${DOTS}/nvim/.config/nvim"
export NVIM_CONFIG="${NVIM_CONFIG_HOME}/init.vim"
export NELAPYS="${XDG_DATA_HOME}/nelapys"
export POETRY_VIRTUALENVS_PATH="${NELAPYS}"
export EDITOR="nvim"

export MAVEN_OPTS=-Xmx4096m

export PNPM_STORE="${XDG_LIB_HOME}/pnpm-store"
export PNPM_GLOBAL="${XDG_LIB_HOME}/pnpm-global"
export PNPM_GLOBAL_BIN="${XDG_BIN_HOME}/pnpm-global"
export PNPM_STATE="${XDG_STATE_HOME}/pnpm-state"

[[ ":${PATH}:" != *":${XDG_BIN_HOME}:"* ]] && export PATH="${XDG_BIN_HOME}:${PATH}"

source ~/.asdf/plugins/java/set-java-home.bash

# Add this lines at the top of .bashrc:
[[ $- == *i* ]] && source ${XDG_REPO_HOME}/ble.sh/out/ble.sh --noattach

source $HOME/.asdf/asdf.sh
source $HOME/.asdf/completions/asdf.bash

source $DOTS/asdf/asdf-pyvirtual-envs.sh
source $DOTS/scripts/aliases.sh
source $DOTS/scripts/bash-it

# Add this line at the end of .bashrc:
# [[ ${BLE_VERSION-} ]] && ble-attach
