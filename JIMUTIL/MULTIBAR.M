% ***** MATLAB M function BATCH1.M ******
% a better bar graph
% SYNTAX:	status=multibar(y, width,space,offset,xnames)
% INPUTS:	y	input matrix rows to be made into bars
%		width	
%		space
%		offset
%		xnames 
% OUTPUTS:	plot
% CALLS:	
% CALLED BY: 	
% REVISIONS: 	initiated 9/10/97 by patton from bar.m
%
% NOTES:	try(default):       width=.1; space=19; offset=.2;
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function status=multibar(y,width,space,offset,xnames,colors)
fprintf('\n ~ MULTIBAR.M ~ ');  				% message

%____ SETUP ____
global DEBUGIT							% nonzero=debugging
status=0;							% start OK staus
%clg; 
[rows,cols]=size(y); 
if ~exist('width'),  width=1;  end;
if ~exist('space'),  space=19;  end;
if ~exist('offset'), offset=.2; end;
if ~exist('colors'), 
  colors=(rows-1:-1:0)'*ones(1,3)/(rows-1);  		% evenly spaced grey
end;

%____ bar plot ____
for row=rows:-1:1; 
  xx=[0];
  for col=1:cols
    xx= space*col+offset*row+width./[-.5 -.5 .5 .5];
    yy=[0, y(row,col), y(row,col), 0 ];
    patch(xx,yy,colors(row,:)); hold on;
  end %for col
end; %for row
%set(gca,'XTickLabels',[]);

return

%____ x axis labels ____
if exist('xnames')
  for col=1:cols
    text(space*col+offset*rows/2,0,		...
         xnames(col,:),			...
         'rotation',90,			...
         'HorizontalAlignment','right',	...
         'fontsize',8);
  end %for col
end %if exist..


fprintf(' ~ MULTIBAR.M ~ \n');  				% message 
