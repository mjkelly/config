#!/bin/bash
# Sat Sep  3 15:34:37 EDT 2011
# .xsession rules:
# - Don't talk about .xsession.
# - All commands must be non-blocking except the last one.
# - The last line should exec the WM.

# (1) capslock is another control, (2) double-shift moves between us, us-intl,
# and phonetic russian keyboards.
/usr/bin/setxkbmap -option "ctrl:nocaps,grp:shifts_toggle" 'us(basic),us(intl),ru(phonetic)'
# Use a regular cursor image.
/usr/bin/xsetroot -cursor_name left_ptr

# touchpad shit for the macbook.
synclient MaxTapTime=0 PalmDetect=1 PalmMinWidth=85 PalmMinZ=17298

# These should apply to all machines:

/usr/bin/xscreensaver -nosplash &
/usr/bin/nm-applet &
caffeine >/dev/null 2>&1 &
# coords are NYC
gtk-redshift -l 40.732:-73.986 &

# These probably only apply to a laptop:

#gnome-power-manager &

exec /usr/bin/awesome
