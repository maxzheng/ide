# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

export PS1='[\W]\$ '
export EDITOR='vim'
export PYTHONSTARTUP=~/.python

# Command enhancement
alias grep='grep --color --exclude=*.svn-base --exclude=.tox'
alias ssh='ah ssh'
alias vi='vim -p'
alias p='vi ~/notes/priorities'

if [ "$(uname)" == "Darwin" ]; then
    alias ls='ls -G'
else
    alias open='xdg-open'
    alias ls='ls --color'
fi


# Development
alias s='screen -h 5000 -dr $*'

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Remove duplicates in PATH:
PATH="$(printf "%s" "${PATH}" | /usr/bin/awk -v RS=: -v ORS=: '!($0 in a) {a[$0]; print}')"
PATH="${PATH%:}"    # remove trailing colon"
export PATH

# Set window title to current dir
if [[ "$TERM" == screen* ]]; then
  screen_set_window_title () {
    local HPWD="$PWD"
    case $HPWD in
      $HOME) HPWD="~";;
      $HOME/*) HPWD=${PWD##*/};;
    esac
    printf '\ek%s\e\\' "$HPWD"
  }
  PROMPT_COMMAND="screen_set_window_title; $PROMPT_COMMAND"
  export TERM=xterm-256color
fi
