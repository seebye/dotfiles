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

# called BEFORE leaving a workspace
# args:
#	1. current workspace
#	2. next workspace
#
# return 0 to allow leaving,
#	 anything else to stop
ws_name=$1

return 0

# todo move this code to enter_workspace and warp inside of {} &
# todo create workspace switcher which shows these preview images

#notify-send -a i3 "leaving $1 to enter $2"
file="/tmp/i3/workspaces/screenshots/"$(echo $1 | md5sum - | cut -d ' ' -f 1)".jpeg"
scrot $file
FONT="$(convert -list font | awk "{ a[NR] = \$2 } /family: $(fc-match sans -f "%{fam    ily}\n")/ { print a[NR-1]; exit }")"
convert $file -define modulate:colorspace=HSB -modulate 50 -font $FONT -pointsize 66 -fill white -gravity center -annotate +0+0 $ws_name $file

# overlay with color
# vpn indicator? (background)
# create tutorial for convert: https://www.imagemagick.org/Usage/color_mods/
convert "$file2" -define modulate:colorspace=HSB -modulate 100 +level-colors gold, "$file.2.png"

return 0
