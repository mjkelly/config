#!/bin/bash

function is_running {
	ps -C $1 >/dev/null 2>&1
	return $?
}

function start_if_not_running {
	if is_running $1; then
		true
	else
		$@ &
	fi
}


# Configure X things
setxkbmap -option "ctrl:nocaps,grp:shifts_toggle" 'us(basic),us(intl),ru(phonetic)'
xrdb -merge ~/.Xdefaults
synclient MaxTapTime=0 PalmDetect=1 PalmMinWidth=85 PalmMinZ=17298

# Launch daemons
xscreensaver -nosplash &
gnome-power-manager &
#wicd-client &
nm-applet &
caffeine >/dev/null 2>&1 &
#ivman-launch &
#start_if_not_running ivman

#gdlinux &
#conky &
#fbpager &
#fbxkb &

# WM
#exec /usr/bin/ion3
exec /usr/bin/awesome
#exec /usr/bin/dwm
#exec /usr/bin/xmonad
