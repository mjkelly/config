# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# === basic setup ===

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}\007"'
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
fi

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# === personalization ===

export EDITOR=vim
export BROWSER=google-chrome
set -o ignoreeof
ulimit -c 10000
export PS1='[$?]\u@\h:\w$ '
# don't put duplicate lines in the history. See bash(1) for more options.
export HISTCONTROL=ignoreboth
# don't save history to a file; in-memory only
unset HISTFILE

# Go language installation
export GOROOT=$HOME/go
# All installed go code, including mine in a subdirectory.
export GOPATH=$HOME/gocode

export PATH=$PATH:~/bin:$GOROOT/bin:$HOME/gocode/bin:
alias mygo='cd ~/gocode/src/github.com/mjkelly/go'

# Set up ssh-agent
# This is based on: https://gist.github.com/mzedeler/45ef2be24d9ff13b33ba
# It's functionally equivalent to using 'keychain'.
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initializing new SSH agent..."
    touch $SSH_ENV
    chmod 600 "${SSH_ENV}"
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' >> "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    kill -0 $SSH_AGENT_PID 2>/dev/null || {
        start_agent
    }
else
    start_agent
fi

# helper to re-source configuration if it's out of date
function kc() {
    . "${SSH_ENV}" > /dev/null
    ssh-add ~/.ssh/*-key
}

# This is for machine-specific stuff that I don't want to commit.
if [ -f $HOME/.bashrc.localonly ]; then
  source $HOME/.bashrc.localonly
fi
