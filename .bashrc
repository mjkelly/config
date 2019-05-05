# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# === basic setup ===

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
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

export EDITOR=nvim
export BROWSER=google-chrome
set -o ignoreeof
ulimit -c 10000

PROMPT_COMMAND=__prompt_command
__prompt_command() {
  local rc=$?
  local prefix=''
  if [[ $rc -ne 0 ]]; then
    prefix="\[\033[31m\]($rc)\[\033[m\] "
    # If you prefer to avoid the red color here:
    #prefix="($rc) "
  fi
  local prompt="\[\033[32m\]\u@\h:\w\$\[\033[m\]"
  # If you prefer to avoid the color here:
  #local prompt="\u@\h:\w$"
  PS1="$prefix$prompt "
}

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
alias xopen='xdg-open'

# Set up ssh-agent
source $HOME/.bashrc.ssh-agent

# This is for machine-specific stuff that I don't want to commit.
if [ -f $HOME/.bashrc.localonly ]; then
  source $HOME/.bashrc.localonly
fi
