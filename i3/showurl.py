#!/usr/bin/python2
import sys
from PyQt4 import QtCore, QtGui, QtWebKit
from PyQt4.QtWebKit import QWebSettings

# https://srinikom.github.io/pyside-docs/PySide/QtCore/Qt.html
EXIT_KEYS = (QtCore.Qt.Key_Escape, QtCore.Qt.Key_Q)
# print(EXIT_KEYS)

from PyQt4.QtNetwork import QNetworkAccessManager, QNetworkRequest
from requests import Session


class MyNetworkAccessManager(QNetworkAccessManager):
    def createRequest(self, op, request, device=None):
        request.setRawHeader('User-Agent', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.116 Safari/537.36')
        return QNetworkAccessManager.createRequest(self, op, request, device)

class Browser(QtGui.QMainWindow):

    def __init__(self, url):
        """
            Initialize the browser GUI and connect the events
        """

        QtGui.QMainWindow.__init__(self)
        self.setWindowFlags(self.windowFlags() | QtCore.Qt.FramelessWindowHint)
        self.setFixedSize(800,600)
        self.move(1600/2-800/2, 900/2-600/2) 
        self.centralwidget = QtGui.QWidget(self)

        self.mainLayout = QtGui.QHBoxLayout(self.centralwidget)
        self.mainLayout.setSpacing(0)
        self.mainLayout.setMargin(1)

        self.frame = QtGui.QFrame(self.centralwidget)

        self.gridLayout = QtGui.QVBoxLayout(self.frame)
        self.gridLayout.setMargin(0)
        self.gridLayout.setSpacing(0)

        self.horizontalLayout = QtGui.QHBoxLayout()

        self.gridLayout.addLayout(self.horizontalLayout)

        self.html = QtWebKit.QWebView()
        self.netmng = MyNetworkAccessManager()
        self.html.page().setNetworkAccessManager(self.netmng)
        settings = self.html.settings()
        settings.setAttribute(QWebSettings.AutoLoadImages, False)
        settings.setAttribute(QWebSettings.DnsPrefetchEnabled, False)
        # keep javascript disabled!
        settings.setAttribute(QWebSettings.JavascriptEnabled, False)
        settings.setAttribute(QWebSettings.JavaEnabled, False)
        settings.setAttribute(QWebSettings.PluginsEnabled, False)
        settings.setAttribute(QWebSettings.PrivateBrowsingEnabled, True)
        #settings.setAttribute(QWebSettings.DeveloperExtrasEnabled, True)

        self.gridLayout.addWidget(self.html)
        self.mainLayout.addWidget(self.frame)
        self.setCentralWidget(self.centralwidget)
        self.setFocusPolicy(QtCore.Qt.StrongFocus)

        self.installEventFilter(self)
        self.browse(url)

    def browse(self, url):
        """
            Make a web browse on a specific url and show the page on the
            Webview widget.
        """

        self.html.load(QtCore.QUrl(url))
        self.html.show()

    def eventFilter(self, object, event):
        if event.type() == QtCore.QEvent.WindowDeactivate \
             or (type(event) == QtGui.QKeyEvent and event.key() in EXIT_KEYS):
            self.destroy()
            exit()
        return 0

if __name__ == "__main__" and len(sys.argv) > 1:

    app = QtGui.QApplication(sys.argv)
    main = Browser(unicode(sys.argv[1].decode('utf-8')))
    print(sys.argv[1])
    main.show()
    sys.exit(app.exec_())
