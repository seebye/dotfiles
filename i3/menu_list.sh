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

source $HOME/i3/color.sh

declare -A items=()
declare -A commands=()

minwidth=0
#items[0]="nummer eins"
#items[1]="nummer zwei"
#items[2]="nummer drei"

lastindex=0
index=0

# redirect output to stderr
cerr() {
	command echo "$@" >&2
}
cout() {
	command echo "$@"
}
printf() {
	printferr "called printf.. "
	exit 1
}
printfout() {
	command printf "$@"
}
printferr() {
	command printf "$@" >&2
}
clear() {
	cerr -e '\0033\0143'
}

ord() {
	printfout %d "'$1"
}

getmousepos() {
	expr $(ord "$1") - $(ord "!")
}

fetchsize() {
	cols=$(tput cols)
	lines=$(tput lines)
}

resize-term() {
	width=$([[ $# -eq 2 ]] && echo -n $1 || echo -n $cols)
	height=$([[ $# -eq 2 ]] && echo -n $2 || echo -n $1)
	cerr $'\e[8;'$height';'$width't'
}

enablemouseevents() {
	# https://stackoverflow.com/questions/5966903/how-to-get-mousemove-and-mouseclick-in-bash
	cerr -n $'\e[?1000h'
}

setcursor() {
	cerr -e -n "\x1b[\x33 q"
}

gettitle() {
	echo -n $termtitle
}

settitle() {
	termtitle="$@"
	printferr "\033]0;"$termtitle"\a"
	sleep .1
}

get-term-wnd-id() {
	oldtitle=$(gettitle)
	uniquetitle=$(strings < /dev/urandom | head -c 50 | base64)

	settitle $uniquetitle
	wmctrl -lp | grep "$uniquetitle" | cut -d' ' -f 1
	settitle $oldtitle
}

get-term-wnd-size() {
	echo $(xwininfo -id $(get-term-wnd-id) -stats | egrep '(Width|Height):' | awk '{print $NF}') | sed -e 's/ /x/'
}

get-screen-size() {
	xdpyinfo | grep dimensions | awk '{print $2;}'
}

move-term-wnd() {
	x=$1
	y=$2
	printferr '\e[3;'$x';'$y't'
}

center-term-wnd() {
	screensize=$(get-screen-size)
	termsize=$(get-term-wnd-size)

	termwidth=$(echo -n $termsize | cut -d'x' -f 1)
	termheight=$(echo -n $termsize | cut -d'x' -f 2)

	screenwidth=$(echo -n $screensize | cut -d'x' -f 1)
	screenheight=$(echo -n $screensize | cut -d'x' -f 2)

	move-term-wnd $(expr $screenwidth / 2 - $termwidth / 2) $(expr $screenheight / 2 - $termheight / 2)
}

printlistitem() {
	text=$1
	color=$2
	textlen=$(cout -n $text | wc -c)

	if [[ ! -z $color ]] ; then
		cerr -n $'\e[48;5;'${color}'m'
	fi

	printferr "%-${cols}s" "$text"
	cerr $'\e[0m'
}

movecursor() {
	x=$1
	y=$2
	cerr -n $'\033['$y';'$x'f'
}

reprintlistitem() {
	i=$1

	fetchsize
	movecursor 1 $(expr $i + 1)

	color=''

	if [[ $index -eq $i ]] ; then
		#echo -n "selected "
		#echo -n $'\e[48;5;173m'
		color=${COLOR_ACCENT_TERM}
	fi

	printlistitem "${items[$i]}" "$color"

	movecursor $cols $lines
}

printlist() {
	clear

	for i in "${!items[@]}" ; do
		reprintlistitem $i
	done
}

min() {
	local val=999999999999999999

	for i in $@ ; do
		if [[ $i -lt $val ]] ; then
			val=$i
		fi
	done

	cout -n $val
}

max() {
	local val=-999999999999999999

	for i in $@ ; do
		if [[ $i -gt $val ]] ; then
			val=$i
		fi
	done

	cout -n $val
}

executedselecteditem() {
	cout -n ${items[$index]}
	#legacy	echo -n " ";exec ${commands[$index]}
}

search_index_nonstrict() {
	for i in "${!items[@]}" ; do
		if [[ ${items[$i],,} == *"${search_term,,}"* ]] ; then
			cout -n "$i"
			return 0
		fi
	done

	echo -n "0"
}
search_index() {
	for i in "${!items[@]}" ; do
		if [[ ${items[$i],,} == "${search_term,,}"* ]] ; then
			cout -n "$i"
			return 0
		fi
	done

	search_index_nonstrict
}

search() {
	lastindex=$index
	tmp_index=$(search_index)

	if [[ $tmp_index -ge 0 ]] ; then
		index=$tmp_index
		reprintlistitem $lastindex
		reprintlistitem $index
	fi


	movecursor 1 $(expr ${#items[@]} + 1)
	printferr "%-${cols}s" "$search_term"

	if [[ $search -eq 1 ]] ; then
		movecursor $(expr $cols - 0) $(expr ${#items[@]} + 1)
		printferr "/"
	fi

	movecursor $cols $lines
}


i=1
for param in $(seq 1 $#) ; do
	case "${!i}" in
		"--center")
			center=1
			;;
		"--force-resize")
			resize=1
			;;
		"--search")
			search=1
			;;
		*)
			items[${#items[@]}]="${!i}"
			minwidth=$(max $(echo -n "${!i}" | wc -c) $minwidth)
			;;
	esac

	i=$(expr $i + 1)
done



#printlist 
#exit

KEY_UP="[A"
KEY_DOWN="[B"
KEY_RIGHT="[C"
KEY_LEFT="[D"
KEY_DELETE=$(cout -e "\x7f" | awk '{printf "%c\n", $1}')
KEY_SPACE_OR_ENTER=""
KEY_MOUSE_EVENT="b"
KEY_DELETE="DELETE"
KEY_ESCAPE="ESCAPE"

# todo fix also width..
fetchsize
[[ $(expr ${#items[@]} + 1) -gt $lines ]] && resize-term $(expr ${#items[@]} + 1)
[[ $resize -eq 1 ]] && resize-term $(expr $minwidth + 3) $(expr ${#items[@]} + 1)
fetchsize

if [[ $(expr ${#items[@]} + 1) -gt $lines ]] ; then
	cerr "window too small"
	exit 1
fi

if [[ $center -eq 1 ]] ; then
	center-term-wnd
fi

printlist
enablemouseevents
setcursor
search

# main loop
while true; do

        #read -rsn1 -t 0.1 tmp
	#if [[ "$tmp" == "[" ]]; then
	#	read -rsn1 -t 0.1 tmp
	#	case "$tmp" in 
	#		"A") printf "Up\n";;
	#		"B") printf "Down\n";;
	#		"C") printf "Right\n";;
	#		"D") printf "Left\n";;
	#	esac
	#fi

	read -rsn1 input
	decimal=$(printfout %d \'$input | xargs)
#echo -n " ";	printf %d \'$input ; echo
	if [[ $decimal -eq 27 ]] ; then
		#echo MOUSE EVENT111
		read -rsn1 input
	elif [[ $decimal -eq 127 ]] ; then
		input=$KEY_DELETE
	fi
	if [[ $input == "[" ]] ; then
		read -rsn1 input2
		case $input2 in
			"A"|"B"|"C"|"D") # arrow keys
				input=$input$input2
				;;
			"M") # mouse events
				input=$input$input2
				for i in $(seq 1 3); do
					read -rsn1 tmpinp
					input=$input$tmpinp
				done
				;;
		esac
	fi

	case $input in 
		$KEY_UP|"K"|"k")
			if [[ $search -eq 1 ]] ; then
				search_term=$search_term$input
				search
				continue
			fi

			lastindex=$index
			index=$(max $(expr $index - 1) 0)
			reprintlistitem $lastindex
			reprintlistitem $index
			;;
		$KEY_DOWN|"J"|"j")
			if [[ $search -eq 1 ]] ; then
				search_term=$search_term$input
				search
				continue
			fi

			lastindex=$index
			index=$(min $(expr $index + 1) $(expr ${#items[@]} - 1))
			reprintlistitem $lastindex
			reprintlistitem $index
			;;
		"q"|"Q"|KEY_ESCAPE)
			if [[ $search -eq 1 ]] ; then
				search_term=$search_term$input
				search
				continue
			fi

			exit 1
			;;
		$KEY_DELETE)
			# todo search function
			if [[ $search -eq 1 ]] ; then
				if [[ $(echo -n $search_term | wc -c) -gt 0 ]] ; then
					search_term=${search_term:0:-1}
				else
					search_term=""
				fi
				search
			fi
			;;
		$KEY_SPACE_OR_ENTER)
			executedselecteditem	
			break
			;;

		"[M#"*) # click release
		#	echo $input "---" ${input:4:1}
		#	zenity --info --text ${input:4:1}

			row=$(getmousepos "${input:4:1}")
			if [[ $row -lt ${#items[@]}
				&& $row -ge 0 ]] ; then
				# redraw and wait to show the clicked item

				lastindex=$index
				index=$row
				reprintlistitem $lastindex
				reprintlistitem $index

				sleep .4

				executedselecteditem 
				break
			fi
			;;
		"/")
			if [[ $search -eq 1 ]] ; then
				search=0
				search_term=""
			else
				search=1
			fi
			search
			;;
		*)
			if [[ $search -eq 1 ]] ; then
				search_term=$search_term$input
				search
			fi
			;;
	esac

done
