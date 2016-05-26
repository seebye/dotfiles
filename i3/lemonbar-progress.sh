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

DEFAULT_COLOR="%{F#$COLOR_TEXT_HEX_RAW}"
DEFAULT_PRO_COLOR_RAW=${COLOR_ACCENT_HEX_RAW}

repeatstr() {
	local times=$1
	local seq=$2

	[[ $times -le 0 ]] && return 0

	for i in {1..$times} ; do
		echo -n "$seq"
	done
}

progressbar() {
	local cur=$1
	local max=$2
	local color=$3

	#[[ -z $color ]] && local color="${COLOR_ACCENT_HEX_RAW}"
	[[ -z $color ]] && local color=$DEFAULT_PRO_COLOR_RAW #"FE7457"


	#line_d="–"
	line_d="—"
	vert_d="❘"

	echo -n "%{F#$color}"$(repeatstr $cur $line_d)"$vert_d%{F#99$COLOR_TEXT_HEX_RAW}"$(repeatstr $(expr $max - $cur) $line_d)$DEFAULT_COLOR
}
