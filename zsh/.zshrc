export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.local/cache"
export XDG_CONFIG_HOME="$HOME/.config"
export DOTFILES="$HOME/.dotfiles"
export NVIM_CONFIG_HOME="$DOTFILES/nvim/.config/nvim"
export ZSH_HOME="$DOTFILES/zsh"
export ZSHRC="$ZSH_HOME/.zshrc"
export PATH="/usr/local/sbin:$PATH"

export NPM_CONFIG_PREFIX="$HOME/.npm-global"
export PATH="$HOME/.npm-global/bin:$PATH"

export PATH="$HOME/.local/bin:$PATH"

export LANG_SERVERS="$XDG_DATA_HOME/lang-servers/"

# export TERM=xterm-256color

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $DOTFILES/scripts/.p10k.zsh ]] || source $DOTFILES/scripts/.p10k.zsh

source $DOTFILES/scripts/zsh-newuser-install.sh
source $DOTFILES/scripts/compinstall.sh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $DOTFILES/scripts/zsh-completions.sh
source $DOTFILES/scripts/todo-init.sh
source $DOTFILES/scripts/aliases.sh
source $DOTFILES/scripts/locale.sh
source $DOTFILES/scripts/asdf-pyvirtual-envs.sh
source $DOTFILES/scripts/miniforge-init.sh
source $DOTFILES/fzf/fzf.zsh
source $HOME/.asdf/plugins/java/set-java-home.zsh


alias luamake=/Users/nela/.local/share/lang-servers/lua-language-servers/3rd/luamake/luamake
