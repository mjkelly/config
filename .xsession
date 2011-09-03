#!/bin/bash
# Sat Sep  3 15:34:37 EDT 2011
# .xsession rules:
# - Don't talk about .xsession.
# - All commands must be non-blocking except the last one.
# - The last line should exec the WM.

# (1) capslock is another control, (2) double-shift moves between us, us-intl,
# and phonetic russian keyboards.
setxkbmap -option "ctrl:nocaps,grp:shifts_toggle" 'us(basic),us(intl),ru(phonetic)'

# touchpad shit for the macbook.
synclient MaxTapTime=0 PalmDetect=1 PalmMinWidth=85 PalmMinZ=17298

xscreensaver -nosplash &
gnome-power-manager &
nm-applet &
caffeine >/dev/null 2>&1 &
# coords are NYC
gtk-redshift -l 40.732:-73.986 &

exec /usr/bin/awesome
