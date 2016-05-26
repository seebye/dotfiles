#!/usr/bin/zsh
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

local tvused=$(~/i3/get_default_sink.sh | grep tv)
local running=$(~/i3/is_sink_used.sh | grep running)
local maxvol=65536

# bad solution for volume down -> todo # tv used && running && mav vol
#if [[ $tvused && $running && $(amixer sget Master | grep $maxvol) ]] ; then
#	~/i3/tv.sh KEY_VOLDOWN
# tv used && no sink running
#elif [[ $tvused && -z $running ]] ; then
if [[ $tvused ]] ; then
	~/i3/tv.sh KEY_VOLDOWN
else
	amixer -q sset Master 1310- unmute
	$HOME/i3/lemonbar-popup-progress-show.sh "$HOME/i3/lemonbar-audio.sh"
fi
