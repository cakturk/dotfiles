PS1="[\u@\h \W]\\$ "

# Enable bash completion
if [ -f /usr/local/etc/bash_completion ]; then
	. /usr/local/etc/bash_completion
fi

# Avoid duplicates
HISTCONTROL=ignoreboth:erasedups
# big big history
HISTSIZE=50000
HISTFILESIZE=50000
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# Useful aliases
alias ls='ls -GFh'
alias ll='ls -lv'
alias grep='grep --color=auto'

# Get a FreeBSD csh like C-w behaviour
# http://unix.stackexchange.com/a/58491
stty werase undef
bind '\C-w:unix-filename-rubout'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
