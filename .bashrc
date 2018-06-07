PS1="[\u@\h \W]\\$ "

# Avoid duplicates
HISTCONTROL=ignoreboth:erasedups
# big big history
HISTSIZE=1500
HISTFILESIZE=1500
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
