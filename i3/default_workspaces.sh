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

# defines workspace variables
# e.g. workspace names

source $HOME/i3/config.sh

declare -A workspaces

workspaces[0]='0'
workspaces[1]='1'
workspaces[2]='2'
workspaces[3]='3'
workspaces[4]='4'
workspaces[5]='5'
workspaces[6]='6'
workspaces[7]='7'
workspaces[8]='8'
workspaces[9]='9'

mkdir -p $tmp_workspaces

for i in {0..10} ; do
	if [[ -f $tmp_workspaces/$i ]] ; then
		workspaces[$i]=$i':'$(cat $tmp_workspaces/$i)
	fi
done
