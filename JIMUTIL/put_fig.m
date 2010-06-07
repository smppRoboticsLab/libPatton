% ******************* MATLAB "M" file  (jim Patton) ******************
% place a figure on the screen based on fractional dimensions of pixel space
% SYNTAX: put_fig(fignum, left, up, width, height)
%	    left    left edge of fig from left edge of screen as a 
%              fraction of screen width 
%	    up      bottom edge of fig from bottom edge of screen as a 
%             fraction of screen height 
%     width   fig width as a fraction of screen width 
%     height  fig height as a fraction of screen height
% INITIATIED: 7/2/97 INITIATED (Patton) 
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~

function put_fig(fignum, left, up, width, height)
global DEBUGIT
if DEBUGIT, fprintf(' ~~ put_fig.M ~~'); end	%

screen=get(0,'ScreenSize');			% pixel dimensions
Swd=screen(3);					% screen height
Sht=screen(4);					% screen width

figure(fignum)
set(fignum,'Position',			...	% put up fig
[left*Swd up*Sht width*Swd height*Sht]);	% [Xleft Ybottm width height]

if DEBUGIT, fprintf(' ~END put_fig~ '); end	%

