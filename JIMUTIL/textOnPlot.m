% ************** MATLAB "M" function  *************
% text on a plot according to fractions of plot window.
% SYNTAX:	      h=textOnPlot(S,X,Y)
% INPUTS:	      S       string of text or matrix of text
%               X,Y     normalized coords on plot  (0 to 1)
% OUTPUTS:      h       handle
% REVISONS:      
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function h=textOnPlot(S,X,Y) 

ax=axis;
xr=ax(2)-ax(1);
yr=ax(4)-ax(3);

x=X*xr+ax(1);
y=Y*yr+ax(3);

h=text(x,y,S);

return;

