#!/bin/bash

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

  git clone --depth 1 git@github.com:romkatv/zsh-defer.git "$XDG_DATA_HOME"/zsh-defer
  git clone --depth 1 git@github.com:wfxr/forgit.git "$XDG_DATA_HOME"/forgit
  git clone --depth 1 git@github.com:zdharma-continuum/fast-syntax-highlighting.git "$XDG_DATA_HOME"/fast-syntax-highlight
  git clone --depth 1 git@github.com:tmux-plugins/tpm.git "$XDG_DATA_HOME"/tmux/tpm
  git clone --depth 1 git@github.com:wbthomason/packer.nvim.git "$XDG_DATA_HOME"/nvim/site/pack/packer/opt/packer.nvim

  if [[ `uname` == 'Darwin' ]]; then
    git clone --depth 1 git@github.com:junegunn/fzf.git "$XDG_DATA_HOME"/fzf
    git clone --depth 1 git@github.com:asdf-vm/asdf.git "$XDG_DATA_HOME"/asdf
  fi

  # repositories=("$@")

  # for r in "${repositories[@]}"
  # do
  #   if [[ "$r" == *tmux* ]]; then
  #     git clone --depth 1 "$r" "$XDG_DATA_HOME"/tmux/"$(_get_name_from_url $r)"
  #   elif [[ "$r" == **packer** ]]; then
  #     git clone --depth 1 "$r" "$XDG_DATA_HOME"/nvim/site/pack/packer/opt/packer.nvim
  #   elif [[ "$r" == *fzf*  ]] && [[ $OSTYPE != *darwin* ]]; then
  #     git clone --depth 1 "$r" "$XDG_DATA_HOME"/"$(_get_name_from_url $r)"
  #   elif [[ "$r" == *asdf*  ]] && [[ $OSTYPE != *darwin* ]]; then
  #     git clone --depth 1 "$r" "$XDG_DATA_HOME"/"$(_get_name_from_url $r)" --branch v0.10.2
  #   else
  #     git clone --depth 1 "$r" "$(_get_name_from_url $r)"
  #   fi
  # done
}

create_symlinks() {
  command -v stow &> /dev/null \
    || echo "Ensure stow is installed"

  ln -sf $HOME/dotfiles/tmux/tmux.conf $HOME/.tmux.conf

  cd $HOME/dotfiles
  stow nvim
  stow alacritty
  stow bat
}

repos=(
  git@github.com:romkatv/zsh-defer.git
  git@github.com:wfxr/forgit.git
  git@github.com:zdharma-continuum/fast-syntax-highlighting.git
  git@github.com:tmux-plugins/tpm.git
  git@github.com:junegunn/fzf.git
  git@github.com:asdf-vm/asdf.git
  git@github.com:wbthomason/packer.nvim.git
)

create_xdg_dirs
create_pnpm_dirs
create_misc_dirs
clone_repos 
# create_symlinks
