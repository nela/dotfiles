###############################################################################
# General
###############################################################################

# Spelling correction
setopt CORRECT
# Change directory to a path stored in a variable.
setopt CDABLE_VARS
# Use extended globbing syntax.
setopt EXTENDED_GLOB

###############################################################################
# History
###############################################################################
[ -z ${HISTFILE} ] && HISTFILE=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/histfile
HISTSIZE=1000
SAVEHIST=1000

# Write the history file in the ':start:elapsed;command' format.
setopt EXTENDED_HISTORY
## Share history between all sessions.
setopt SHARE_HISTORY
# Expire a duplicate event first when trimming history.
setopt HIST_EXPIRE_DUPS_FIRST
# Do not record an event that was just recorded again.
setopt HIST_IGNORE_DUPS
# Delete an old recorded event if a new event is a duplicate.
setopt HIST_IGNORE_ALL_DUPS
# Do not display a previously found event.
setopt HIST_FIND_NO_DUPS
# Do not record an event starting with a space.
setopt HIST_IGNORE_SPACE
# Do not write a duplicate event to the history file.
setopt HIST_SAVE_NO_DUPS
# Do not execute immediately upon history expansion.
setopt HIST_VERIFY

###############################################################################
# Navigation
###############################################################################

# Go to folder path without using cd. F.ex: '~' evaluates to 'cd ~'
setopt AUTO_CD
# Push the old directory onto the stack on cd.
setopt AUTO_PUSHD
# Do not store duplicates in the stack.
setopt PUSHD_IGNORE_DUPS
# Do not print the directory stack after pushd or popd.
# setopt PUSHD_SILENT

# Immidiately tells when a backgroundjob exits
# setopt notify

# Emacs key binding, use -v for vim mode,
# then export KEYTIMEOUT=1 for faster switching between modes
bindkey -e

# Load Plugins
source "${HOME}"/.zsh_plugins

# Override colors
# eval "$(dircolors -b $ZDOTDIR/dircolors)"

# [ -d "${HOME}/.zsh-themes" ] && fpath=($HOME/.zsh-themes $fpath)

if [ -r "${HOME}/.zsh-themes/pure/pure.zsh" ]; then
  source "${HOME}/.zsh-themes/pure/async.zsh"
  source "${HOME}/.zsh-themes/pure/pure.zsh"
fi

# fpath=( "$HOME/.zsh-themes" $fpath)
fpath=("${HOME}/.zsh-completion-sources" $fpath)
# source "${HOME}/.zsh-themes/purity.zsh"
# autoload -U promptinit && promptinit
# prompt purity

# && autoload -Uz "${HOME}/.zsh-themes/common.zsh-theme" \

# Source completion if it exists
[[ -r "${HOME}/.zsh_completion" ]] && source "${HOME}/.zsh_completion" || \

# $ sudo apt install command-not-found
# $ echo "source /etc/zsh_command_not_found" >> ~/.zshrc
# $ exec zsh
