# Setup Notes

## Packages

**Base setup:**
git
gnupg
tmux
vim
neovim

Terminal emulators: foot and alacritty are both nice.

**GUI machine with Sway:**
lxqt-policykit
network-manager-applet
dunst
light
waybar
fontawesome5-fonts
grimshot
rofi
blueman

In `/etc/pam.d/swaylock`:
```
# See https://github.com/swaywm/swaylock/issues/61#issuecomment-965175390
auth            sufficient      pam_unix.so try_first_pass likeauth nullok
auth            sufficient      pam_fprintd.so
```

In `/etc/udev/rules.d/99-mjk-no-trackpoint.rules`:
```
# Remove trackpoint device
# On my replacement keyboard, it drifts badly which prevents me from using the regular trackpad.
ACTION!="remove", ATTRS{name}=="ETPS/2 Elantech TrackPoint", ENV{LIBINPUT_IGNORE_DEVICE}="1"
```
