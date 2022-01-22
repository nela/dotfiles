# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/usr/local/opt/fzf/shell/key-bindings.zsh"

export FZF_COMPLETION_TRIGGER=",,"
export FZF_DEFAULT_COMMAND="fd --type f --hidden -E .git -E node_modules -E __pycache__ -E Library -E Music -E Movies "

preview="--preview=' [[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --number {} || cat {}) 2> /dev/null | head -n 300' --preview-window='wrap' --bind 'f3:execute(bat -style=numbers {} || less -f {}),f2:toggle-preview,ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up,ctrl-a:select-all+accept'"

export FZF_DEFAULT_OPTS="--no-mouse --layout=reverse --multi --info=inline --bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'"

alias fzp="fzf ${preview}"
