# alias v='nvim'
alias ll='ls -laFh'     			# long (-l), types classify (-F),human readable (-h)
alias ls='ls --color=auto'
alias l='ll'
alias lst='ls -tlFh'
alias lss='ls -SlFh'
alias lsd='ls -ld .*'		# show dot files, list dirs non-recursively (-d)
alias lsr='ls -R'
alias ls.id='ls -nFh'			# show numeric FID and GID (-n)

# GIT
alias gs='git status'
alias gcm='git commit -m'
alias gca='git commit --amend --no-edit'
alias gm='git merge'
alias gr='git rebase'
alias gri='git rebase -i'
alias gp='git push'

# diff
alias diff='colordiff'

# change dir
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../../..'

alias df='df -h'

echo in aliases

# Pipe Aliases
alias L=' | less '
alias G=' | rg'
alias T=' | tail '
alias H=' | head '
alias W=' | wc -l '
alias S=' | sort '

alias vimconf="cd ${NVIM} && nvim init.vim"
alias zshconf="cd ${ZSH} && nvim zsh/.zshrc"
alias shell="exec ${SHELL}"

# Tmux
alias tat="tmux a -t"
alias tk="tmux kill-ses -t"
alias tl="tmux ls"
alias tn="tmux new -s"
alias dots='attach_to dots'
alias thesis='attach_to thesis'

# wget
alias wget="wget --hsts-file ${XDG_CACHE_HOME}/wget/wget-hsts"

alias bt="sudo -E bpftrace"

[[ `uname -r` == *"WSL"* ]] && alias docker="sudo docker"
