#!/bin/bash

disabled=$(gsettings get org.gnome.desktop.lockdown disable-lock-screen)

if [[ $disabled == true ]]; then
  value=false
  human_value="enabled"
else
  value=true
  human_value="disabled"
fi

gsettings set org.gnome.desktop.lockdown disable-lock-screen "$value"
notify-send "screen lock $human_value"
