# Developed by article https://htr3n.github.io/2018/07/faster-zsh/
# Authors repo: https://github.com/htr3n/zsh-config

# https://blog.patshead.com/2011/04/improve-your-oh-my-zsh-startup-time-maybe.html
# https://www.zsh.org/mla/users/2021/msg00879.html
skip_global_compinit=1

# http://disq.us/p/f55b78
setopt noglobalrcs

export SYSTEM=$(uname -s)
export ZSH="$HOME/dotfiles/zsh"
export ZDOTDIR="$HOME/dotfiles/zsh/zsh"

# https://github.com/sorin-ionescu/prezto/blob/master/runcoms/zshenv
# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR}/.zprofile"
fi
