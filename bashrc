# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# For profile .bashrc
# http://www.rosipov.com/blog/profiling-slow-bashrc/
# PS4='+ $(date "+%s.%N")\011 '
# exec 3>&2 2>/tmp/bashstart.$$.log
# set -x

# Add the below at the end of the profiling
# set +x
# exec 2>&3 3>&-

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
# dont add trivial commands to the hitory
HISTIGNORE="ls:lln:lla:lld:llf:lll:now:h:c:cd ..:cd"

# append to the history file, don't overwrite it
shopt -s histappend
# run history -a at each prompt to update the history in realtime
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000000
HISTFILESIZE=200000

# set the history logging format
HISTTIMEFORMAT='%F %T '

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

export EDITOR='vim'

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -f $HOME/.bash_colours ]; then
    nice_colours=yes
    . $HOME/.bash_colours
else
    nice_colours=
fi

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    if [ "$nice_colours" = yes ]; then
        PS1="${debian_chroot:+($debian_chroot)}\[${bldgrn}\]\u@\h\[${NC}\]\[${bldylw}\]\$(__git_ps1)\[${NC}\]:\[${bldblu}\]\w\[${NC}\]\$ "
    else
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=critical -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

## Custom

if [ -d ~/bin ]; then
    export PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# virtualenvwrapper
# if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
#     export WORKON_HOME=$HOME/.virtualenvs
#     export PROJECT_HOME=$HOME/Documents/python
#     source /usr/local/bin/virtualenvwrapper.sh
# fi

# Don't write .pyc files
# export PYTHONDONTWRITEBYTECODE=1

# npm
if [ -d ~/.npm-packages ]; then
    export NPM_PACKAGES="$HOME/.npm-packages"
    export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
    PATH="$NPM_PACKAGES/bin:$PATH"

    # Unset manpath so we can inherit from /etc/manpath via the `manpath`
    # command
    unset MANPATH # delete if you already modified MANPATH elsewhere in your config
    MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
fi

# tmux
if [ -f ~/.tmuxinator.bash ]; then
    . ~/.tmuxinator.bash
fi

# Check if we have SCM branch functions defined
if ! [ -n "$(type -t __git_ps1)" ] && [ "$(type -t __git_ps1)" = function ]; then
    __git_p1() { :; }
fi

# CPAN stuff
if [ -d ~/perl5 ]; then
    PATH="$HOME/perl5/bin${PATH+:}${PATH}"; export PATH;
    PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"; export PERL5LIB;
    PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
    PERL_MB_OPT="--install_base \"$HOME/perl5\""; export PERL_MB_OPT;
    PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"; export PERL_MM_OPT;
fi

# Go
if command -v go >/dev/null 2>&1; then
    export GOPATH="$HOME/.gopath"
    mkdir -p $GOPATH
    if [ -d "$HOME/.gopath/bin" ]; then
        export PATH="$PATH:$HOME/.gopath/bin" # Add GO to PATH for scripting
    fi
fi

# Kubernetes
if command -v kubectl >/dev/null 2>&1; then
    source <(kubectl completion bash)
fi

# Helm
if command -v helm >/dev/null 2>&1; then
    source <(helm completion bash)
fi

# RVM
if [ -d ~/.rvm/bin ]; then
    export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
fi

# NVM
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    # NVM is quite slow
    : # . "$NVM_DIR/nvm.sh"  # This loads nvm
fi

# SSH agent
if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s`
  ssh-add
fi

# Rust
if [ -d "$HOME/.cargo/bin" ] ; then
    PATH="$HOME/.cargo/bin:${PATH}"
fi
if command -v rustup >/dev/null 2>&1; then
    source <(rustup completions bash)
fi

# Emscripten
if [ -d "$HOME/Documents/emscripten" ] ; then
    PATH="$HOME/Documents/emscripten/emsdk_portable:$HOME/Documents/emscripten/emsdk_portable/clang/fastcomp/build_incoming_64/bin:$HOME/Documents/emscripten/emsdk_portable/node/4.1.1_64bit/bin:$HOME/Documents/emscripten/emsdk_portable/emscripten/incoming:${PATH}"
fi

# Digital Ocean
if command -v doctl >/dev/null 2>&1; then
    source <(doctl completion bash)
fi

