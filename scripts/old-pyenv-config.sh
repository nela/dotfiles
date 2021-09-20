# Alias for brew and pyenv https://github.com/pyenv/pyenv/issues/106

alias brew='env PATH=${PATH//$(pyenv root)\/shims:/} brew'

# Pyenv Configuration
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

if command -v pyenv-virtualenv &>/dev/null; then
  eval "$(pyenv virtualenv-init -)"
fi

# Setup virtualenvwrapper home
export WORKON_HOME=$HOME/.virtualenvs

# Project Home dir for virtualenv python projects
export PROJECT_HOME="$HOME/pyprojects"

# not needed with asdf stuff
# source /usr/local/bin/virtualenvwrapper.sh

# Tell pyenv-virtualenvwrapper to use pyenv when creating new Python environments
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
