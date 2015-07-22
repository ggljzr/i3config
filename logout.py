
import curses
import os
import time

#script for drawing simple logout menu in
#terminal

def initCurses():

	#init curses interface
	stdscr = curses.initscr()

	#colors
	curses.noecho()
	curses.cbreak()
	stdscr.keypad(1)
	curses.curs_set(0) #no cursor
	
	return stdscr


def endCurses():
	#terminate curses application
	curses.nocbreak();curses.echo();stdscr.keypad(0)
	curses.endwin()


class Menu:
	def __init__(self, stdscr, rows, cols):
		self.scr = stdscr
		self.rows = rows
		self.cols = cols
	
		self.title = 'Logout Menu'
		self.menuEntries = ['Log out', 'Suspend',
				'Restart', 'Power off']
		self.titleOffset = 2;
		self.pointerPosition = 0;

	def drawMenu(self):


		self.scr.clear()
		
		try:
			stdscr.addstr(rows-1,0, 'Press q to cancel')
		except curses.error:
			pass
		
		try:
			self.scr.addstr(0,
					(self.cols - len(self.title))//2,
					self.title)
		except curses.error:
			pass
	
		row = self.titleOffset
		for entry in self.menuEntries:
			disp = '  ' + entry + '  '
			if row == self.pointerPosition + self.titleOffset:
				disp = '+ ' + entry + ' +'
				try:
					self.scr.addstr(row,
							(self.cols - len(disp))//2,
							disp)
				except curses.error:
					pass
			else:
				try:
					self.scr.addstr(row,
							(self.cols - len(disp))//2,
							disp)
				except curses.error:
					pass

			row = row + 1

		self.scr.refresh()

	def moveUp(self):
		self.pointerPosition = (self.pointerPosition - 1) % len(self.menuEntries)
		self.drawMenu();
	
	def moveDown(self):
		self.pointerPosition = (self.pointerPosition + 1) % len(self.menuEntries)
		self.drawMenu();

	def menuExec(self):
		
		if self.pointerPosition == 0:
			os.system('i3-msg exit')			#logout
			#self.scr.addstr(0,0,str(self.pointerPosition))
		elif self.pointerPosition == 1:
			os.system('systemctl suspend')			#suspend
			#self.scr.addstr(0,0,str(self.pointerPosition))
		elif self.pointerPosition == 2:
			os.system('systemctl reboot')			#restart
			#self.scr.addstr(0,0,str(self.pointerPosition))
		elif self.pointerPosition == 3:
			os.system('systemctl halt')			#power off
			#self.scr.addstr(0,0,str(self.pointerPosition))
	

if __name__ == '__main__':

	stdscr = initCurses()

	#terminal size
	rows, columns = os.popen('stty size', 'r').read().split()
	rows = int(rows) 
	columns = int(columns)


	menu = Menu(stdscr, rows, columns)
	menu.drawMenu()
	while True:
		c = stdscr.getch()
		if c == ord('q'):
			break
		if c == curses.KEY_UP:
			menu.moveUp()
		if c == curses.KEY_DOWN:
			menu.moveDown()
		if c == 10: #enter key
			menu.menuExec()

	endCurses()



