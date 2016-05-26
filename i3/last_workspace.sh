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

# switch to the last workspace

source $HOME/i3/workspaces.sh

len=$(get_workspace_count)
index=$(get_current_workspace | get_workspace_name | find_workspace_index)

last=$([[ $(expr $index - 1 + 1) > 0 ]] && expr $index - 1 || expr $len - 1)
#echo $index ":" $last ":" $(get_workspace_at $last) # | get_workspace_name)
$HOME/i3/switch_workspace_name.sh $(get_workspace_at $last | get_workspace_name)
