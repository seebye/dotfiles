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

function get_pids() {
	processes="$@"
	processes_pattern='[0-9]{1,2}:[0-9]{2} *(\/usr\/bin\/mono |/usr/bin/python )?[\/a-z0-9\    -_]*'$processes
	ps axl | awk '$2 != 0 && $7 != 0 && $10 !~ "Z"' | grep -vi grep  | grep -iP "$processes_pattern" | sed 's/ \+/ /g' | cut -d' ' -f 3
}
