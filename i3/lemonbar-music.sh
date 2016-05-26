#!/usr/bin/env zsh
# Copyright (C) 2016 Nico Bäurer
# #
# # This program is free software: you can redistribute it and/or modify
# # it under the terms of the GNU General Public License as published by
# # the Free Software Foundation, either version 3 of the License, or
# # (at your option) any later version.
# #
# # This program is distributed in the hope that it will be useful,
# # but WITHOUT ANY WARRANTY; without even the implied warranty of
# # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# # GNU General Public License for more details.
# #
# # You should have received a copy of the GNU General Public License
# # along with this program.  If not, see <http://www.gnu.org/licenses/>.

source $HOME/i3/color.sh
source $HOME/i3/lemonbar-progress.sh

# start
# ./lemonbar-test.sh | lemonbar -b -B "#00000000" -F "#fff" -g 1600x20+0+0 -f "FontAwesome:size=10" -f "Monospace:letterSpace=-5:size=7" -f "Ubuntu Mono derivative Powerline:size=10" | bash

ICO_PREV="\uf137"
#"\uF049"
ICO_NEXT="\uf138"
#"\uF050"
ICO_PLAY="\uf144"
#"\uF04B"
ICO_STOP="\uf28d"
#"\uF04D"
ICO_PAUSE="\uf28b"
#"\uF04C"
DEFAULT_COLOR="%{F#$COLOR_TEXT_HEX_RAW}"
DEFAULT_ICO_COLOR_RAW="${COLOR_ACCENT_HEX_RAW}"
DEFAULT_ICO_COLOR="%{F#$DEFAULT_ICO_COLOR_RAW}"
#"fb4757"
MPC_PARAMS=( -h localhost -p 6600 )

mpccmd() {
	echo -n "mpc ${MPC_PARAMS} $@"
}
song() {
	text=$(mpc current $MPC_PARAMS -f '[[%artist% - ]%file%]' | grep -Pzo '[^\/]+\.[^\/]+' | grep -Po $'[äöüÄÖÜßa-zA-Z0-9\\-\\_ \\.\'\"]+' | tr '\n' ' ' | sed 's/ \+/ /g' | xargs -0)
	echo -n "%{T3}${text:0:50}%{T-}"
}

padding() {
	printf "%-0${1}s" " "
}
icon() {
	echo -n $DEFAULT_ICO_COLOR
	echo -n "%{A:$2:}"
	padding 3
	echo -n "$1"
	padding 3
	echo -n "%{A}"
	echo -n $DEFAULT_COLOR
}

controlprev() {
	icon $ICO_PREV "$(mpccmd prev)"
}
controlnext() {
	icon $ICO_NEXT "$(mpccmd next)"
}
controlstop() {
	icon $ICO_STOP "$(mpccmd stop)"
}
controlplay() {
	icon $ICO_PLAY "$(mpccmd play)"
}
controlpause() {
	icon $ICO_PAUSE "$(mpccmd pause)"
}

controls() {
	controlprev

	if [[ $(echo $mpcstat | grep -i playing) ]] ; then
		controlstop
		controlpause
	elif [[ $(echo $mpcstat | grep -i paused) ]] ; then
		controlstop
		controlplay
	else
		controlplay
	fi

	controlnext
}

# echo "\u2013\u2013\u2013\u2758\u2013"


progress=0
max=100
mpcstat=""
while true; do
	if [[ $progress -gt $max ]] ; then
	       progress=0
	       sleep 5
	fi

#	echo -n $(progressbair 10 20 "ffffff")
	mpcstat=$(mpc $MPC_PARAMS status)
	tmp_progress=$(echo -n $mpcstat | grep -i playing | sed 's/.*(//' | sed 's/%.*//')
	[[ ! -z $tmp_progress ]] && progress=$tmp_progress
#	color="46D14C"
#	[[ $progress -gt 30 ]] && color="ffffff"
#	[[ $progress -gt 70 ]] && color="" #color="${COLOR_ACCENT_HEX_RAW}"
	echo -n "%{l}$(padding 4)$(song)"
	echo -n "%{c}"
	echo -n "$(progressbar $progress $max)"
	echo "%{r}$(controls)$(padding 1)"
#	echo "%{r}"$(progressbar 15 20 "46D14C")
    sleep .3
done

