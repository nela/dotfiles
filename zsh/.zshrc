export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CACHE_HOME="${HOME}/.local/cache"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_BIN_HOME="${HOME}/.local/bin"
export XDG_LIB_HOME="${HOME}/.local/lib"

export DOTS="${HOME}/DOTS"
export NVIM="${DOTS}/nvim/.config/nvim"
export ZSH="${DOTS}/zsh"
export ZSHRC="${ZSH}/.zshrc"
export LANG_SERVERS="${XDG_DATA_HOME}/lang-servers/"
export NELAPYS="${XDG_DATA_HOME}/nelapys"

export PNPM_STORE="${XDG_LIB_HOME}/pnpm-store"
export PNPM_GLOBAL="${XDG_LIB_HOME}/pnpm-global"
export PNPM_GLOBAL_BIN="${XDG_BIN_HOME}/pnpm-global"
export PNPM_STATE="${XDG_DATA_HOME}/pnpm-state"

[[ ":${PATH}:" != *":/usr/local/bin:"* ]] && export PATH="/usr/local/bin:${PATH}"
[[ ":${PATH}:" != *":${XDG_BIN_HOME}:"* ]] && export PATH="${XDG_BIN_HOME}:${PATH}"
[[ ":${PATH}:" != *":${PNPM_GLOBAL_BIN}:"* ]] && export PATH="${PNPM_GLOBAL_BIN}:${PATH}"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ${DOTS}/scripts/.p10k.zsh ]] || source ${DOTS}/scripts/.p10k.zsh

source ${DOTS}/scripts/zsh-newuser-install.sh
source ${DOTS}/scripts/compinstall.sh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source ${DOTS}/scripts/zsh-completions.sh
source ${DOTS}/scripts/todo-init.sh
source ${DOTS}/scripts/aliases.sh
source ${DOTS}/scripts/locale.sh
source ${DOTS}/scripts/asdf-pyvirtual-envs.sh
source ${DOTS}/scripts/miniforge-init.sh
source ${DOTS}/fzf/fzf.zsh
source ${HOME}/.asdf/plugins/java/set-java-home.zsh


# alias luamake=/Users/nela/.local/share/lang-servers/lua-language-servers/3rd/luamake/luamake
