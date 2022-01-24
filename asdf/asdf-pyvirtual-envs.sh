# Script made for using the asdf as a virtual env manager for python projects
# Based on: https://github.com/asdf-vm/asdf/issues/636#issuecomment-674092994
#
# Note that a virtualenv (python -m pip install virtualenv) should be installed
# for each python version! Commands:
#   python -m pip install virtualenv
#   asdf reshim python

# source $(brew --prefix)/Cellar/asdf/$(ls /usr/local/Cellar/asdf)/asdf.sh


if [[ "$OSTYPE" == "darwin"* ]]; then
  source $(brew --prefix asdf)/libexec/asdf.sh
else
  source $HOME/.asdf/asdf.sh
  source $HOME/.asdf/completions/asdf.bash
fi

export WORKON_HOME=$XDG_DATA_HOME/nelapys/

mkenv() {
  if [[ -z $1 ]] || [[ -z $2 ]]; then
    printf '%s\n' "Usage: mkenv <project-name> <python-version>"
    printf '%s\n' "Example: mkenv my-super-awesome-python-code 3.9.7"
    return -1
  elif [ ! -d "${HOME}/.asdf/installs/python/${2}" ]; then
    printf '%s\n' "Python version ${2} not installed"
    return -1
  elif [ -d "${WORKON_HOME}${1}" ]; then
    printf '%s\n' "Virtual environment already exists at ${WORKON_HOME}${1}"
    return -1
  fi

  echo $1 $2

  virtualenv -p $(asdf where python "$2")/bin/python ${WORKON_HOME}${1}
  printf '%s\n' "Virtal environment created at ${WORKON_HOME}${1}"
}

workon() {
  if [ -z $1 ]; then
    printf '%s\n' "Specify project: workon <project-name>"
    return -1
  fi

  printf '%s\n' "Checking if environment exists..."

  if [ ! -d "${WORKON_HOME}${1}" ]; then
    printf '%s\n' "Virtual environment not located ${WORKON_HOME}${1}"
    printf '%s\n' "Check if the environment is created at ${WORKON_HOME}"
    printf '%s\n' "Exiting..."
    return -1
  else
    printf '%s\n' "Environment located."
  fi

  if [ -d "${HOME}/statnett/${1}" ]; then
    dir="statnett"
  elif [ -d "${HOME}/nela/${1}" ]; then
    dir="nela"
  else
    printf '%s\n' "Unable to locate project directory. "
    printf '%s\n' "Continuing environment activation without defining PROJECT_HOME"
    unset dir
    export unset PROJECT_HOME
  fi

  printf '%s\n' "Activating enviroment ${WORKON_HOME}${1}"
  source ${WORKON_HOME}${1}/bin/activate
  printf '%s\n' "Environment ${WORKON_HOME}${1} activated."

  if [ ! -z $dir ]; then
    printf '%s\n' "Found project in parent directory: ${dir}"
    export PROJECT_HOME="${HOME}/${dir}/${1}"
    printf '%s\n' "PROJECT_HOME set to ${PROJECT_HOME}"
  fi

  if [ ! -z "${PROJECT_HOME}" ]; then
    printf '\n%s\n' "cd-ing into ${PROJECT_HOME}"
    [ -d ${PROJECT_HOME} ] && cd ${PROJECT_HOME}
    printf '\n%s\n' "Working directory should now be ${PROJECT_HOME}"
  fi
}

deactivate() {
  if [ -z $1 ]; then
    printf '%s\n'"Specify environment to delete"
    return -1
  fi

  printf '\n%s\n' "Remember to run following command from the commandline in order to unset PROJECT_HOME"
  printf '\n\t%s\n' "unset PROJECT_HOME"

  source ${WORKON_HOME}${1}/bin/deactivate
}

envdelete() {
  if [ -z $1 ]; then
    printf '%s\n' "Specify project: workon <project-name>"
    return -1
  fi

  source ${WORKON_HOME}${1}/bin/deactivate

  printf '\n%s\n' "Remember to run following command from the commandline in order to unset PROJECT_HOME"
  printf '\n\t%s\n' "unset PROJECT_HOME"

  rm -rf ${WORKON_HOME}${1}
}
