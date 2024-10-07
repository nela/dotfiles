###############################################################################
# General
###############################################################################

# Module to check zsh loading times
# zmodload zsh/zprof

export HISTFILE="${XDG_CACHE_HOME}/zsh/histfile"
HISTSIZE=5000
SAVEHIST=5000

tabs 4
error='\e[0;31m \e[1;91m%s\e[0m\n'
fix='\t\e[1;93m\e[0m  %s\n'
_warning='\e[0;33m \e[0;33m%s\e[0m\n'
_warning_fix="\e[0;33m \e[0;33m%s\e[0m\n\t\e[1;96m\e[0m  %s\n"
_error_fix="\e[0;31m \e[1;91m%s\e[0m\n\t\e[1;96m\e[0m  %s\n"

[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ] \
  && source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

local _p10k_dir="${XDG_DATA_HOME}"/zsh/powerlevel10k

[ -f "$_p10k_dir"/powerlevel10k.zsh-theme ] \
  && source "$_p10k_dir"/powerlevel10k.zsh-theme \
  || printf ${_warning_fix} "Powerlevel10k not found"

unset _p10k_dir

# Zsh-defer
[ -d "${XDG_DATA_HOME}"/zsh/zsh-defer ] \
  && source "${XDG_DATA_HOME}"/zsh/zsh-defer/zsh-defer.plugin.zsh \
  || printf ${_warning_fix} "Zsh-defer is not downloaded!" \
      "Download to \$XDG_DATA_HOME to improve zsh startup time"

[ -r "${DOTS}"/shells/aliases.sh ] \
  && zsh-defer source "${DOTS}"/shells/aliases.sh

local _fzf_dir

[[ ${SYSTEM} == *Darwin* ]] \
  && _fzf_dir="${BREW_PREFIX}"/fzf || _fzf_dir="${XDG_DATA_HOME}"/fzf

if [[ $_fzf_dir == *"${XDG_DATA_HOME}"* ]] && [ ! -L "${XDG_BIN_HOME}"/fzf ]; then
    ln -s "$_fzf_dir"/bin/fzf "${XDG_BIN_HOME}"/fzf
fi

[[ $- == *i* ]] && [ -r "$_fzf_dir"/shell/completion.zsh ] \
    && zsh-defer source "$_fzf_dir"/shell/completion.zsh 2> /dev/null

[ -r "$_fzf_dir"/shell/key-bindings.zsh ] \
    && zsh-defer source "$_fzf_dir"/shell/key-bindings.zsh

unset _fzf_dir

local _autosuggestion_dir

[[ "${SYSTEM}" == *Darwin* ]] \
   &&  _autosuggestion_dir=/usr/local/share/zsh-autosuggestions \
   ||  _autosuggestion_dir="${XDG_DATA_HOME}"/zsh/zsh-autosuggestions

[ -r "$_autosuggestion_dir"/zsh-autosuggestions.zsh ] \
  && zsh-defer source "${_autosuggestion_dir}"/zsh-autosuggestions.zsh \
  || printf ${error} "Zsh autosuggestions not loaded"

unset _autosuggestion_dir

local _asdf_dir

if [[ "${SYSTEM}" == *Linux* ]] && [ -d ${ASDF_DIR} ]; then
  fpath=("${ASDF_DIR}"/completions $fpath) \
fi

# zsh-defer
source "${ASDF_DIR}"/asdf.sh \
  || printf ${_error_fix} "Sourcing ASDF init script failed" "Check \$ASDF_DIR paths"

# elif [[ "$SYSTEM" == *Darwin* ]]; then
#   zsh-defer source /usr/local/opt/asdf/libexec/asdf.sh \
#     || printf ${_error_fix} "Sourcing ASDF init script failed" "Check \$ASDF_DIR paths"
# fi


if [ -d "${ASDF_DATA_DIR}"/plugins/java ]; then
  [ -r "${ASDF_DATA_DIR}"/plugins/java/set-java-home.zsh ] \
    && zsh-defer source "${ASDF_DATA_DIR}"/plugins/java/set-java-home.zsh \
    || printf ${_warning_fix} "ASDF plugin set-java-home not loaded" \
        "Check \$ASDF_DATA_DIR path, plugins and other installations paths."
fi

[ -r "${DOTS}"/shells/fzf.sh ] && zsh-defer source ${DOTS}/shells/fzf.sh \
  || printf ${error} "FZF config not loaded"

local _forgit_dir

if [[ ${SYSTEM} == *Darwin* ]]; then
  _forgit_dir="${BREW_PREFIX}"/forgit/share/forgit
else
  _forgit_dir="${XDG_DATA_HOME}"/zsh/forgit
fi

[ -f "$_forgit_dir"/forgit.plugin.zsh ] \
  &&  zsh-defer source "$_forgit_dir"/forgit.plugin.zsh \
  || printf ${error} "Forgit not loaded"

unset _forgit_dir

[ -r "${XDG_DATA_HOME}"/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ] \
  && zsh-defer source "${XDG_DATA_HOME}"/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh \
  || printf ${error} "Fast Syntax Highlighting not loaded"

[ ! -d "${PNPM_HOME}" ] && mkdir -p "${PNPM_HOME}"
[ ! -d "${PNPM_GLOBAL}" ] && mkdir -p "${PNPM_GLOBAL}"
[ ! -d "${PNPM_GLOBAL_BIN}" ] && mkdir -p "${PNPM_GLOBAL_BIN}"
# [ ! -d "${PNPM_STATE}" ] && mkdir -p "${PNPM_STATE}"
# [ ! -d "${PNPM_CACHE}" ] && mkdir -p "${PNPM_CACHE}"

# [ -x /usr/libexec/path_helper ] && zsh-defer eval "$(/usr/libexec/path_helper)"

(( $+commands[zoxide] ))                                                                \
  && zsh-defer eval "$(zoxide init zsh)"                                                \
  || printf ${_warning_fix} "Zoxide not installed." "Use packet manager to install it"

_autoloaded="${ZSH}"/autoloaded
fpath=($_autoloaded $fpath)

if [[ -d "$_autoloaded" ]]; then
    for func in $_autoloaded/*; do
        autoload -Uz ${func:t}
    done
fi
unset _autoloaded

local _lib="${ZSH}"/lib

if [[ -d "$_lib" ]]; then
   for file in $_lib/*.zsh; do
      source $file
   done
fi

unset _lib

[ -f "${DOTS}"/private ] && source "${DOTS}"/private

unset error     \
  fix           \
  _warning      \
  _warning_fix  \
  _error_fix
