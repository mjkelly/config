#!/bin/bash
# See https://wiki.archlinux.org/index.php/Touchpad_Synaptics
new_value="TouchpadOff=$(synclient -l | grep -c 'TouchpadOff.*=.*0')"
synclient "${new_value}"
which notify-send && notify-send "Set ${new_value}"
