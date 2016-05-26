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

# switch to the next workspace

source $HOME/i3/workspaces.sh

len=$(get_workspace_count)
index=$(get_current_workspace | get_workspace_name | find_workspace_index)

next=$([[ $(expr $index + 1) < $len ]] && expr $index + 1 || echo 0)
#echo $index ":" $next ":" $(get_workspace_at $next) # | get_workspace_name)
$HOME/i3/switch_workspace_name.sh $(get_workspace_at $next | get_workspace_name)
