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


i3-msg "floating enable ; sticky toggle"
# there's no way to instantly differntiate the modes
# -> inform user about the execution via a notification
notify-send -a i3 -t 1 'sticky toggled'
