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


## Powerlevel10k
[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ] \
  && source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

local _p10k_dir

if [ -d /usr/share/zsh-theme-powerlevel10k ]; then
  _p10k_dir=/usr/share/zsh-theme-powerlevel10k
elif [ -d "${XDG_DATA_HOME}"/zsh/powerlevel10k ]; then
  _p10k_dir="${XDG_DATA_HOME}"/zsh/powerlevel10k
elif [ -d "${HOMEBREW_PREFIX}"/share/powerlevel10k ]; then
  _p10k_dir="${HOMEBREW_PREFIX}"/share/powerlevel10k
fi

[ -r "$_p10k_dir"/powerlevel10k.zsh-theme ] \
  && source "$_p10k_dir"/powerlevel10k.zsh-theme \
  || printf ${_warning_fix} "Powerlevel10k not found."

[[ -r "${DOTS}"/zsh/theme/.p10k.zsh ]] && source "${DOTS}"/zsh/theme/.p10k.zsh

[[ -r "${DOTS}"/zsh/theme/p10k.gruv.zsh ]] && source "${DOTS}"/zsh/theme/p10k.gruv.zsh \
  || printf ${_warning_fix} "Powelevel10K gruvbox colors script not found"

unset _p10k_dir

## Zsh-defer
local _zsh_defer_dir
if [ -d "${XDG_DATA_HOME}"/zsh/zsh-defer ]; then
  _zsh_defer_dir="${XDG_DATA_HOME}"/zsh/zsh-defer
elif [ -d /usr/share/zsh/plugins/zsh-defer ]; then
  _zsh_defer_dir=/usr/share/zsh/plugins/zsh-defer
fi

[ -r "$_zsh_defer_dir"/zsh-defer.plugin.zsh ] && source "$_zsh_defer_dir"/zsh-defer.plugin.zsh \
  || printf ${_warning_fix} "Zsh-defer not found"

unset _zsh_defer_dir


## Aliases
[ -r "${DOTS}"/shells/aliases.sh ] && zsh-defer source "${DOTS}"/shells/aliases.sh \
  || printf ${_error_fix} "Unable to source local aliases"

## Zsh-vi-Mode
local _zsh_vi_mode_dir
if [ -d "${HOMEBREW_PREFIX}"/opt/zsh-vi-mode ]; then
  _zsh_vi_mode_dir="${HOMEBREW_PREFIX}"/opt/zsh-vi-mode/share
fi

zsh-defer source "${_zsh_vi_mode_dir}"/zsh-vi-mode/zsh-vi-mode.plugin.zsh \
  || printf ${error} "Zsh Vi Mode not loaded"

unset _zsh_vi_mode_dir

## FZF
local _fzf_dir

if [[ -d "${HOMEBREW_PREFIX}"/opt/fzf ]]; then
  _fzf_dir="${HOMEBREW_PREFIX}"/opt/fzf/shell
elif [[ -d "${XDG_DATA_HOME}"/opt/fzf ]]; then
  _fzf_dir="${XDG_DATA_HOME}"/opt/fzf/shell
elif [[ -d /usr/share/fzf ]]; then
  _fzf_dir=/usr/share/fzf
fi

[[ $- == *i* ]] && [ -r "$_fzf_dir"/completion.zsh ] \
    && zsh-defer source "$_fzf_dir"/completion.zsh 2> /dev/null

[ -r "$_fzf_dir"/key-bindings.zsh ] \
    && zsh-defer source "$_fzf_dir"/key-bindings.zsh

(( $+commands[fzf] )) || ln -s "$_fzf_dir"/bin/fzf "${XDG_BIN_HOME}"/fzf

unset _fzf_dir

## Zsh autosugestion
# local _autosuggestion_dir
#
# [[ "${SYSTEM}" == *Darwin* ]] \
#    &&  _autosuggestion_dir=/usr/local/share/zsh-autosuggestions \
#    ||  _autosuggestion_dir="${XDG_DATA_HOME}"/zsh/zsh-autosuggestions
#
# [ -r "$_autosuggestion_dir"/zsh-autosuggestions.zsh ] \
#   && zsh-defer source "${_autosuggestion_dir}"/zsh-autosuggestions.zsh \
#   || printf ${error} "Zsh autosuggestions not loaded"
#
# unset _autosuggestion_dir

