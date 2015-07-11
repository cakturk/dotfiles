if [ -f `brew --prefix`/etc/bash_completion ]; then
	. `brew --prefix`/etc/bash_completion
fi
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export EDITOR=vim
alias ls='ls -GFh'
