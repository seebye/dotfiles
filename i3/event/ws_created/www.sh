#!/usr/bin/env bash


$HOME/i3/focus_wnd.sh parent
$HOME/i3/focus_wnd.sh parent
$HOME/i3/focus_wnd.sh parent

$HOME/i3/layout_mode.sh tabbed


# hide bar
# needed for privacy reasons 
# - selinux sandbox will use a very rare screen resolution otherwise
#only needed for selinux sandbox#i3-msg bar mode invisible

$HOME/i3/sandfox.sh &
#firejail supports audio -> we don't need to use the "normal" firefox anymore#( sleep 4 ; firefox ) &
#sleep 2

# show bar
#only needed for selinux sandbox#3-msg bar mode dock
