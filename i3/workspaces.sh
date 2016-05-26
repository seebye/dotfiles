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

# defines util functions for workspaces

source $HOME/i3/basic.sh
source $HOME/i3/default_workspaces.sh

function get_current_workspace() {
	i3-msg -t get_workspaces | jq ".[] | select(.focused == true)"
}

# searches workspace index by name
function find_workspace_index() {
	inp=$1

	if [[ $# == 0 ]] ; then
		inp=$(readpipe)
	fi

	local result=$(i3-msg -t get_workspaces | jq "map(.name) | index(\"$inp\")")

	if [[ $result != "null" ]] ; then
		echo $result
		return 0
	fi

	return 1
}

function get_workspace_count() {
	i3-msg -t get_workspaces | jq "length"
}

function get_workspace_at() {
	inp=$1

	if [[ $# == 0 ]] ; then
		inp=$(readpipe)
	fi

	i3-msg -t get_workspaces | jq ".[$inp]"
}

# returns the id of the workspace
#         or -1 if the workspace has no id
#         (additional workspace which starts with e.g. +)
function get_workspace_id() {
	inp=$@

	if [[ $# == 0 ]] ; then
		inp=$(readpipe)
	fi

	echo $inp | jq ".num"
}

function get_workspace_name() {
	inp=$@

	if [[ $# == 0 ]] ; then
		inp=$(readpipe)
	fi

	echo $inp | jq ".name" | sed 's/"//g'
}
