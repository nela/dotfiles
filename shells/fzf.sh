export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow"
export FZF_COMPLETION_TRIGGER=",,"
export FZF_DEFAULT_OPTS="--cycle --no-mouse --layout=reverse --multi --info=inline --bind 'ctrl-y:execute-silent(echo {+} | ${clip} ),ctrl-j:half-page-down,ctrl-k:half-page-up'"
export FZF_COMPLETION_OPTS='--info=inline --cycle --no-mouse'

preview="--preview=' [[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --number {} || cat {}) 2> /dev/null | head -n 300' --preview-window='wrap' --bind 'f3:execute(bat -style=numbers {} || less -f {}),f2:toggle-preview,ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up,ctrl-a:select-all+accept'"

export FORGIT_FZF_DEFAULT_OPS="${preview}"
alias fzp="fd --type f . | fzf ${preview}"
unset preview

if [[ $OSTYPE == *"darwin"* ]]; then
  clip="pbcopy"
else
  clip="xclip -sel clip"
fi
