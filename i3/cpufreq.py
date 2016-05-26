#!/usr/bin/python3
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

import os
import sys
from re import match
import subprocess

def shell(cmd):
    output = subprocess.check_output("export LC_ALL=en_US.UTF-8 ; " + cmd, shell=True)
    return output.decode('utf8').strip()

def get_cpu_usage(cpus=[], debug=False):
    if len(cpus) == 0:
        cpus += [name for name in os.listdir("/sys/devices/system/cpu/") \
                 if name.startswith("cpu") and match(r".*[0-9]+$", name)]
    maxcr = 0
    cr = 0
    lencpus = len(cpus)

    for cpu in cpus:
        if debug: print(cpu)
        # kHz
        with open("/sys/devices/system/cpu/" + cpu
                          +"/cpufreq/scaling_max_freq") as f:
            maxtmp = int(f.read().strip())
            maxcr += maxtmp
            if debug: print('max', maxtmp)
        with open("/sys/devices/system/cpu/" + cpu
                          +"/cpufreq/scaling_cur_freq") as f:
            crtmp = int(f.read().strip())
            cr += crtmp
            if debug: print('cr ', crtmp)

            # MHz
            # return "%{A:~/.bin/cpu_profile.sh:}"+ ("%d / %d MHz" % (int((
            # cr /
            # lencpus)/1000), int((maxcr / lencpus)/1000))) +"%{A}"
    return "%01.1f" % round((cr / lencpus) / 1000 / 1000, 1)

def get_load_avg_lastmin():
    return shell("uptime | sed 's/.*load average: //' |     sed 's/,.\+//'")

if __name__ == '__main__':
    debug = len(sys.argv) > 1 and sys.argv[1] == 'debug'
    print(get_cpu_usage(debug=debug), get_load_avg_lastmin())#, "\n\n#bd5d4c")
