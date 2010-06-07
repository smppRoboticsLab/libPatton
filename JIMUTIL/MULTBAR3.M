% ***** MATLAB M-function  ******
% A better multiple bar graph. 
% SYNTAX:   status=multbar3(y,x,colors,xnames,width,offset,wings,zero,textLocation,fsz)
% INPUTS:   y	Each row specifies a series of bar heights
%		x	(optional) x-domain (row vecctor) for the bars
%		colors 	(optional) each line is a RGB triad assoc w/ ea series
%		xnames 	(optional) each line is a name assoc w/ ea column 
%		width	(optional) width of bars
%		offset	(optional) shift this much in X for ea series bar
%		wings	(optional) wings measures (must be same dimension as y)
%		zero	(optional) zero line where bars start(default=0)
%    textLocation (optional) read the code for this
% OUTPUTS:	plot	
% CALLS:	
% CALLED BY: 	
% REVISIONS: 	initiated 9/10/97 by patton from bar.m
%		Revised to multibar2.m on 12/8/97 for x domain - patton.
%		12/15/97 patton version 3 has wings.
% NOTES:	try(default):       width=.1; space=19; offset=.2;
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function status=multbar3(y,x,colors,xnames,width,offset,wings,zero,textLocation,fsz)

%____ SETUP ____
global DEBUGIT							                                        % nonzero=debugging
if ~exist('DEBUGIT')|isempty(DEBUGIT), DEBUGIT=0; end
if DEBUGIT==1, fprintf('\n ~ MULTBAR2.M ~ '); end                   % if	% message
status=0;                                                           % start OK staus
[rows,cols]=size(y); 						                                    % size of input mtx
if ~exist('x')|isempty(x),  x=1:cols;  end;				                  % default horizonatal barcenters
if ~exist('width')|isempty(width),  
  if length(y==1);
    width=.25;
  else
    dx=mean(diff(x));
    width=dx/3/rows; 
  end
end; 			    
% default distance btwn bars
%if ~exist('offset'), offset=dx/10/rows; end; 		                  % default
if ~exist('offset')|isempty(offset), offset=width; end; 		        % default
if ~exist('wings')|isempty(wings), wings=zeros(rows,cols); end;	 		            % default
if ~exist('zero')|isempty(zero), zero=0; end; 				              % default
if ~exist('colors')|isempty(colors), 						                    % default 
  if rows==1, colors=[0 0 0]; 					                            % black
  else,      colors=(rows-1:-1:0)'*ones(1,3)/(rows-1);  	          % evenly spaced grey
  end;                                                              % END if rows...
end;                                                                % END if ~exist... 
if ~exist('textLocation')|isempty(textLocation),                    % default
  textLocation='zero';                                              % 
end; 				                                                        %
if ~exist('fsz')|isempty(fsz), fsz=7; end; 				                  % default

%____ bar plot (plot rows in reverse order for overlap!) ____
halfwidth=(offset*rows)/2;
for row=rows:-1:1;                                      % loop: each series
  for col=1:cols						% loop: each bar
    xx=[]; yy=[];						%
    barcenter=x(col)+offset*row-halfwidth-width/2;		%
    xx= width.*[-.5 -.5 .5 .5]+barcenter;			%
    yy=[zero, y(row,col), y(row,col), zero];			%
    patch(xx,yy,colors(row,:)); hold on;			% plot 1 bar series
    wwx=barcenter+[0 0 .2 -.2].*width;			%
    wwy=y(row,col)+[0 wings(row,col) wings(row,col) wings(row,col)];	%
    plot(wwx,wwy,'k');						% wings up             
    if ~strcmp(textLocation,'barInside'), % dont do if labels inside bar
      wwx=barcenter+[0 0 .2 -.2].*width;			%
      wwy=y(row,col)+[0 -wings(row,col) -wings(row,col) -wings(row,col)];	% 
      plot(wwx,wwy,'k');						% wings down
    end    
  end %for col							%
end; %for row							%

ax=axis;							%
plot([ax(1) ax(2)],[zero zero],'k');				% horiz line

%____ x axis labels ____
if exist('xnames') 
  if ~isempty(xnames)
    for col=1:cols						% loop: each bar
      if     strcmp(textLocation,'zero'), textY=zero; hAlign='right'; 
      elseif strcmp(textLocation,'bottom'), textY=ax(3); hAlign='right'; 
      elseif strcmp(textLocation,'top'), textY=ax(4); hAlign='left'; 
      elseif strcmp(textLocation,'barTop'), textY=max(y(:,col)); hAlign='left'; 
      elseif strcmp(textLocation,'barInside'), textY=max(y(:,col)); hAlign='right'; 
      end
      text(x(col),textY,		                    ...
        [' ' deblank(xnames(col,:)) ' '],			...
        'rotation',90,			                    ...
        'HorizontalAlignment',hAlign,	        ...
        'fontsize',fsz);
      set(gca,'XTickLabel','','xtick',[]);
    end %for col							%
  end
end %if exist..

ax=axis; plot([ax(1) ax(2)],[zero,zero],'k');		% horiz line

if DEBUGIT==1, fprintf('\n ~ END MULTBAR2.M ~ '); end %if	% message
return
