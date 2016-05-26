#!/usr/bin/env bash

# todo...

source $HOME/i3/workspaces.sh

local nextws_name=$(zenity --entry --text "New workspace name")
local curws_name=$(get_current_workspace | get_workspace_name)

if [[ ! -z $nextws_name && ! $(find_workspace_index $nextws_name) ]] ; then
	if [[ ! -z $nextws_name
		&& $(source $HOME/i3/event/leave_workspace.sh $curws_name $nextws_name &>/dev/null ; echo $?) == 0 \
		&&  $(source $HOME/i3/event/create_workspace.sh $nextws_name &>/dev/null ; echo $?) == 0 \
		&& $(source $HOME/i3/event/enter_workspace.sh $curws_name $nextws_name &>/dev/null ; echo $?) == 0 ]] ; then

		i3-msg rename workspace "$curwsname" to "$newname"

		# events

	else
		zenity --error --text "Sorry, you can't rename this workspace!"
	fi
	
fi
