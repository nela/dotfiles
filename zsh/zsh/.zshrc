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
_warning='\e[0;33m \e[0;33m%s\e[0m\n'
_warning_fix="\e[0;33m \e[0;33m%s\e[0m\n\t\e[1;96m\e[0m  %s\n"
_error_fix="\e[0;31m \e[1;91m%s\e[0m\n\t\e[1;96m\e[0m  %s\n"

_autoloaded="$ZSH"/autoloaded
fpath=($_autoloaded $fpath)
if [[ -d "$_autoloaded" ]]; then
    for func in $_autoloaded/*; do
        autoload -Uz ${func:t}
    done
fi
unset _autoloaded

local _lib="$ZSH"/lib
if [[ -d "$_lib" ]]; then
   for file in $_lib/*.zsh; do
      source $file
   done
fi
unset _lib

[ -f "$DOTS"/private ] && source "$DOTS"/private

[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ] \
  && source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

local _p10k_dir

[[ $SYSTEM == *Darwin* ]] \
  && _p10k_dir="$BREW_PREFIX"/powerlevel10k || _p10k_dir="$XDG_REPO_HOME"/powerlevel10k

[ -f "$_p10k_dir"/powerlevel10k.zsh-theme ] \
  && source "$_p10k_dir"/powerlevel10k.zsh-theme
unset _p10k_dir

# Zsh-defer
[ -d "$XDG_REPO_HOME"/zsh-defer ] \
  && source "$XDG_REPO_HOME"/zsh-defer/zsh-defer.plugin.zsh \
  || printf ${_warning_fix} "Zsh-defer is not downloaded!" \
      "Download to \$XDG_REPO_HOME to improve zsh startup time"


local _fzf_dir

[[ $SYSTEM == *Darwin* ]] \
  && _fzf_dir="$BREW_PREFIX"/fzf || _fzf_dir="$XDG_REPO_HOME"/fzf

[[ $_fzf_dir == *"$XDG_REPO_HOME"* ]] && [ -L "$XDG_BIN_HOME"/fzf ] \
    || ln -s "$_fzf_dir"/bin/fzf "$HOME"/.local/bin/fzf

[[ $- == *i* ]] && [ -r "$_fzf_dir"/shell/completion.zsh ] \
    && zsh-defer source "$_fzf_dir"/shell/completion.zsh 2> /dev/null

[ -r "$_fzf_dir"/shell/key-bindings.zsh ] \
    && zsh-defer source "$_fzf_dir"/shell/key-bindings.zsh

unset _fzf_dir

local _autosuggestion_dir
[[ "$SYSTEM" == *Darwin* ]] \
   &&  _autosuggestion_dir=/usr/local/share/zsh-autosuggestions \
   ||  _autosuggestion_dir="$XDG_REPO_HOME"/zsh-autosuggestions

[ -r "$_autosuggestion_dir"/zsh-autosuggestions.zsh ] \
  && zsh-defer source "${_autosuggestion_dir}"/zsh-autosuggestions.zsh \
  || printf ${error} "Zsh autosuggestions not loaded"
unset _autosuggestion_dir

local _asdf_dir

# (( $+commands[asdf] )) && [ -d $ASDF_DIR ] \
#   || printf ${error} "ASDF not installed"

# if [[ `uname` == *Linux* ]] && [ -d $ASDF_DIR ]; then
#   fpath=($ASDF_DIR/completions $fpath)
#   zsh-defer source $ASDF_DIR/asdf.sh
#   printf ${error} "Sourcing ASDF init script failed";
#   printf ${fix} "Check \$ASDF_DIR paths"
# fi


if [[ "$SYSTEM" == *Linux* ]] && [ -d $ASDF_DIR ]; then
  fpath=($ASDF_DIR/completions $fpath) \
  zsh-defer source $ASDF_DIR/asdf.sh
  [ $? -eq 0 ] ||
    printf ${_error_fix} "Sourcing ASDF init script failed" "Check \$ASDF_DIR paths"
fi

if [ -d "$ASDF_DATA_DIR"/plugins/java ]; then
  [ -r "$ASDF_DATA_DIR"/plugins/java/set-java-home.zsh ] \
    && zsh-defer source "$ASDF_DATA_DIR"/plugins/java/set-java-home.zsh \
    || printf ${_warning_fix} "ASDF plugin set-java-home not loaded" \
        "Check \$ASDF_DATA_DIR path, plugins and other installations paths."
fi

# [ -r "$ASDF_DATA_DIR"/plugins/java/set-java-home.zsh ] \
#   && zsh-defer source "$ASDF_DATA_DIR"/plugins/java/set-java-home.zsh \

[ -r "$DOTS"/shells/fzf.sh ] && zsh-defer source ${DOTS}/shells/fzf.sh \
  || printf ${error} "FZF config not loaded"

[ -r "$XDG_REPO_HOME"/forgit/forgit.plugin.zsh ] \
  && zsh-defer source "$XDG_REPO_HOME"/forgit/forgit.plugin.zsh \
  || printf ${error} "Forgit not loaded"

[ -r "$XDG_REPO_HOME"/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ] \
  && zsh-defer source "$XDG_REPO_HOME"/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh \
  # || printf ${error} "Fast Syntax Highlighting not loaded"

[ -r "$DOTS"/shells/aliases.sh ] \
  && zsh-defer source "$DOTS"/shells/aliases.sh

# [ -r "$XDG_REPO_HOME"/dircolors/dircolors.ansi-dark ] \
#   &&  zsh-defer eval $(gdircolors ${XDG_REPO_HOME}/dircolors/dircolors.ansi-dark) \
#   || printf ${error} "Dircolors not loaded"

[ -x /usr/libexec/path_helper ] && zsh-defer eval "$(/usr/libexec/path_helper)"

(( $+commands[zoxide] )) && zsh-defer eval "$(zoxide init zsh)"


unset error fix
