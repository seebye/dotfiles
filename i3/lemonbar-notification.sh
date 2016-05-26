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

HIGHLIGHT_COLOR=$COLOR_ACCENT_HEX_RAW

bold() {
	echo -n "%{T2}$@%{T-}"
}

highlight() {
	echo -n "%{F#$HIGHLIGHT_COLOR}"$(bold "$@")"%{F-}"
}


appname=$1
body=$2

echo "%{c}$(highlight $appname) $body"

# todo support ongoing notifications (dismissed by a click) 
# via lemonbars click support + printing the pid of this script ($$ contains the pid)
# piped to a script which will kill the process of the printed pid 
# -> lemonbar will close itself as this script is no longer running (after a click)
sleep 15
