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

# 1. arg = workspace name

source $HOME/i3/workspaces.sh

curws=$(get_current_workspace)
curws_name=$(get_workspace_name $curws)
nextws_name=$1

if [[ $curws_name == $nextws_name ]] ; then
	nextws_name=$(cat $tmp_workspaces/last)
fi

nextws_exists=$(find_workspace_index $nextws_name)


if [[ ! -z $nextws_name
	&& $(source $HOME/i3/event/leave_workspace.sh $curws_name $nextws_name &>/dev/null ; echo $?) == 0 \
	&& ($nextws_exists || $(source $HOME/i3/event/create_workspace.sh $nextws_name&>/dev/null ; echo $?) == 0) \
	&& $(source $HOME/i3/event/enter_workspace.sh $curws_name $nextws_name &>/dev/null ; echo $?) == 0 ]] ; then

	i3-msg workspace $nextws_name

	echo $curws_name > $tmp_workspaces/last

	$HOME/i3/event/leaved_workspace.sh $curws_name $nextws_name
	[[ ! $(find_workspace_index $curws_name) ]] && source $HOME/i3/event/destroyed_workspace.sh $curws_name
	[[ ! $nextws_exists ]] && $HOME/i3/event/created_workspace.sh $nextws_name
	$HOME/i3/event/entered_workspace.sh $curws_name $nextws_name
fi
