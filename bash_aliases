#!/bin/bash

# General Aliases
alias hgrep='history | grep'

alias https='http --default-scheme=https'

# Go alias for rg
alias rggo="rg -t go -g '!vendor' -g '!*_test.go'"
alias rgjava="rg -t java -g '!*test*'"
alias rgnode="rg -t js -t ts -g '!*node_modules*'"

alias objdump='objdump -M intel'

# File system
alias ln='ln -iv'
alias du='du -h'

# some ls aliases, 'll' should my default list command
if command -v exa >/dev/null 2>&1; then
    alias ls='exa'
    alias ll='ls -alFgh --git'
    alias la='ls -A'
    alias l='ls -FB'
fi

# Cat aliases
if command -v bat >/dev/null 2>&1; then
    alias cat='bat'
fi

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

# Vim aliases
# pvim is for running vim in a bash pipeline
alias pvim='vim +":setlocal buftype=nofile" -'
alias pvim_yaml='vim +":setlocal buftype=nofile filetype=yaml" -'
alias pvim_json='vim +":setlocal buftype=nofile filetype=json" -'
alias pvim_rust='vim +":setlocal buftype=nofile filetype=rust" -'

if [ -f ~/.secret_bash_aliases ]; then
    . ~/.secret_bash_aliases
fi
