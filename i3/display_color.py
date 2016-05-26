#!/usr/bin/python2
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

import sys
from PyQt4 import QtCore, QtGui, QtWebKit
from re import match, I
# https://srinikom.github.io/pyside-docs/PySide/QtCore/Qt.html
EXIT_KEYS = (QtCore.Qt.Key_Escape, )
print(EXIT_KEYS)

class Popup(QtGui.QMainWindow):

    def __init__(self, color):
        """
            Initialize the browser GUI and connect the events
        """

        QtGui.QMainWindow.__init__(self)
        size = 100
        self.setWindowFlags(self.windowFlags() | QtCore.Qt.FramelessWindowHint)
        self.setFixedSize(size,size)
        self.move(1600/2-size/2, 900/2-size/2) 
	self.centralwidget = QtGui.QWidget(self)
        
        self.w = QtGui.QWidget()
        self.w.setStyleSheet('background: '+color)#Qt.red)
        
        self.setCentralWidget(self.w)
        self.setFocusPolicy(QtCore.Qt.StrongFocus)

        self.installEventFilter(self)

    def eventFilter(self, object, event):
        if event.type() == QtCore.QEvent.WindowDeactivate \
             or (type(event) == QtGui.QKeyEvent and event.key() in EXIT_KEYS):
            self.destroy()
            exit()
        return 0

if __name__ == "__main__" and len(sys.argv) > 1 and\
       match('^#([0-9a-f]{3}|[0-9a-f]{6})$', sys.argv[1], I):

    app = QtGui.QApplication(sys.argv)
    main = Popup(sys.argv[1])
    main.show()
    sys.exit(app.exec_())
