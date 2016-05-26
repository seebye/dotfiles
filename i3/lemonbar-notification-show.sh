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


notification=$1
max_size=92
padding=10
screen_width=1600
font_app="Ubuntu Mono derivative Powerline"
font_other="Ubuntu Mono derivative Powerline"

extract_info() {
	local target_key=$1
	local after_target_key=$2

	# extracting target values + surrounding keys
	extracted=$(echo -n "$notification" | grep -Pzo "\s${target_key}\:\s'[^']+'\n.*${after_target_key}: '")
	# removing surrounding keys
	extracted=$(echo -n $extracted | sed "s/^$target_key:\s'//" | sed "s/'\s$after_target_key:\s'//")

	echo -n "${extracted}"
}

get_notification_text() {
	local appname=$1
	local summary=$2
	local body=$3
	local out=""

	if [[ $summary == $body ]] ; then
		local body=""
	elif [[ $body == "$summary"* ]] ; then
		local summary=$body
		local body=""
	fi

	if [[ $(echo -n $body | wc -c) -gt 0 ]] ; then
		local out=" / $summary / $body"
	else
		local out=" / $summary"
	fi

	if [[ $(echo -n "$appname$out" | wc -c) -gt $max_size ]] ; then
		local out="$(echo -n ${out:0:$(expr $max_size - ${#appname} - 2)} | xargs -0).."
	fi

	echo $out
}

appname=$(extract_info "appname" "summary")
summary=$(extract_info "summary" "body")
body=$(extract_info "body" "icon")

body=$(get_notification_text "$appname" "$summary" "$body")

text_length=$($HOME/i3/lemonbar-notification-measure-text.py "$font_app:10:bold" "$font_other:10" "$appname" "$body")
text_length=$(expr $text_length + $padding)
echo "$text_length"
x=$(expr $screen_width / 2 - $text_length / 2)
echo "$x"

$HOME/i3/lemonbar-notification.sh "$appname" "$body" | lemonbar -d -B "#99000000" -F "#fff" -g "${text_length}x20+${x}+0" -f "$font_other:minspace=True:size=10" -f "$font_app:minspace=True:size=10:bold"
#$HOME/i3/lemonbar-notification.sh "$1" | lemonbar -d -B "#33000000" -F "#fff" -g 700x20+450+0 -f "Ubuntu Mono derivative Powerline:size=10" -f "Ubuntu Mono derivative Powerline:size=10:bold"
