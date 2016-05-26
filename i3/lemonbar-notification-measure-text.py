#!/usr/bin/env python3
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


from tkinter import *
from sys import argv

# CALCULATE:
def measure(font, text):
    global frame

    measure = Label(frame, font=font, text=text)
    measure.grid(row = 0, column = 0) # put the label in
    measure.update_idletasks() # this is VERY important, it makes python calculate the width
    return measure.winfo_width() # get the width

def usage():
    print("usage: ", argv[0], " [font-app] [font-other] [text-app] [text-other]")

if __name__ == '__main__':

    global frame
    
    if len(argv) != 5:
        usage()
        exit()

    font_app=tuple(argv[1].split(":"))
    font_other=tuple(argv[2].split(":"))
    text_app=argv[3]
    text_other=argv[4]

    Window = Tk()
    Window.geometry("1600x900+0+0")
    Window.withdraw()

    frame = Frame(Window)
    frame.pack(side = "top")

    print(measure(font_app, text_app) + measure(font_other, text_other))
