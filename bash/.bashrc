###############################################
# Minimal devbox .bashrc. Add user custom stuff
# ##############################################


export XDG_DATA_HOME=${HOME}/.local/share
export XDG_CONFIG_HOME=${HOME}/.config
export DOTFILES_HOME=${HOME}/dotfiles
export NVIM_CONFIG_HOME=${DOTFILES_HOME}/nvim/.config/nvim
export NVIM_CONFIG=${NVIM_CONFIG_HOME}/init.vim

# Add this lines at the top of .bashrc:
# [[ $- == *i* ]] && source ${HOME}/repos/ble.sh/out/ble.sh --noattach

source $DOTFILES_HOME/scripts/asdf-pyvirtual-envs.sh
source $DOTFILES_HOME/scripts/fzf
source $DOTFILES_HOME/scripts/bash-it


# Add this line at the end of .bashrc:
# [[ ${BLE_VERSION-} ]] && ble-attach
