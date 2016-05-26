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

source $HOME/i3/config.sh

if [[ $tmp_workspaces == *"/tmp/"* ]] ; then
	# default names
	echo 'Tails'	> $tmp_workspaces/0
	echo 'www'	> $tmp_workspaces/1
	echo 'ide'	> $tmp_workspaces/2
fi
