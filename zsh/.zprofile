# nvim:syntax=zsh
# nvim:filetype=zsh

##### PNPM #####
export PNPM_HOME="${XDG_DATA_HOME}/pnpm"
export PNPM_STORE="${XDG_DATA_HOME}/pnpm/store"
export PNPM_GLOBAL="${XDG_DATA_HOME}/pnpm/global"
export PNPM_GLOBAL_BIN="${XDG_DATA_HOME}/pnpm"
export PNPM_STATE="${XDG_STATE_HOME}/pnpm"
export PNPM_CACHE="${XDG_CACHE_HOME}/pnpm"

##### Custom #####
export DOTS="${HOME}/dotfiles"
export NELAPYS="${XDG_DATA_HOME}/nelapys"
export EDITOR="nvim"
export VENV_HOME="${XDG_DATA_HOME}/nelapys"

uname_str=$(uname -a | tr '[:upper:]' '[:lower:]')

# if [ -d "${XDG_DATA_HOME}"/asdf/source ]; then
#   export ASDF_DIR="${XDG_DATA_HOME}"/asdf/source
# elif [[ $uname_str == *darwin* ]]; then
#   export ASDF_DIR="/usr/local/opt/asdf"
# elif [[ $uname_str == *archlinux* ]]; then
#   export ASDF_DIR="/opt/asdf-vm"
# fi

if [ -d "${XDG_DATA_HOME}"/asdf/source ]; then
  export ASDF_DIR="${XDG_DATA_HOME}"/asdf/source
elif [[ "$OSTYPE" == darwin* ]]; then
  export ASDF_DIR="/opt/homebrew/opt/asdf"
elif [[ "$OSTYPE" == linux-gnu ]]; then
  export ASDF_DIR="/opt/asdf-vm"
fi


export ASDF_DATA_DIR="${XDG_DATA_HOME}/asdf"
export LESSHISTFILE="${XDG_CACHE_HOME}/less/lesshst"
export KUBECONFIG="${XDG_CONFIG_HOME}/kube/config"
export GRADLE_USER_HOME="${XDG_DATA_HOME}/gradle"
export _ZO_DATA_DIR="$XDG_STATE_HOME/zoxide"

# HOMEBREW envs
if [[ ${OSTYPE} == *darwin* ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

## Private keys and stuff
# [ -f "${ZDOTDIR}"/.envprivate ] && source "${ZDOTDIR}"/.envprivate
