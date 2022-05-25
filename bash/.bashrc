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

# [ -f ~/.fzf.bash ] && source ~/.fzf.bash
# Setup fzf
# ---------
# if [[ ! "$PATH" == */home/nemanjl/.local/repositories/fzf/bin* ]]; then
#   export PATH="${PATH:+${PATH}:}/home/nemanjl/.local/repositories/fzf/bin"
# fi

if [ -d "$XDG_REPO_HOME"/fzf/bin* ] && [ ! -L "$XDG_BIN_HOME"/fzf ]; then
  ln -sf "$XDG_REPO_HOME"/fzf/bin/fzf "$XDG_BIN_HOME"/fzf
fi

if [ -d "$XDG_REPO_HOME"/fzf/bin* ] && [ ! -L "$XDG_BIN_HOME"/fzf-tmux ]; then
  ln -sf "$XDG_REPO_HOME"/fzf/bin/fzf-tmux "$XDG_BIN_HOME"/fzf-tmux
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/nemanjl/.local/repositories/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/nemanjl/.local/repositories/fzf/shell/key-bindings.bash"

# Add this lines at the top of .bashrc:
[[ $- == *i* ]] && source ${XDG_REPO_HOME}/ble.sh/out/ble.sh --noattach

source "$HOME"/.asdf/asdf.sh
source "$HOME"/.asdf/completions/asdf.bash
source "$HOME"/.asdf/plugins/java/set-java-home.bash

source $DOTS/asdf/asdf-pyvirtual-envs.sh
source $DOTS/scripts/bash-it
source $DOTS/shell-common/aliases.sh
source $DOTS/shell-common/fzf.sh

_fzf_setup_completion path v
_fzf_setup_completion dir v
_fzf_setup_completion var v

# (EXPERIMENTAL) Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --preview 'dig {}' ;;
    *)            fzf "$@" ;;
  esac
}

# Add this line at the end of .bashrc:
[[ ${BLE_VERSION-} ]] && ble-attach
