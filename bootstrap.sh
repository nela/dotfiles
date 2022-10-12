#!/bin/bash

error='\e[0;31m \e[1;91m%s\e[0m\n'
fix='\t\e[1;93m\e[0m  %s\n'
_warning='\e[0;33m \e[0;33m%s\e[0m\n'
_warning_fix="\e[0;33m \e[0;33m%s\e[0m\n\t\e[1;96m\e[0m  %s\n"
_error_fix="\e[0;31m \e[1;91m%s\e[0m\n\t\e[1;96m\e[0m  %s\n"

create_xdg_dirs() {
  mkdir -p "$XDG_DATA_HOME" \
    "$XDG_DATA_HOME" \
    "$XDG_CACHE_HOME" \
    "$XDG_CONFIG_HOME" \
    "$XDG_BIN_HOME" \
    "$XDG_LIB_HOME" \
    "$XDG_STATE_HOME" \
    "$XDG_REPO_HOME"
}

create_pnpm_dirs() {
  mkdir -p "$PNPM_STORE" \
    "$PNPM_GLOBAL" \
    "$PNPM_GLOBAL_BIN" \
    "$PNPM_STATE"
}

create_misc_dirs() {
  mkdir -p "$XDG_CACHE_HOME"/less \
    $XDG_DATA_HOME/zoxide \
    $XDG_DATA_HOME/tmux
}

_get_name_from_url() {
  echo "$1" | awk -F'[/.]' '{print $3}'
}

brew_install() {
  if [ ! command -v brew &> /dev/null ]; then
    printf $_error_fix "Brew not installed" "Do you want to install Homebrew?[y/n]"
    read _install_choice
    [ $_install_choice = "y" ] \
      && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      # || exit -1
  fi

  for var in "$@"; do
    brew install "$var"
  done
}

clone_repos() {
  if [ ! -d "$XDG_DATA_HOME" ]; then
    echo "\$XDG_DATA_HOME not defined or does not exist"
    exit -1
  elif [ ! -f $HOME/.ssh/id_rsa.pub ]; then
    echo "Generate SSH keys and add them to github before cloning repos"
    exit -1
  elif [ ! command -v git &> /dev/null ]; then
    echo "Git is not installed - unable to continue"
    exit -1
  fi

  local _repos=($1"[$@]")

  for cr in "${_repos[@]}"; do
    local _clonedir="$(_get_name_from_url $cr)"

    [ $_clonedir = "tpm" ] \
      && _clonedir="$XDG_DATA_HOME"/tmux/tpm \
      || _clonedir="$XDG_DATA_HOME"/"$_clonedir"

    [ $_clonedir = "asdf" ] \
      && _clone_arg="--branch v0.10.2"


    echo $cr
    echo $_clonedir
    # git clone --depth 1 $cr "$_clonedir"
  done
}

create_symlinks() {
  command -v stow &> /dev/null \
    || echo "Ensure stow is installed"

  ln -sf $HOME/dotfiles/tmux/tmux.conf $HOME/.tmux.conf
  ln -sf

  cd $HOME/dotfiles
  stow nvim
  stow alacritty
  stow bat
}

declare -a common_repos=(
  git@github.com:romkatv/zsh-defer.git
  git@github.com:wfxr/forgit.git
  git@github.com:zdharma-continuum/fast-syntax-highlighting.git
  git@github.com:tmux-plugins/tpm.git
  git@github.com:wbthomason/packer.nvim.git
)

declare -a linux_repos=(
  git@github.com:junegunn/fzf.git
  git@github.com:asdf-vm/asdf.git
)

declare -a brew_install=(
  fzf
  asdf
)

# create_xdg_dirs
# create_pnpm_dirs
# create_misc_dirs
clone_repos "${common_repos[@]}"
clone_repos "${linux_repos[@]}"
# create_symlinks
