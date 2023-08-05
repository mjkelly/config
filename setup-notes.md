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
