###############################################
# Minimal devbox .bashrc. Add user custom stuff
# ##############################################


export XDG_DATA_HOME=${HOME}/.local/share
export XDG_CONFIG_HOME=${HOME}/.config
export DOTFILES=${HOME}/dotfiles
export NVIM_CONFIG_HOME=${DOTFILES}/nvim/.config/nvim
export NVIM_CONFIG=${NVIM_CONFIG_HOME}/init.vim

# Add this lines at the top of .bashrc:
# [[ $- == *i* ]] && source ${HOME}/repos/ble.sh/out/ble.sh --noattach

source $DOTFILES/scripts/asdf-pyvirtual-envs.sh
source $DOTFILES/scripts/fzf
source $DOTFILES/scripts/bash-it
#source $DOTFILES/scripts/install-azure-cli.sh


# Add this line at the end of .bashrc:
# [[ ${BLE_VERSION-} ]] && ble-attach
