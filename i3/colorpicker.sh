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

if [[ $(pgrep gcolor3) ]] ; then
	notify-send -a i3 "Color picker is already running.."
	exit 1
fi


killall compton
compton --config $HOME/.config/compton/config.nodim &
gcolor3
killall compton
compton --config $HOME/.config/compton/config --opacity-rule 90:"class_g = 'XTerm'" &
