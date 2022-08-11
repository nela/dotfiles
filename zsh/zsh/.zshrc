###############################################################################
# General
###############################################################################

# Module to check zsh loading times
# zmodload zsh/zprof

# alias ls="gls --color=auto"
export HISTFILE="$XDG_CACHE_HOME/zsh/histfile"
HISTSIZE=5000
SAVEHIST=5000

tabs 4
error='\e[0;31m \e[1;91m%s\e[0m\n'
fix='\t\e[1;93m\e[0m  %s\n'

# Zsh-defer
source "$XDG_REPO_HOME"/zsh-defer/zsh-defer.plugin.zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ -f /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme ]] \
  && source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme

[[ -f "$XDG_REPO_HOME"/powerlevel10k/powerlevel10k.zsh-theme ]] \
  && source "$XDG_REPO_HOME"/powerlevel10k/powerlevel10k.zsh-theme

local _fzf_dir

if [ -d /usr/local/opt/fzf ]; then
    _fzf_dir=/usr/local/opt/fzf
elif [ -d "$XDG_REPO_HOME"/fzf ]; then
    _fzf_dir="$XDG_REPO_HOME"/fzf
fi

[ -L $HOME/.local/bin/fzf ] \
    || ln -s "$_fzf_dir"/bin/fzf "$HOME"/.local/bin/fzf

[[ $- == *i* ]] && [ -r "$_fzf_dir"/shell/completion.zsh ] \
    && zsh-defer source "$_fzf_dir"/shell/completion.zsh 2> /dev/null

[ -r "$_fzf_dir"/shell/key-bindings.zsh ] \
    && zsh-defer source "$_fzf_dir"/shell/key-bindings.zsh

unset _fzf_dir

# Setup fzf
# if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
#   export PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
# fi
# 
# # Auto-completion
# [[ $- == *i* ]] && zsh-defer source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null
# 
# # Key bindings
# zsh-defer source "/usr/local/opt/fzf/shell/key-bindings.zsh"


# [ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh

_autoloaded=${ZSH}/autoloaded
fpath=($_autoloaded $fpath)

if [[ -d "$_autoloaded" ]]; then
    for func in $_autoloaded/*; do
        autoload -Uz ${func:t}
    done
fi
unset _autoloaded

local _autosuggestion

[[ "$OSTYPE" == *"linux"* ]] \
    && _autosuggestion="$XDG_REPO_HOME"/zsh-autosuggestions \
    || _autosuggestion=/usr/local/share/zsh-autosuggestions

[ -r "$_autosuggestion"/zsh-autosuggestions.zsh ] \
  && zsh-defer source "${_autosuggestion}"/zsh-autosuggestions.zsh \
  || printf ${error} "Zsh autosuggestions not loaded"

unset _autosuggestion

# [ -r /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] \
#   && zsh-defer source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
#   || printf ${error} "Zsh autosuggestions not loaded"

_lib="$ZSH"/lib

if [[ -d "$_lib" ]]; then
   for file in $_lib/*.zsh; do
      source $file
   done
fi
unset _lib

type asdf &>/dev/null || zsh-defer source "$ASDF_DIR"/asdf.sh \
  || printf ${error} "ASDF not installed"

[ -r "$ASDF_DATA_DIR"/plugins/java/set-java-home.zsh ] \
  && command -v asdf >/dev/null 2>&1 && [ -d "$ASDF_DATA_DIR"/installs/java ] \
  && zsh-defer source "$ASDF_DATA_DIR"/plugins/java/set-java-home.zsh \
  || { printf ${error} "ASDF plugin set-java-home not loaded";
  printf ${fix} "Check if asdf and asdf-managed java executables are installed" }

# [[ -r ${DOTS}/scripts/miniforge-init.sh ]] &&  command -v conda >/dev/null 2>&1  && source ${DOTS}/scripts/miniforge-init.sh

# [ -r ${DOTS}/scripts/fzf.zsh ] && source ${DOTS}/scripts/fzf.zsh \
[ -r "$DOTS"/shell-common/fzf.sh ] && zsh-defer source ${DOTS}/shell-common/fzf.sh \
  || printf ${error} "FZF config not loaded"

[ -r ${XDG_REPO_HOME}/forgit/forgit.plugin.zsh ] \
  && zsh-defer source ${XDG_REPO_HOME}/forgit/forgit.plugin.zsh \
  || printf ${error} "Forgit not loaded"

[ -r ${XDG_REPO_HOME}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ] \
  && zsh-defer source ${XDG_REPO_HOME}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh \
  || printf ${error} "Fast Syntax Highlighting not loaded"

[ -r "$DOTS"/shell-common/aliases.sh ] \
  && zsh-defer source "$DOTS"/shell-common/aliases.sh

# [ -r ${XDG_REPO_HOME}/dircolors/dircolors.ansi-dark ] \
#   &&  zsh-defer eval $(gdircolors ${XDG_REPO_HOME}/dircolors/dircolors.ansi-dark) \
#   || printf ${error} "Dircolors not loaded"

[ -x /usr/libexec/path_helper ] && zsh-defer eval "$(/usr/libexec/path_helper)"

unset error fix
