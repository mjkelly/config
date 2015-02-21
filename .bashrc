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
    export GREP_OPTIONS="--color=auto"
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

# Grab the latest environment set by keychain.
if [ -e ~/$HOME/.keychain/$HOSTNAME-sh ]; then
  source ~/.keychain/$HOSTNAME-sh
fi

# Function to reload environment and start a new ssh-agent if necessary.
function kc() {
  if which keychain >/dev/null 2>&1; then
    keychain -q --timeout 1440 ~/.ssh/*-key
    . ~/.keychain/$HOSTNAME-sh
  else
      echo "No keychain application."
  fi
}

alias mygo='cd ~/gocode/src/github.com/mjkelly/go'

# This is for machine-specific stuff that I don't want to commit.
if [ -f $HOME/.bashrc.localonly ]; then
  source $HOME/.bashrc.localonly
fi
