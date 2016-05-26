#!/usr/bin/env bash

source $HOME/i3/color.sh

SONG=$(mpc current -h localhost -p 6600 -f '[[%artist% - ]%file%]' | grep -Pzo '[^\/]+\.[^\/]+' | grep -Po $'[äöüÄÖÜßa-zA-Z0-9\\-\\_ \\.\'\"]+' | tr '\n' ' ' | sed 's/ \+/ /g' | xargs -0)
# $(mpc current -f '[[%artist% - ]%title%]')
OUTPUT=""
ICON=""

if [[ $? != 0 || $SONG == "" ]] ; then
	exit 0
fi

if [ -n "$(mpc -h localhost -p 6600 status | grep -E '\[playing\]')" ]; then
    ICON="f144"
elif [ -n "$(mpc -h localhost -p 6600 status | grep -E '\[paused\]')" ]; then
    ICON="f28b"
else
    ICON="f28d"
fi

if [ -n "$SONG" ]; then
    OUTPUT="$SONG"
else
    OUTPUT="-None-"
fi

if [[ $1 == '-i' ]] ; then
	echo -e "  \u${ICON}  "
	echo -e "  \u${ICON}  "
	echo "${COLOR_ACCENT_HEX_RAW}"
else
	echo -e $(echo -e "${OUTPUT} " | sed 's/ +$/ /')
fi

#echo -e "  \u${ICON}   "$(echo -e "${OUTPUT} " | sed 's/ +$/ /')" "

exit 0
