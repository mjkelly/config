#!/bin/bash
# Sat Sep  3 15:34:37 EDT 2011
# .xsession rules:
# - Don't talk about .xsession.
# - All commands must be non-blocking except the last one.
# - The last line should exec the WM.

# For i3 only:
# export TERMINAL=/usr/bin/urxvt

# For xmonad only:
# trayer --edge top --align right --SetDockType true --SetPartialStrut true \
#        --expand true --width 15 --height 12 --transparent true \
#        --tint 0x000000

# (1) capslock is another control, (2) double-shift moves between us, us-intl,
# and phonetic russian keyboards.
/usr/bin/setxkbmap -option "ctrl:nocaps,grp:shifts_toggle" 'us(basic),us(intl),ru(phonetic)'
/usr/bin/xrdb merge ~/.Xdefaults

# Touchpad configuration for laptops:
# VertEdgeScroll=0 for macbook, =1 for thinkpad.
#synclient MaxTapTime=0 PalmDetect=1 PalmMinWidth=85 PalmMinZ=17298 \
#  VertEdgeScroll=0 ClickFinger3=2 HorizHysteresis         = 50
synclient MaxTapTime=0 PalmDetect=1 PalmMinWidth=85 PalmMinZ=17298 \
  VertEdgeScroll=0 HorizHysteresis=50 VertHysteresis=50


# These should apply to all machines:

/usr/bin/xscreensaver -nosplash &
/usr/bin/nm-applet &
caffeine >/dev/null 2>&1 &
# For red screen at night (coords are NYC):
# gtk-redshift -l 40.732:-73.986 &

exec /usr/bin/awesome
# Other options for window manager:
# exec /usr/bin/i3
# exec /usr/bin/xmonad
