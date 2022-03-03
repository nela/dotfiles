export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CACHE_HOME="${HOME}/.local/cache"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_BIN_HOME="${HOME}/.local/bin"
export XDG_LIB_HOME="${HOME}/.local/lib"
export XDG_STATE_HOME="${HOME}/.local/state"

export DOTS="${HOME}/dotfiles"
export NVIM="${DOTS}/nvim/.config/nvim"
export ZSH="${DOTS}/zsh"
export ZSHRC="${ZSH}/.zshrc"
export REPOS="${HOME}/.repos"
# export LANG_SERVERS="${XDG_DATA_HOME}/lang-servers/"
export NELAPYS="${XDG_DATA_HOME}/nelapys"
export EDITOR="nvim"

export PNPM_STORE="${XDG_LIB_HOME}/pnpm-store"
export PNPM_GLOBAL="${XDG_LIB_HOME}/pnpm-global"
export PNPM_GLOBAL_BIN="${XDG_BIN_HOME}/pnpm-global"
export PNPM_STATE="${XDG_DATA_HOME}/pnpm-state"

[[ ":${PATH}:" != *":/usr/local/bin:"* ]] && export PATH="/usr/local/bin:${PATH}"
[[ ":${PATH}:" != *":/usr/local/sbin:"* ]] && export PATH="/usr/local/sbin:${PATH}"
[[ ":${PATH}:" != *":${XDG_BIN_HOME}:"* ]] && export PATH="${XDG_BIN_HOME}:${PATH}"
[[ ":${PATH}:" != *":${PNPM_GLOBAL_BIN}:"* ]] && export PATH="${PNPM_GLOBAL_BIN}:${PATH}"

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

[[ -r ${ZSH}/zsh-user.conf ]] && source ${ZSH}/zsh-user.conf \
  || printf '\e[1;31m%s\e[0m\n' "Zsh user config not loaded"

# [[ -f ${DOTS}/scripts/compinstall.sh ]] \
#   && source ${DOTS}/scripts/compinstall.sh \
#   || printf '\e[1;31m%s\e[0m\n' "Compinstall not loaded."

[[ -r /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] \
  && source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  || printf ${error} "Zsh Autosuggestions not loaded"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=247'

[[ -r ${ZSH}/zsh-autosuggestions.conf ]] && source ${ZSH}/zsh-autosuggestions.conf \
  || printf ${error} "Zsh Autosuggestions config not loaded"

[[ -r ${ZSH}/zsh-completion.sh ]] && source ${ZSH}/zsh-completion.sh \
  || printf ${error} "Zsh Completions not loaded"

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
