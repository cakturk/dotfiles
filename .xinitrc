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

# uncomment this if not using a login manager
# so i3 will start correctly
exec /usr/bin/i3

# be verbose
# exec /usr/bin/i3 -V >> ~/.config/i3/logfile 2>&1

# /usr/bin/i3 -V >> ~/.config/i3/logfile 2>&1 & wmpid=$!
# wait $wmpid
# killall xcape
