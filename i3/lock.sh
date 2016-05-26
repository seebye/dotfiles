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

source $HOME/i3/process_utils.sh

if [[ ! $(pgrep i3lock) \
	|| $(ps -p $(pgrep i3lock) -o etimes=) -gt $(expr 15 \* 60) ]] ; then
	#pkill -f lock.sh
	killall i3lock

	$HOME/i3/i3lock-fancy/lock

	sleep 60

else
	exit 1
fi

if [[ $(pgrep i3lock) ]] ; then
	xset dpms force off

	battery_used=$(acpi -b | grep -i discharging)
	pgrep_i3l=$(pgrep i3lock)

	# lock password manager
	keepass --lock-all

	# reduce energy consumption
	if [[ ! -z $battery_used ]] ; then
		$HOME/i3/bin/freeze
		xrandr --output eDP1 --brightness .8
		#systemctl hybrid-sleep
		#systemctl suspend
	fi

	# enable screen timeout
	xset +dpms

	# wait until unlock
	while [[ $(pgrep i3lock) == $pgrep_i3l ]] ; do
		sleep 10
	done

	killall i3lock

	# disable screen timeout
	xset -dpms

	exit 0
fi
