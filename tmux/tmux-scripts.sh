attach_to() {
  # [ ! -z "${TMUX}" ] && tmux detach 2>/dev/null
  tmux has-session -t "${1}" 2>/dev/null

  if [ $? != 0 ]; then
    [ -d "${2}" ] && tmux new-session -s "${1}" -c "${2}" -d
    [ ! -z "${3}" ] && {
      tmux send-keys -t "${1}" "${3}" C-m \; new-window -t "${1}" -d
    }
  fi

  [ -n "${TMUX}" ] && tmux switch-client -t "${1}" || tmux attach -t "${1}"
}

alias master="attach_to master ${HOME}/skole/master 'cd thesis && nvim main.tex'"
alias dots="attach_to dots ${DOTS}"

laki() {
  attach_to laki ${HOME}/projects/laki "pnpm dev"
}
