#!/bin/bash

#Xvfb -ac :1 -screen 0 1366x768x16 &> /dev/null &
#DISPLAY=:1 gnome-shell --mode=gdm --sync &
#x11vnc -geometry 1366x768 -nopw -localhost -display :1 &> /dev/null &
#./novnc/utils/novnc_proxy --vnc localhost:5900 --listen localhost:6080

export DISPLAY=:3
Xvfb "$DISPLAY" -screen 0 1024x768x24 &
fluxbox &
#x11vnc -display "$DISPLAY" -bg -nopw -listen localhost -xkb
x11vnc -display "$DISPLAY" -bg -nopw -xkb

