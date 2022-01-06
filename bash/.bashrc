###############################################
# Minimal devbox .bashrc. Add user custom stuff
# ##############################################


# export XDG_DATA_HOME=${HOME}/.local/share
# export XDG_CONFIG_HOME=${HOME}/.config
# export XDG_CACHE_HOME=${HOME}/.local/cache
# export DOTFILES=${HOME}/dotfiles
# export NVIM_CONFIG_HOME=${DOTFILES}/nvim/.config/nvim
# export NVIM_CONFIG=${NVIM_CONFIG_HOME}/init.vim
# export NELAPYS=${XDG_DATA_HOME}/nelapys
source ${HOME}/dotfiles/scripts/export-common
export POETRY_VIRTUALENVS_PATH=${NELAPYS}

# Add this lines at the top of .bashrc:
[[ $- == *i* ]] && source ${HOME}/repos/ble.sh/out/ble.sh --noattach

source ${DOTS}/scripts/asdf-pyvirtual-envs.sh
source ${DOTS}/fzf/fzf.bash
source ${DOTS}/scripts/bash-it
source ${DOTS}/scripts/aliases.sh
source ${DOTS}/scripts/locale.sh
#source $DOTFILES/scripts/install-azure-cli.sh


# Add this line at the end of .bashrc:
# [[ ${BLE_VERSION-} ]] && ble-attach
