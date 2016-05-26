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

local url=""
local text=$(echo $1 | sed 's/\&/\%26/g') # | xxd -plain | tr -d '\n' | sed 's/\(..\)/%\1/g')
if [[ $text == '' ]] ; then
	echo "There's no selected text" >&2
	return
fi


local service=$($HOME/i3/menu_list.sh --center --force-resize --search \
		"ArchLinux Wiki" \
		"Wikipedia" \
		"Linguee" \
		"Dict.cc" \
		"Wiktionary" \
		"Duden" \
		"Anilist" \
		"cpp")

case $service in
	Arch*)
		local url="https://wiki.archlinux.org/index.php?title=Special%3ASearch&search=$text"
	;;
	Wiki*)
		local url="https://de.m.wikipedia.org/w/index.php?search=$text&mobile"
	;;
	L*)
		local url="https://m.linguee.de/deutsch-englisch/search?source=auto&cw=336&query=$text&mobile"
	;;
	Di*)
		local url="http://www.dict.cc/?s=$text&mobile"
	;;
	Wikt*)
		local url="https://de.m.wiktionary.org/w/index.php?search=$text&mobile"
	;;
	Du*)
		local url="http://www.duden.de/suchen/dudenonline/$text?&mobile"
	;;
	A*)
		local url="https://anilist.co/search?q=$text&mobile"
	;;
	cpp)
		local url="http://en.cppreference.com/mwiki/index.php?title=Special%3ASearch&search=$text&button="
	;;
esac

if [[ $url != "" ]] ; then
	firejail --blacklist=/run/media --noroot /home/nico/i3/showurl.py "$url"
fi
