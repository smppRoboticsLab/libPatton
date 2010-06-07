%______*** MATLAB "M" function (jim Patton) ***_______
% this converts a 2 by N matrix of states in theta (positive to right of 
% vertical) to cartesian xy coordinates, (x right from center of 
% rotation, y vertical from center of rotation).
% INPUTS:	r 		constant radius scalar
%		pSTATES		polar states
% OUTPUTS:	cSTATES 	cartesian states
%______________________________________________________
%function [x, Dx] = statep2c(r, th, Dth);

function [x, Dx] = statep2c(r, th, Dth);
disp('~statep2c.m MATLAB function~ ');

%___________________ CALCULATIONS __________________

x  = r.*sin(th);
Dx = r.*Dth.*cos(th);

disp('~END statep2c.m~ ');

