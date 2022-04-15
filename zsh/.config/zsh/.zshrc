###############################################################################
# General
###############################################################################

zmodload zsh/zprof

# Spelling correction
setopt CORRECT
# Change directory to a path stored in a variable.
setopt CDABLE_VARS
# Use extended globbing syntax.
setopt EXTENDED_GLOB

###############################################################################
# History
###############################################################################
# [ -z ${HISTFILE} ] && HISTFILE=${XDG_DATA_HOME:-$HOME/.cache}/zsh/histfile
export HISTFILE="$XDG_CACHE_HOME/zsh/histfile"
# [ -d "${HISTFILE}" ] || mkdir -p ${HISTFILE}
HISTSIZE=5000
SAVEHIST=5000

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

# Immediately tells when a backgroundjob exits
# setopt notify

# Emacs key binding, use -v for vim mode,
# then export KEYTIMEOUT=1 for faster switching between modes
# bindkey -e

source "${ZSH}/zsh_completion.zsh"
source "${ZSH}/zsh_plugins.zsh"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ -f /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme ]] \
  && source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme

tabs 4
error='\e[0;31m \e[1;91m%s\e[0m\n'
fix='\t\e[1;93m\e[0m  %s\n'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -r ${ZSH}/p10k-custom.zsh ]] && source ${ZSH}/p10k-custom.zsh \
  || printf '\e[1;31m%s\e[0m\n' "Custom p10k theme not loaded"

# [[ -r ${ZSH}/zsh-user.conf ]] && source ${ZSH}/zsh-user.conf \
#   || printf '\e[1;31m%s\e[0m\n' "Zsh user config not loaded"

# [[ -f ${DOTS}/scripts/compinstall.sh ]] \
#   && source ${DOTS}/scripts/compinstall.sh \
#   || printf '\e[1;31m%s\e[0m\n' "Compinstall not loaded."

[[ -r /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] \
  && source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  || printf ${error} "Zsh Autosuggestions not loaded"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=247'

[[ -r ${ZSH}/zsh-autosuggestions.conf ]] && source ${ZSH}/zsh-autosuggestions.conf \
  || printf ${error} "Zsh Autosuggestions config not loaded"

# [[ -r ${ZSH}/zsh-completion.sh ]] && source ${ZSH}/zsh-completion.sh \
#   || printf ${error} "Zsh Completions not loaded"

# [[ -r ${DOTS}/scripts/todo-init.sh ]] || source ${DOTS}/scripts/todo-init.sh
[[ -r ${DOTS}/scripts/aliases.sh ]] && source ${DOTS}/scripts/aliases.sh \
 || printf ${error} "Aliases not loaded"

[[ -r ${DOTS}/scripts/locale.sh ]] && source ${DOTS}/scripts/locale.sh \
  || printf ${error} "Locale not loaded"

type asdf &>/dev/null && source /usr/local/opt/asdf/libexec/asdf.sh \
  || printf ${error} "ASDF not installed"

[[ -r ${HOME}/.asdf/plugins/java/set-java-home.zsh ]] \
  && command -v asdf >/dev/null 2>&1 && [[ -d ${HOME}/.asdf/installs/java ]] \
  && source ${HOME}/.asdf/plugins/java/set-java-home.zsh \
  || { printf ${error} "ASDF plugin set-java-home not loaded";
  printf ${fix} "Check if asdf and asdf-managed java executables are installed" }

[[ -r ${DOTS}/asdf/asdf-pyvirtual-envs.sh ]] \
  && type asdf &>/dev/null && source ${DOTS}/asdf/asdf-pyvirtual-envs.sh \
  || { printf ${error} "ASDF python virtualenv management scripts not loaded";
  printf ${fix} "Check if asdf is installed, or script is available" }

# [[ -r ${DOTS}/scripts/miniforge-init.sh ]] &&  command -v conda >/dev/null 2>&1  && source ${DOTS}/scripts/miniforge-init.sh
[[ -r ${DOTS}/scripts/fzf.zsh ]] && source ${DOTS}/scripts/fzf.zsh \
  || printf ${error} "FZF config not loaded"

[[ -r ${REPOS}/forgit/forgit.plugin.zsh ]] && source ${REPOS}/forgit/forgit.plugin.zsh \
  || printf ${error} "Forgit not loaded"

[[ -r ${REPOS}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]] \
  && source ${REPOS}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh \
  || printf ${error} "Fast Syntax Highlighting not loaded"

[[ -r ${REPOS}/dircolors/dircolors.ansi-dark ]] \
  && { eval $(gdircolors ${REPOS}/dircolors/dircolors.ansi-dark); alias ls="gls --color=auto" } \
  || printf ${error} "Dircolors not loaded"

source ${DOTS}/tmux/tmux-scripts.sh

alias ll="ls -al"
