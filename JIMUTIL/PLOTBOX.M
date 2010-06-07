% ***************** MATLAB "M" file  (jim Patton) ****************
% Plots a box of specified dimensions on the current plot
% SYNTAX:	f=plotbox(x,y,size,COLOR,verbose)                                                             
% INPUTS:     x         x center location
%             y         y center location 
%             size      How far in each direct. from center
%             verbose   (optional) nonzero if you want a message
% OUTPUTS:    graphics
% CALLS:      -
% VERIONS:    INITIATIED by jim patton 
%             12/12/96 (patton) to add comment header only
%             5/5/98 (patton) add comment header only 
%             7/28/99 verbose variable and COLOR arguements
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function f=plotbox(x,y,size,COLORst,verbose)

if ~exist('verbose'), verbose=1; end;
if ~exist('COLORst'),   COLORst='g'; end
if verbose, fprintf(' *** plotbox.m M-FUNCTION *** '); end

a=size/2;
xxx=[x+a,x+a,x-a,x-a,x+a];
yyy=[y+a,y-a,y-a,y+a,y+a];
plot(xxx,yyy,COLORst)

if verbose, fprintf(' *** END plotbox.m ***   '); end;

