/*********************************************************************
 *
 * Copyright (C) 2003,  Blekinge Institute of Technology
 *
 * Filename:      helpers.c
 * Author:        Simon Kagstrom <ska@bth.se>
 * Description:   Library with helpers for the nibbles game
 *
 * $Id: helpers.c 4937 2005-10-06 12:50:50Z ska $
 *
 ********************************************************************/
#include <unistd.h>
#include <stdlib.h>
#include <time.h>
#include <curses.h>

static WINDOW *p_screen;
WINDOW *win;
int width; 
int height;

int nib_poll_kbd(void)
{
  int key = getch();

  return key;
}

int rand_x()
{
	int random;
	random = rand()%99;
	return random + 1;
}
int rand_y()
{
	int random;
	random = rand()%39;
	return random + 1;
}

void nib_put_scr(int x, int y, int ch)
{
  //mvprintw(y, x, "%c", ch);
  mvwprintw(win, y, x, "%c", ch);
  wrefresh(win);
}

void nib_init(void)
{
	int startx, starty;
	int ch;

	srand(time(0));        
	p_screen = initscr();    
	start_color();           
	keypad(p_screen, TRUE);  
	nodelay(p_screen, TRUE);

	height = 40;
	width = 100;
	starty = (LINES - height) / 2;
	startx = (COLS - width) / 2;
	
	printw("<<| snakeASM |>>");
	
	refresh();
	
	win = newwin(height, width, starty, startx);
}

void clearScr()
{
	wclear(win);
	
	wborder(win, '|', '|', '-', '-', '+', '+', '+', '+'); //draw border
	
	mvwprintw(win, 0, 0, "(0, 0)");
	mvwprintw(win, 39, 91, "(40, 100)");
	
	wrefresh(win);
}

void update()
{
	refresh();
}

void nib_end(void)
{
  endwin();
  exit(0);
}
