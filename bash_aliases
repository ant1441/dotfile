#!/bin/bash

# General Aliases
alias h='history'
alias allh='history | more'
alias hgrep='history | grep'
alias c='clear'

# don't alias .
#alias .='cwd

# Navigation
# take care aliasing cd, easy potential for infinite loops
# alias cd='venv_cd'
alias cd..='cd ..'
#alias cdwd='cd $(bin/pwd)'
alias cwd='echo $PWD'

# File system
alias ln='ln -iv'
alias du='du -h'

# some ls aliases, 'l' should my default list command
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

# tmux 256 colours
alias tmux='tmux -2'

# Irssi is weird on larger screens under tmux
# http://www.wisdomandwonder.com/link/7784/making-irssi-refresh-work-with-tmux
alias irssi='TERM=screen-256color irssi'

#
# Git
#

git_pull_all ()
{
  find -name .git -execdir git pull \;
}

git_checkout_all ()
{
  find -name .git -execdir git checkout "$1" \;
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

echo_passed () {
    echo -ne "\e[32m"
cat << 'EOF'
                         .       .
                        / `.   .' \
                .---.  <    > <    >  .---.
                |    \  \ - ~ ~ - /  /    |
                 ~-..-~             ~-..-~
             \~~~\.'                    `./~~~/
              \__/                        \__/
               /                  .-    .  \
        _._ _.-    .-~ ~-.       /       }   \/~~~/
    _.-'q  }~     /       }     {        ;    \__/
   {'__,  /      (       /      {       /      `. ,~~|   .     .
    `''''='~~-.__(      /_      |      /- _      `..-'   \\   //
                / \   =/  ~~--~~{    ./|    ~-.     `-..__\\_//_.-'
               {   \  +\         \  =\ (        ~ - . _ _ _..---~
               |  | {   }         \   \_\
              '---.o___,'       .o___,'
EOF
    echo -ne "\e[0m"
}

# Vim aliases
# pvim is for running vim in a bash pipeline
alias pvim='vim +":setlocal buftype=nofile" -'
alias pvim_yaml='vim +":setlocal buftype=nofile filetype=yaml" -'
alias pvim_json='vim +":setlocal buftype=nofile filetype=json" -'

goci()
{
    shell_pid=$$
    running=false

    pid_file=$(mktemp --suffix _goci.pid)
    trap "rm -f $pid_file && setterm -cursor on" EXIT SIGINT

    excludes="${excludes}$(find . \( -path ./vendor -o -path ./.git \) -prune -o -type f -executable -print0 | tr "|" "\|" | tr "\0" "|")"
    excludes="${excludes}\..*\.sw[px]$|.git|.*~$|vendor/.*"

    setterm -cursor off
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
                set -e
                go_packages=$(go list ./... | grep -v /vendor/)
                echo "Go Packages: $go_packages"
                go build $GO_CI_BUILD_ARGS
                echo testing...
                go test -v $go_packages
                if command -v golint >/dev/null 2>&1; then
                    echo linting...
                    golint -set_exit_status $go_packages
                fi
                if [ -n "$(type -t echo_passed)" ] && [ "$(type -t echo_passed)" = function ]; then
                    clear
                    echo_passed
                else
                    echo "Success!"
                fi
            ) &
            echo $! > ${pid_file}
            sleep 1
            running=false
         fi
    done
}

if [ -f ~/.secret_bash_aliases ]; then
    . ~/.secret_bash_aliases
fi
