# zoh-completions - together with compinstall somehow
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
  zstyle :compinstall filename "${DOTS}/zsh/zsh-completion"
  autoload -Uz compinit
  compinit
  # ZSH_DISABLE_COMPFIX="true"
fi

