%************** MATLAB "M" function  *************
% make horiz bar on plot with text above
% SYNTAX:   handles=hBar(x1,x2,yPoint,S,fsz,lw)
% INPUTS:   x1      x location of bar at 1 end
%           x2      x location of other end
%           yPoint  y location of bar
%           S       text to appear
%           fsz     (optional) font size; default: fsz=12
%           lw      (optional) bar line width; default: lw=2
% OUTPUTS:  handles handles.line and handles.txt are handles to 
%                   the line and text
% REVISIONS:    8-8-01  INITIATED  (patton) 
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~~~~~~~~~~
function handles=hBar(x1,x2,yPoint,S,fsz,lw,C)

if ~exist('fsz'), fsz=12; end                             % if not passed
if ~exist('lw'),  lw=2; end                               % if not passed
if ~exist('C'),  C='b'; end                       % if not passed

handles.bar=plot([x1 x1 x2 x2], yPoint*[.98 1 1 .98]  ... % bracket-line
  ,C,'linewidth',lw);                                 %

handles.text=text((x1+x2)/2,yPoint,S,'fontsize',fsz,  ... % text
  'FontWeight','bold','HorizontalAlignment',          ... % 
  'center','VerticalAlignment','bottom','Color',C);   %
  
return
