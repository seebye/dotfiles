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

# called AFTER creating a new workspace
# args:
#	1. name of the new workspace

#notify-send -a i3 "created $1"

cmd=""

case $1 in
	*":www")
		cmd="$HOME/i3/event/ws_created/www.sh"
		;;
	*) # default
		;;
esac

if [[ ! -z $cmd \
	&& $(sleep .5 ; zenity --question --text "Autostart?\n$cmd" ; echo $?) == 0 ]] ; then
	$cmd &
fi
