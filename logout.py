#!/usr/bin/python

import curses
import os
import time

# script for drawing simple logout menu in
# terminal

lockColor = "#222222"


def initCurses():

    # init curses interface
    stdscr = curses.initscr()

    # colors
    curses.noecho()
    curses.cbreak()
    stdscr.keypad(1)
    curses.curs_set(0)  # no cursor

    return stdscr


def endCurses():
    # terminate curses application
    curses.nocbreak()
    curses.echo()
    stdscr.keypad(0)
    curses.endwin()


class Menu:

    def __init__(self, stdscr, rows, cols):
        self.scr = stdscr
        self.rows = rows
        self.cols = cols

        self.title = 'Logout Menu'
        self.menuEntries = ['Lock screen', 'Log out', 'Suspend',
                            'Restart', 'Power off']
        self.titleOffset = 2
        self.pointerPosition = 0

        self.lock = False

    def drawMenu(self):

        self.scr.clear()

        try:
            self.scr.addch(rows - 1, 0, 'Q', curses.A_BOLD)
            self.scr.addstr(rows - 1, 1, 'uit')
            self.scr.addch(rows - 1, 6, 'L', curses.A_BOLD)
            self.scr.addstr(rows - 1, 7, 'ock: ' + str(self.lock))
        except curses.error:
            pass

        try:
            self.scr.addstr(0,
                            (self.cols - len(self.title)) // 2,
                            self.title, curses.A_BOLD)
        except curses.error:
            pass

        row = self.titleOffset
        for entry in self.menuEntries:
            disp = '  ' + entry + '  '
            if row == self.pointerPosition + self.titleOffset:
                disp = '+ ' + entry + ' +'
                try:
                    self.scr.addstr(row,
                                    (self.cols - len(disp)) // 2,
                                    disp)
                except curses.error:
                    pass
            else:
                try:
                    self.scr.addstr(row,
                                    (self.cols - len(disp)) // 2,
                                    disp)
                except curses.error:
                    pass

            row = row + 1

        self.scr.refresh()

    def switchLock(self):
        self.lock = not self.lock
        if self.lock == True:
            self.menuEntries[2] = 'Suspend (lock)'
        else:
            self.menuEntries[2] = 'Suspend'
        self.drawMenu()

    def moveUp(self):
        self.pointerPosition = (self.pointerPosition -
                                1) % len(self.menuEntries)
        self.drawMenu()

    def moveDown(self):
        self.pointerPosition = (self.pointerPosition +
                                1) % len(self.menuEntries)
        self.drawMenu()

    def menuExec(self):

        if self.pointerPosition == 0:
            os.system('i3lock -c "' + lockColor + '"')
        elif self.pointerPosition == 1:
            os.system('i3-msg exit')  # logout
            # self.scr.addstr(0,0,str(self.pointerPosition))
        elif self.pointerPosition == 2:
            if self.lock:
                os.system('i3lock -c "' + lockColor + '"')
            else:
                os.system('systemctl suspend')  # suspend
            # self.scr.addstr(0,0,str(self.pointerPosition))
        elif self.pointerPosition == 3:
            os.system('systemctl reboot')  # restart
            # self.scr.addstr(0,0,str(self.pointerPosition))
        elif self.pointerPosition == 4:
            os.system('systemctl poweroff')  # power off
            # self.scr.addstr(0,0,str(self.pointerPosition))


if __name__ == '__main__':

    stdscr = initCurses()

    # terminal size
    rows, columns = os.popen('stty size', 'r').read().split()
    rows = int(rows)
    columns = int(columns)

    menu = Menu(stdscr, rows, columns)
    menu.drawMenu()
    while True:
        c = stdscr.getch()
        if c == ord('q'):
            break
        if c == ord('l'):
            menu.switchLock()
        if c == curses.KEY_UP:
            menu.moveUp()
        if c == curses.KEY_DOWN:
            menu.moveDown()
        if c == 10:  # enter key
            menu.menuExec()

    endCurses()