local _asdf_dir

if [ -d "${XDG_DATA_HOME}"/asdf/source ]; then
  [ -d "${ASDF_DIR}" ] && fpath=("${ASDF_DIR}"/completions $fpath)
  _asdf_dir="${ASDF_DIR}"
elif [ -d "${HOMEBREW_PREFIX}"/asdf/libexec ]; then
  _asdf_dir="${HOMEBREW_PREFIX}"/asdf/libexec
fi

zsh-defer source "${_asdf_dir}"/asdf.sh \
  || printf ${_error_fix} "Sourcing ASDF init script failed" "Check \$ASDF_DIR paths"


# if [ -d "${ASDF_DATA_DIR}"/plugins/java ]; then
#   [ -r "${ASDF_DATA_DIR}"/plugins/java/set-java-home.zsh ] \
#     && zsh-defer source "${ASDF_DATA_DIR}"/plugins/java/set-java-home.zsh \
#     || printf ${_warning_fix} "ASDF plugin set-java-home not loaded" \
#         "Check \$ASDF_DATA_DIR path, plugins and other installations paths."
# fi

unset _asdf_dir

[ -r "${DOTS}"/shells/fzf.sh ] && zsh-defer source ${DOTS}/shells/fzf.sh \
  || printf ${error} "FZF config not loaded"


local uname_str=$(uname -r | tr '[:upper:]' '[:lower:]')

if [ -d "${XDG_DATA_HOME}"/zsh/forgit ]; then
  _forgit_dir="${XDG_DATA_HOME}"/zsh/forgit
elif [ -d "${HOMEBREW_PREFIX}"/share/forgit ]; then
  _forgit_dir="${HOMEBREW_PREFIX}"/share/forgit
elif [[ $uname_str == *arch* || $uname_str == *zen* ]]; then
  _forgit_dir=/usr/share/zsh/plugins/forgit
fi

[ -r "$_forgit_dir"/forgit.plugin.zsh ] \
  &&  zsh-defer source "$_forgit_dir"/forgit.plugin.zsh \
  || printf ${error} "Forgit not loaded"

unset _forgit_dir

## FAst syntax highlight
local _fs_highlight_dir
if [ -d "${XDG_DATA_HOME}"/zsh/fast-syntax-highlighting ]; then
  _fs_highlight_dir="${XDG_DATA_HOME}"/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
elif [ -d /usr/share/zsh/plugins/fast-syntax-highlighting ]; then
  _fs_highlight_dir=/usr/share/zsh/plugins/fast-syntax-highlighting
elif [ -d "${HOMEBREW_PREFIX}"/share/zsh-fast-syntax-highlighting ]; then
  _fs_highlight_dir="${HOMEBREW_PREFIX}"/share/zsh-fast-syntax-highlighting
fi

[ -r "$_fs_highlight_dir"/fast-syntax-highlighting.plugin.zsh ] \
  && zsh-defer source "$_fs_highlight_dir"/fast-syntax-highlighting.plugin.zsh \
  || printf ${error} "Fast Syntax Highlighting not loaded"

unset _fs_highlight_dir

# TODO move to ansible
[ ! -d "${PNPM_HOME}" ] && mkdir -p "${PNPM_HOME}"
[ ! -d "${PNPM_GLOBAL}" ] && mkdir -p "${PNPM_GLOBAL}"
[ ! -d "${PNPM_GLOBAL_BIN}" ] && mkdir -p "${PNPM_GLOBAL_BIN}"
# [ ! -d "${PNPM_STATE}" ] && mkdir -p "${PNPM_STATE}"
# [ ! -d "${PNPM_CACHE}" ] && mkdir -p "${PNPM_CACHE}"

# [ -x /usr/libexec/path_helper ] && zsh-defer eval "$(/usr/libexec/path_helper)"

(( $+commands[zoxide] )) \
  && zsh-defer eval "$(zoxide init zsh)" \
  || printf ${_warning_fix} "Zoxide not installed." "Use package manager to install it"

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

# [ -f "${DOTS}"/private ] && source "${DOTS}"/private

unset error     \
  fix           \
  _warning      \
  _warning_fix  \
  _error_fix
