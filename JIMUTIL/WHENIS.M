% ************** MATLAB "M" function (jim Patton) *************
% Plots an ellipse, and returns the handle. 
% INPUTS:	when
% CALLED BY:	anthing
% INITIATIED:	1/22/96 jim patton from ' ellipse.m '
% SYNTAX:	hdl=ellipse(x,y,xmag,ymag,rot,num,pltstr); 
% SEE:   	C:\jim\matlab\devel 
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function str=whenis(when);
%fprintf('~whenis.m~');

str=[ int2str(when(2)) '/' int2str(when(3)) '/' int2str(when(1)) 	...
	' at ' int2str(when(4)) ':' int2str(when(5)) ':' int2str(when(6)) ];
%fprintf('%s\n',str);

%fprintf('~END whenis.m~');

