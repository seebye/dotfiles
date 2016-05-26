#!/usr/bin/env bash
# source: https://www.reddit.com/r/archlinux/comments/3wmwxc/how_can_i_set_xautolock_not_trigger_lock_when/
#
# checks every two minutes whether the fullscreen mode is used
# if it's used the screensaver will be disabled otherwise enabled
#
# also checks the time and

while true
do
    activ_win_id=`xprop -root _NET_ACTIVE_WINDOW`
    if [[ $(xprop -id ${activ_win_id:40:9} | grep _NET_WM_STATE_FULLSCREEN) ]] ; then
	# fullscreen
	xset s off
    else
	xset s on
    fi
    sleep 120
done
