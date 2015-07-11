export PS1="[\u@ \W]\\$ "
alias ll="ls -lv"

# Avoid duplicates
export HISTCONTROL=ignoredups:erasedups
# big big history
export HISTSIZE=1500
export HISTFILESIZE=1500
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend
