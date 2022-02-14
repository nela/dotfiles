export FZF_COMPLETION_TRIGGER=",,"
export FZF_DEFAULT_COMMAND="fd --type f --hidden"
export FZF_DEFAULT_OPTS="--no-mouse --height 40% --layout=reverse --multi --inline-info --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --theme=TwoDark --color=always {} || cat {}) 2> /dev/null | head -n 300' --preview-window='right:hidden:wrap' --bind='f3:execute(bat --style=numbers {} || less -f {}),f2:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute-silent(echo {+} | pbcopy)'"
