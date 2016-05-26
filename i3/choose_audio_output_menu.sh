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

#cmd_dialog="zenity --list --text 'choose audio output' --column 'id' --column 'name'"
cmd_dialog="$HOME/i3/menu_list.sh --search"

# search for output devices
i=1
for part in $(pactl list sinks short | awk -F '\t' '{print $2}') ; do
	cmd_dialog=$cmd_dialog" \"$i $part\""
	i=$(expr $i + 1)
done


id_device=$(eval $cmd_dialog | xargs | sed 's/^[0-9]* *//' | xargs)
#echo $id_device ; exit
[[ -z $id_device ]] && exit

id_sink=$(pactl list sink-inputs | grep Input | sed 's/[^0-9]*//g')

echo " selection: $id_device $id_sink"

pacmd set-default-sink $id_device

if [[ $id_sink ]] ; then
	pacmd move-sink-input $id_sink $id_device
fi
