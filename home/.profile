# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# LLVM
if [ -d "/opt/llvm" ] ; then
    PATH="/opt/llvm/bin:$PATH"
fi

# Golang
if [ -d "/opt/go" ] ; then
    export GOROOT="/opt/go"
    export GOPATH="$HOME/src/go_ext:$HOME/src/go_my"
    PATH="/opt/go/bin:$PATH"
    if [ -d "$HOME/src/go_ext/bin" ] ; then
        PATH="$HOME/src/go_ext/bin:$PATH"
    fi
    if [ -d "$HOME/src/go_my/bin" ] ; then
        PATH="$HOME/src/go_my/bin:$PATH"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

export PATH

