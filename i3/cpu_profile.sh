#!/usr/bin/zsh

#tmp=$(zenity --list --text "CPU Profile" --column " " quiet morequiet normal performance endurance | tail -n 1)
#echo -n $tmp > $HOME/i3/tmp/cpufreq
#~/i3/bin/cpufreq profile=$tmp

xterm -T "CPU Profile" -e $HOME/i3/cpu_profiles_menu.sh

