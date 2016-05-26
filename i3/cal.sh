#!/usr/bin/env bash
# Copyright (C) 2016 Nico Bäurer
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# little script to display a calendar via xterm and i3
# start via: xterm -T "Calendar" -e [PATH_TO_SCRIPT]
# installation:
# i3-msg => i3-config: for_window
# start via command above => settitle = not needed

source $HOME/i3/color.sh

cal_add=0
cal_month=$(date +%m)
cal_year=$(date +%Y)

settitle() {
	echo -en "\033]0;$@\a"
}
setcursor() {
	echo -e -n "\x1b[\x33 q"
}
movecursor() {
	x=$1
	y=$2
	echo -n $'\033['$y';'$x'f'
}

__printcal() {
	#1. arg = color code (term value not hex code)
	local colorstart=$'\e[48;5;'$1$'m'
	local colorreset=$'\e[0m'
	local mon=$(expr $cal_month + $cal_add)
	local yea=$cal_year

	echo
#	cal --color=always
	if [[ $cal_add -ne 0 ]] ; then
		while [[ $mon -gt 12 ]] ; do
			local mon=$(expr $mon - 12)
			local yea=$(expr $yea + 1)
		done
		while [[ $mon -lt 1 ]] ; do
			local mon=$(expr $mon + 12)
			local yea=$(expr $yea - 1)
		done

		cal "$mon" "$yea"
	else
		cal | sed "s/\(\b$(date +%e | sed "s/ //g")\b\)/${colorstart}\1${colorreset}/g"
	fi
}

printcal() {
	__printcal ${COLOR_ACCENT_TERM} | sed 's/^/   /g' # | less -r -P‎
	movecursor $(tput cols) $(tput lines)
}

enablemouseevents() {
	# https://stackoverflow.com/questions/5966903/how-to-get-mousemove-and-mouseclick-in-ba    sh
	echo -n $'\e[?1000h'
}

enablemouseevents
settitle "Calendar"
setcursor

#i3-msg '[title="Calendar"] floating enable, resize set 216 157, move window to position 1376 25'
# less -P argument seems to be empty, but I added a left-to-right mark (\u200E)
printcal #printcal 173 | sed 's/^/   /g' # | less -r -P‎

while true; do
	read -rsn1 input
	decimal=$(printf %d \'$input | xargs)

	case $input in
		'q'|'Q')
			break
			;;
		'k'|'K')
			clear
			cal_add=$(expr $cal_add - 12)
			printcal
			;;
		'j'|'J')
			clear
			cal_add=$(expr $cal_add + 12)
			printcal
			;;
		'h'|'H')
			clear
			cal_add=$(expr $cal_add - 1)
			printcal
			;;
		'l'|'L')
			clear
			cal_add=$(expr $cal_add + 1)
			printcal
			;;
		'[')
			read -rsn1 input

			# mouse event
			if [[ $input == 'M' ]] ; then
				break
			fi
			;;
	esac
done

exit
