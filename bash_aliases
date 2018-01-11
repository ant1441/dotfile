#!/bin/bash

# General Aliases
alias texclean='rm -f *.toc *.aux *.log *.cp *.fn *.tp *.vr *.pg *.ky'
alias h='history'
alias allh='history | more'
alias hgrep='history | grep'
alias j="jobs -l"

alias c='clear'
# don't alias .
#alias .='cwd

# Navigation
# take care aliasing cd, easy potential for infinite loops
# alias cd='venv_cd'
alias cd..='cd ..'
#alias cdwd='cd $(bin/pwd)'
alias cwd='echo $PWD'

alias pu="pushd"
alias po="popd"

# File system
alias ln='ln -iv'
alias du='du -h'

# somels aliases, 'l' should my default list command
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CFB --hide="*.pyc" --hide="*~"'

alias bc='bc -il'
# Install colordiff package
if hash colordiff 2>/dev/null; then
    alias diff='colordiff'
fi
alias now='date +"%T"'

# open a file window at the given location
alias cdopen=xdg-open

# Git
alias g='git'

alias notebook='ipython notebook'
alias pnotebook='ipython notebook --pylab=inline'

# tmux 256 colours
alias tmux='tmux -2'

#
# Csh compatability:
#
alias unsetenv=unset
function setenv () {
  export $1="$2"
}

# Irssi is weird on larger screens under tmux
# http://www.wisdomandwonder.com/link/7784/making-irssi-refresh-work-with-tmux
alias irssi='TERM=screen-256color irssi'

# Functions
files     () { find ${1} -type f -print ; }
ff        () { find . -name ${1} -print ; }
llp       () { ls --color=always -lag "$@" | more ; }
word      () { fgrep -i "$*" /usr/share/dict/british-english ; }
wordcount () { cat "${1}" | tr -s ' 	.,;:?\!()[]"' '\012' | \
               awk 'END {print NR}' ; }

colour() {
  heads=${@:1:$((${#@} - 1))}
  tail=${@:${#@}}
  pygmentize -f terminal -g $tail | less -R $heads
}

#
# Git
#

git_pull_all ()
{
  find -L . -name .git -type d -prune -print0 | xargs -0 -n 1 -I{} bash -c 'echo {}; git -C {}/.. pull; echo'
}

git_checkout_all ()
{
  find -L . -name .git -type d -prune -print0 | xargs -0 -n 1 -I{} bash -c 'echo {}; git -C {}/.. checkout $1; git -C {}/.. branch; echo'
}

git_remote_state ()
{
  LOCAL=$(git rev-parse @)
  REMOTE=$(git rev-parse @{u})
  BASE=$(git merge-base @ @{u})

  if [ $LOCAL = $REMOTE ]; then
      echo "Up-to-date"
  elif [ $LOCAL = $BASE ]; then
      echo "Need to pull"
  elif [ $REMOTE = $BASE ]; then
      echo "Need to push"
  else
      echo "Diverged"
  fi
}

# Git branch bash completion https://gist.github.com/JuggoPop/10706934
if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash

    # Add git completion to aliases
    alias g='git'
    __git_complete g __git_main
    alias gc='git checkout'
    __git_complete gc _git_checkout
    #alias gm='git merge'
    #__git_complete gm __git_merge
    alias gp='git pull'
    __git_complete gp _git_pull
fi

if [ -f ~/.slack-secrets.bash ]; then
    slack_ping ()
    {
        . ~/.slack-secrets.bash
        channel=${2:-"@adam"}
        message=${1:-"ping!"}
        # curl --data $message $"$URL?token=$token&channel=$channel"
        echo $message | http --check-status POST $SLACK_URL token==$SLACK_TOKEN channel==$channel >/dev/null
    }
fi

palert ()
{
    type="$([ $? = 0 ] && echo terminal || echo error)"
    last_command=$(history | tail -n1 | sed -e 's/^\s*[0-9]\+\s*//;s/[;&|]\s*palert$//')
    msg=${1:-"${last_command}"} # Allow overriding the message (if it's sensitive, etc.)
    notify-send --urgency=critical -i ${type} "${last_command}"
    slack_ping "${type}: ${msg}"
}

goci()
{
    shell_pid=$$
    running=false

    pid_file=$(mktemp --suffix _goci.pid)
    trap "rm -f $pid_file" EXIT

    excludes="${excludes}$(find . \( -path ./vendor -o -path ./.git \) -prune -o -type f -executable -print0 | tr "|" "\|" | tr "\0" "|")"
    excludes="${excludes}\..*\.sw[px]$|.git|.*~$|vendor/.*"

    clear
    inotifywait --quiet --monitor --recursive --exclude "${excludes}" --event modify,create,delete,move --format %f . | stdbuf -oL uniq | while read line
    do
        # If there is no file, or it's empty, or the pid is not running, continue
        if [[ ! -e $pid_file ]] || [[ $(cat $pid_file) == "" ]] || ! kill -0 $(cat $pid_file) 2>/dev/null
        then
            clear
            echo "'''$line''' changed - building..."
            running=true
            (
                set -xe
                go build -v
                echo testing...
                go test -v $(go list ./... | grep -v /vendor/)
            ) &
            echo $! > ${pid_file}
            sleep 1
            running=false
         fi
    done
}

# Below are functions added with the add-alias command
