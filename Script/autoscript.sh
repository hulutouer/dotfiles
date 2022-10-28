#!/usr/bin/env bash

# exec dwm
# exec startx
# exec slstatus &
### screen ###
xrandr --output Virtual-1 --mode 1920x1080 --rate 60
### feh ### sudo pacman -S feh
feh --bg-fill --randomize /home/sam/Pictures/*
### picom### sudo pacman -S picon
picom -CGb
### polybar ### 
