export PS1="[\u@\h \W]\\$ "

alias ll='ls -lv'
alias ls='ls -GFh'
alias grep='grep --color=auto'

# Avoid duplicates
export HISTCONTROL=ignoredups:erasedups
# big big history
export HISTSIZE=1500
export HISTFILESIZE=1500
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# without this mutt screws up multibyte characters
export LC_ALL=en_US.UTF-8
# keep your line length at a reasonable level to stay sane
export MANWIDTH=85
