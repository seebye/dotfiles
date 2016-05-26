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

$HOME/i3/lemonbar-music.sh | lemonbar -b -B "#00000000" -F "#fff" -g 1600x20+0+0 -f "FontAwesome:size=10" -f "Monospace:letterSpace=-5:size=7" -f "Ubuntu Mono derivative Powerline:size=10" | bash
