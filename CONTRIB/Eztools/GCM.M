function menu = gcm(figure)
%GCM    Return handle of current menu.
%	MENU = GCM returns the current menu in
%	the current figure.
%
%	MENU = GCM(FIGURE) returns the current menu
%	in figure FIGURE.
%
%	The current menu for a given figure is the last
%	menu selected with the mouse.


%	Copyright (c) 1991-92 by the MathWorks, Inc.

if(nargin == 0)
	figure = get(0,'CurrentFigure');
end

menu = get( figure, 'CurrentMenu');

