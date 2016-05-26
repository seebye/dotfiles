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

# tap to click
$HOME/i3/touchpad_tap_click.sh 

# limit cpu frequency
echo -n normal > $HOME/i3/tmp/cpufreq
$HOME/i3/bin/cpufreq profile=normal 

# disable bluetooth
rfkill block bluetooth 

# lockscreen
# disable screen off after x min
#xset s off
xset -dpms

# persistent clipboard - don't clear after closing a program..
#parcellite &
xfce4-clipman &

# lock after 5 min
xautolock -time 5 -locker '$HOME/i3/lock.sh' &
# unless we're using fullscreen
$HOME/i3/lock_detect_fullscreen.sh &

# Compton / animations + transparency
compton --config ~/.config/compton/config --opacity-rule 90:"class_g = 'XTerm'" &

# wifi icon
nm-applet &

# display notifications
# some settings - not mentioned inside of the man page
# https://github.com/knopwob/dunst/blob/master/dunstrc
# https://gist.github.com/594727294/2f218571089768870974
# http://twily.info/.config/dunst/dunstrc
# dunst -geometry "250x500+1330+50" -fn "Droid Sans Mono Awesome 10" -lb "#000000" -lf "#ffffff" -nb "#000000" -nf "#ffffff" -padding 5 -horizontal_padding 10 -allow_markup yes -format "<b>%a</b>\n%s" -separator_color "#252525" -show_indicators yes &
$HOME/i3/dunst_queue_handler.sh &

# init workspaces
# reset workspace names
$HOME/i3/clear_workspaces.sh
$HOME/i3/init_workspaces.sh
# switch to workspace 1
$HOME/i3/switch_workspace.sh 1


# GUI - utils for a comfortable desktop
# launcher
sh -c 'sleep 10 ; albert &' &

#autokey-gtk &

# drop down terminal
/opt/altyo/altyo &

# autostart
keepass &
