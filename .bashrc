# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

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

export EDITOR=vim
export BROWSER=firefox

set -o ignoreeof

ulimit -c 10000

export GOROOT=$HOME/go
export GOPATH=$HOME/gocode
export PATH=$PATH:~/bin:$GOROOT/bin

export PS1='[$?]\u@\h:\w$ '

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Grab the latest environment set by keychain.
if [ -e ~/$HOME/.keychain/$HOSTNAME-sh ]; then
  source ~/.keychain/$HOSTNAME-sh
fi

# Function to reload environment and start a new ssh-agent if necessary.
function kc() {
    keychain --agents ssh ~/.ssh/*-key
    source ~/.keychain/$HOSTNAME-sh
}
