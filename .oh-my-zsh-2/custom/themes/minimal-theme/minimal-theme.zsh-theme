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

# [m]inimalistic [t]heme

#MT_GRAY='\e[38;5;238m'
MT_GRAY='\e[38;5;243m'
#MT_GRAY='\e[38;5;244m'
#$fg[magenta]%
MT_HIGHLIGHT='\e[38;5;209m'

MT_CURSOR_COLOR_VI='#D15F46'
MT_CURSOR_COLOR_INSERT='#FFFFFF'


MT_LEFTPROMPT=' ———— '



# Git info.
local git_info='$(git_prompt_info)'
local git_last_commit='$(git log --pretty=format:"%h \"%s\"" -1 2> /dev/null)'
ZSH_THEME_GIT_PROMPT_PREFIX="${YS_VCS_PROMPT_PREFIX1}git${YS_VCS_PROMPT_PREFIX2}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$YS_VCS_PROMPT_SUFFIX"
ZSH_THEME_GIT_PROMPT_DIRTY="$YS_VCS_PROMPT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="$YS_VCS_PROMPT_CLEAN"

mt_short_path() {
	local tmppath=$(echo -n $1 | sed 's/ /\\ /g' | sed 's/\\\\ /\\ /g')
	local disable_formatting=$2

	if [[ $(echo -n $tmppath | wc -c) -le 15 ]] ; then
		[[ -z $disable_formatting ]] && echo -n "%{$terminfo[bold]%}"
		echo -n $tmppath
		[[ -z $disable_formatting ]] && echo -n "%{$reset_color%}"
	else
		local part0="$tmppath"
		local part1=""
		if [[ $(echo -n $tmppath | sed 's/[^\/]*//g' | wc -c) -ge 2 ]] ; then
			part0=$(echo -n "$tmppath" | sed 's/\(.*\)\/[^\/]*\/[^\/]*$/\1/')
			part1=$(echo -n "$tmppath" | sed 's/.*\(\/[^\/]*\/[^\/]*\)$/\1/')
		fi

		[[ -z $disable_formatting ]] && echo -n "%{$reset_color%}"
		[[ -z $disable_formatting ]] && echo -n '%{\033[38;5;253m%}'
		echo -n "$part0" | sed 's/\([^ ~_\-\/\.]\)[^ ~_\-\/\.]*/\1/g'
		[[ -z $disable_formatting ]] && echo -n "%{$reset_color%}"
		[[ -z $disable_formatting ]] && echo -n "%{$terminfo[bold]%}"
		echo -n "$part1"
		[[ -z $disable_formatting ]] && echo -n "%{$reset_color%}"
	fi
}

mt_amimyself() {
	local user=$(whoami)

	if [[ $user != $default_user ]] ; then
		echo -n "%{$fg[blue]%}%n %{$fg[white]%}in %{$reset_color%}"
	fi
}


mt_pwd_short() {
	local TMP_PWD=$(echo -n $(pwd) | sed "s|$HOME|~|")
	mt_short_path "$TMP_PWD" $1
}

mt_time() {
	date +%H:%M:%S
}

function mt_rewritable_message() {
	local rwm_t0=$(mt_time)
	local rwm_t1=$(git_prompt_info)
	local rwm_t2=$(git log --pretty=format:"%h \"%s\"" -1 2> /dev/null)
	local rwm_t=$(echo -n "$rwm_t0 $rwm_t1 $rwm_t2" | xargs)
	local rwm_te=''
				#   	    cols    - len(right-prompt)         - len(brackets) - len(..\ ) - len(left-prompt)			fix?	# default max len
	local rwm_max_size=$(min    $(expr $COLUMNS - $(mt_pwd_short 1 | wc -c) - 2             - 3         - $(echo -n $MT_LEFTPROMPT | wc -c) + 7)	50)

	if [[ $(echo $rwm_t | wc -c) -gt $rwm_max_size ]] ; then
		local rwm_te='..'
	fi

	echo -n $(echo -n ${rwm_t:0:$rwm_max_size} | xargs)$rwm_te
}

function precmd() {
	(
		sleep .05
		local msg=$(mt_rewritable_message)

		echo -ne $MT_GRAY
		echo -n $(echo -n $msg | sed 's/\n//')
		echo -ne "$reset_color"

		# vi mode - reset cursor - new command -> insert mode (zle-keymap-select not called)
		cursor_insert

		mt_move_cursor left $(echo -n $msg | wc -c)
	) &!
}

mt_move_cursor() {
	case $1 in 
		top)
			echo -ne '\e['$2'A'
		;;
		right)
			echo -ne '\e['$2'C'
		;;
		bottom)
			echo -ne '\e['$2'B'
		;;
		left)
			echo -ne '\e['$2'D'
		;;
	esac
}

preexec() {
	# clean command line
	if [[ $(echo -n "$1" | wc -c) -lt 50 ]] ; then
		mt_move_cursor top 1
		mt_move_cursor right 6

		printf '%-52s' "$1"

		mt_move_cursor bottom 1
		mt_move_cursor left 200
	fi

	# draw start time
	echo -ne $MT_GRAY
	echo " $(mt_time)\n"
	echo -ne "$reset_color"
}

set-cursor-color() {
	print -n '\e]12;'$1'\a'
}


# todo show vi mode (by e.g. coloring the last char of the left prompt? 
# 			- or something else (could lead to problems on multi line commands)
# 			- maybe it's a good idea to change the color of the cursor "print -n '\e]12;pink\a'" / "print -n '\e]12;#abcdef\a'"
# 			  or/and change the cursor type e.g. to block)
# enable vi mode by "bindkey -v"
# vicmd
cursor_insert() {
	set-cursor-color $MT_CURSOR_COLOR_INSERT
}
cursor_vi() {
	set-cursor-color $MT_CURSOR_COLOR_VI
}
function zle-keymap-select () {
	case $KEYMAP in 
		vicmd)
			# mode which allows to use vi modes e.g. v to select i to insert text
			cursor_vi
			;;
		viins|main)
			# insert mode / normal mode
			cursor_insert
			;;
		*)
			echo "zsh vi - unknown mode: %KEYMAP"
			;;
	esac
}

# Prompt format: \n # TIME USER at MACHINE in [DIRECTORY] on git:BRANCH STATE \n $ 
PROMPT="
%(?.$(echo -n "%{$MT_GRAY%}").$(echo -n "%{$MT_HIGHLIGHT%}"))$MT_LEFTPROMPT%{$reset_color%}"
RPROMPT='$(mt_amimyself)%{$terminfo[bold]%}[$(mt_pwd_short)%{$terminfo[bold]%}]%{$reset_color%}'
#%(?.$(echo -n '\033[38;5;238m').%{$fg[magenta]%}) ———— %* %{$reset_color%}\

#PS1=$PROMPT
#RPS1=$RPROMPT
