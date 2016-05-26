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


get_sandbox_display() {
### selinux
	# returns the x display•
	# of sandboxed firefox
#	echo :$(cat ~/.sandboxes/firefox/seremote | sed 's/[^0-9]//g' | xargs)
### firejail
	cat $HOME/Sandboxes/firefox.new/seremote
}


local scripts='i3\/(display_color.py|lookup.sh)'
local selection=$(xclip -out | xargs)
local selection_s=$(xclip -out -d $(get_sandbox_display) | xargs)

if [[ $(xdotool getwindowfocus getwindowname) == "firejail"* ]] ; then
#selinux: "Sandbox"* ]] ; then
	notify-send -a i3 "changed from $selection to $selection_s"
	local selection=$selection_s
fi


# close windows
if [[ $(pgrep -f $scripts) ]] ; then
	pkill -f $scripts
# open windows
elif [[ ! -z $selection ]] ; then
	if [[ $selection =~ ^#([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$ ]] ; then
		# it's a hex color code - display it
		~/i3/display_color.py "$selection"
	elif [[ $selection =~ ^[0-9]{1,}$ ]] ; then
		# likly a timestamp
		local ts=$selection
		local out=""
		local ms=0

		if [[ $(echo -n $selection | wc -c) -ge 13 ]] ; then
			# ts unit = very likly ms
			ts=$(expr $selection / 1000)
			ms=$(expr $selection % 1000)
		fi

		out=$(date -d @$ts)

		if [[ $ms -gt 0 ]] ; then
			out+=" + "$ms" ms"
		fi

		zenity --info --icon-name="" --text "Timestamp:\n$out" &
	else
		~/i3/lookup.sh $selection
	fi

	~/i3/clear_selection.sh
else
	# switch between modes - normal - move - resize
fi
