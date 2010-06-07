% ***** MATLAB M-function  ******
% A better multiple bar graph. 
% SYNTAX:	status=multibar(y,x, colors, xnames, width,offset)
% INPUTS:	y	Each row specifies a series of bar heights
%		x	(optional) x-domain (row vecctor) for the bars
%		colors 	(optional) each line is a RGB triad assoc w/ ea series
%		xnames 	(optional) each line is a name assoc w/ ea column 
%		width	(optional) width of bars
%		offset	(optional) shift this much in X for ea series bar
% OUTPUTS:	plot	
% CALLS:	
% CALLED BY: 	
% REVISIONS: 	initiated 9/10/97 by patton from bar.m
%		Revised to multibar2.m on 12/8/97 for x domain - patton.
% NOTES:	try(default):       width=.1; space=19; offset=.2;
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function status=multibar(y,x, colors, xnames, width,offset)

%____ SETUP ____
global DEBUGIT							% nonzero=debugging
if DEBUGIT==1, fprintf('\n ~ MULTBAR2.M ~ '); end %if	% message
status=0;							% start OK staus
[rows,cols]=size(y); 						% size of input mtx
if ~exist('x'),  x=1:cols;  end;				% default
dx=mean(diff(x));						% distance btwn bars
if ~exist('width'),  width=dx/3/rows;  end; 			% default
if ~exist('offset'), offset=dx/10/rows; end; 		% default
leftside =offset*rows/2;
if ~exist('colors'), 						% default 
  if rows==1, colors=[0 0 0]; 					% black
  else,      colors=(rows-1:-1:0)'*ones(1,3)/(rows-1);  	% evenly spaced grey
  end; %if rows...
end; %if ~exist... 

%____ bar plot ____
for row=rows:-1:1; 						% loop: each series
  for col=1:cols						% loop: each bar
    xx=[]; yy=[];						%
    xx= width.*[-.5 -.5 .5 .5]+x(col)+offset*row-leftside;	%
    yy=[0, y(row,col), y(row,col), 0 ];			%
    patch(xx,yy,colors(row,:)); hold on;			% plot 1 bar series
  end %for col							%
end; %for row							%
ax=axis;							%
plot([ax(1) ax(2)],[0 0],'k');				% horiz line

%____ x axis labels ____
if exist('xnames')
  for col=1:cols
    text(x(col),0,		...
         xnames(col,:),			...
         'rotation',90,			...
         'HorizontalAlignment','right',	...
         'fontsize',8);
  end %for col
  set(gca,'XTickLabel','');
end %if exist..

if DEBUGIT==1, fprintf('\n ~ END MULTBAR2.M ~ '); end %if	% message
return

