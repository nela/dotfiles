export FZF_COMPLETION_TRIGGER=",,"
export FZF_COMPLETION_OPTS='--info=inline'

preview="--preview=' [[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --number {} || cat {}) 2> /dev/null | head -n 300' --preview-window='wrap' --bind 'f3:execute(bat -style=numbers {} || less -f {}),f2:toggle-preview,ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up,ctrl-a:select-all+accept'"

export FORGIT_FZF_DEFAULT_OPS="${preview}"
alias fzp="fd --type f . | fzf ${preview}"
unset preview

# export FZF_DEFAULT_COMMAND="fd --type f --hidden -E .git -E node_modules -E __pycache__"

if [[ $OSTYPE == *"linux"* ]]; then
  clip="xclip -sel clip"
else
  clip="pbcopy"
fi

# unset clip

# export FZF_DEFAULT_OPTS="--no-mouse --layout=reverse --multi --info=inline --bind 'ctrl-y:execute-silent(echo {+} | ${clip} ),ctrl-j:half-page-down,ctrl-k:half-page-up'"
