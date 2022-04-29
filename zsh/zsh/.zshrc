###############################################################################
# General
###############################################################################

# Module to check zsh loading times
# zmodload zsh/zprof

export HISTFILE="$XDG_CACHE_HOME/zsh/histfile"
HISTSIZE=5000
SAVEHIST=5000

tabs 4
error='\e[0;31m \e[1;91m%s\e[0m\n'
fix='\t\e[1;93m\e[0m  %s\n'

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ -f /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme ]] \
  && source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme

# Zsh-defer
source $XDG_REPO_HOME/zsh-defer/zsh-defer.plugin.zsh

# Setup fzf
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
fi

# Auto-completion
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
source "/usr/local/opt/fzf/shell/key-bindings.zsh"

_autoloaded=${ZSH}/autoloaded
fpath=($_autoloaded $fpath)

if [[ -d "$_autoloaded" ]]; then
    for func in $_autoloaded/*; do
        autoload -Uz ${func:t}
    done
fi
unset _autoloaded

[[ -r /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] \
  && source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  || printf ${error} "Zsh autosuggestions not loaded"

_lib=${ZSH}/lib

if [[ -d "$_lib" ]]; then
   for file in $_lib/*.zsh; do
      source $file
   done
fi

type asdf &>/dev/null && source /usr/local/opt/asdf/libexec/asdf.sh \
  || printf ${error} "ASDF not installed"

[ -r ${HOME}/.asdf/plugins/java/set-java-home.zsh ] \
  && command -v asdf >/dev/null 2>&1 && [ -d ${HOME}/.asdf/installs/java ] \
  && zsh-defer source ${HOME}/.asdf/plugins/java/set-java-home.zsh \
  || { printf ${error} "ASDF plugin set-java-home not loaded";
  printf ${fix} "Check if asdf and asdf-managed java executables are installed" }

# [[ -r ${DOTS}/scripts/miniforge-init.sh ]] &&  command -v conda >/dev/null 2>&1  && source ${DOTS}/scripts/miniforge-init.sh

[ -r ${DOTS}/scripts/fzf.zsh ] && source ${DOTS}/scripts/fzf.zsh \
  || printf ${error} "FZF config not loaded"

[ -r ${XDG_REPO_HOME}/forgit/forgit.plugin.zsh ] \
  && zsh-defer source ${XDG_REPO_HOME}/forgit/forgit.plugin.zsh \
  || printf ${error} "Forgit not loaded"

[ -r ${XDG_REPO_HOME}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ] \
  && zsh-defer source ${XDG_REPO_HOME}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh \
  || printf ${error} "Fast Syntax Highlighting not loaded"

[ -r ${XDG_REPO_HOME}/dircolors/dircolors.ansi-dark ] \
  &&  eval $(gdircolors ${XDG_REPO_HOME}/dircolors/dircolors.ansi-dark) \
  || printf ${error} "Dircolors not loaded"

[ -x /usr/libexec/path_helper ] && zsh-defer eval "$(/usr/libexec/path_helper)"

unset error fix
