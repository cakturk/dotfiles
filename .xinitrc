#!/bin/sh
#
## ~/.xsessionrc
#
## Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/*; do
		if [ -x "$f" ]; then
			# shellcheck source=/dev/null
			. "$f"
		fi
	done
	unset f
fi

# # run Xprofile
if [ -f ~/.Xprofile ]; then
	# shellcheck source=/dev/null
	. ~/.Xprofile
fi

# start pulseaudio in the background
if [ -x /usr/bin/pulseaudio ]; then
	/usr/bin/pulseaudio --start
fi
# register pulseaudio
if [ -x /usr/bin/start-pulseaudio-x11 ]; then
	/usr/bin/start-pulseaudio-x11
fi

# run Xmodmap
[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap

# xsessionrc
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

# run local xhost
xhost local:root

# caps > esc, ctrl hyper key
# http://www.economyofeffort.com/2014/08/11/beyond-ctrl-remap-make-that-caps-lock-key-useful/#comment-4050709954
setxkbmap -option 'caps:ctrl_modifier'
setxkbmap -layout us,tr -option grp:alt_shift_toggle
xcape -e 'Caps_Lock=Escape;Control_L=Escape;Control_R=Escape'

# key repeat threshold and rate
xset r rate 300 58

# Prefix launch of session with ssh-agent if available and not already running.
if [ -z "$SSH_AGENT" ] && [ -z "$SSH_AUTH_SOCK" ] && [ -z "$SSH_AGENT_PID" ] \
    && [ -x /usr/bin/ssh-agent ]; then
	if [ "x$TMPDIR" != "x" ]; then
		SSH_AGENT="/usr/bin/ssh-agent /bin/env TMPDIR=$TMPDIR"
	else
		SSH_AGENT="/usr/bin/ssh-agent"
	fi
fi

# uncomment this if not using a login manager
# so i3 will start correctly
exec -l $SHELL -c "$CK_XINIT_SESSION $SSH_AGENT /usr/bin/i3"

# be verbose
# exec /usr/bin/i3 -V >> ~/.config/i3/logfile 2>&1

# /usr/bin/i3 -V >> ~/.config/i3/logfile 2>&1 & wmpid=$!
# wait $wmpid
# killall xcape
