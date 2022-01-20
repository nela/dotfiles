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

export FZF_DEFAULT_OPTS="--preview='bat {}'"
# export FZF_DEFAULT_OPTS="--no-mouse --height 40% --layout=reverse --multi --inline-info  --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --theme=TwoDark --color=always {} || cat {}) 2> /dev/null | head -n 300' --preview-window='right:hidden:wrap' --bind='f3:execute(bat --style=numbers {} || less -f {}),f2:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute-silent(echo {+} | pbcopy)'"

# export FZF_DEFAULT_OPTS="--no-mouse --height 40% --layout=reverse --multi --inline-info --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --theme=TwoDark --color=always {} || cat {}) 2> /dev/null | head -n 300' --preview-window='right:hidden:wrap' --bind='f3:execute(bat --style=numbers {} || less -f {}),f2:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute-silent(echo {+} | pbcopy)'"
