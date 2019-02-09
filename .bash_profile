# without this mutt screws up multibyte characters
export LC_ALL=en_US.UTF-8
# keep your line length at a reasonable level to stay sane
export MANWIDTH=85

# Environment variables
export GOPATH=$HOME/dev/gocode
export PATH=$PATH:$GOPATH/bin:/usr/local/sbin
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export EDITOR=vim

if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi
