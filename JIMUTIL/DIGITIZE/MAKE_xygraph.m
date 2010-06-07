%______*** MATLAB "M" function (jim Patton) ***_______
% digitize an xy plot from a bitmap, making a string of xy points 
% SYNTAX:	pic=make_xygraph(filename, draw) 
% DIRECTIONS: 
%	Click the right mouse button at initial point,
%	then click the left for each point to DRAW TO,
%	the right mouse for each point to MOVE TO.
% 	Press B to backup to the last point.
%	When finished, press return 
% INPUTS:	filename 	input bmp file. Must NOT have extention .bmp 
%		draw		text string: ='y' if draw lines you make as you 
%				go (default), ='n' if no draw 
% OUTPUTS: 	pic		3 BY n matrix, each row is a data point,
%				and colums are x, y and drawto:
%				drawto=1 for drawing, 2 for no drawing
%              raw		raw (pixel space points)
% CALLS : 	loadbmp.m	load bitmap image file format
% CALLED BY:	?
% INITIATIED:	5/20/96 by patton from nothing
% SEE ALSO:	show_pic.m	to display the results of this
%		bmp_show.m	to load and display a picture in the plot window 
% ~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function [pic,raw]=make_xygraph(filename, draw);

%____________ SETUP ___________
prog_name='make_xygraph';
fprintf('\n~ %s ~ ', prog_name);                     		% message
pic=zeros(1,3); point=0; clf; 

%____________ LOAD .bmp FILE ? ___________
if(nargin>0)
  fprintf(' loading %s.bmp, Wait...',filename); pause(.01); 
  [BMP,map]=loadbmp(filename); colormap(map); BMP=flipud(BMP);
  clf; plot(0,0); hold; image(BMP); axis('equal'); ax=axis; 
  if(nargin==1), draw='y'; end %if
elseif(nargin==0)
  plotbox(0,.5,1); hold; ax=axis; draw='y';
else
  error('input must have 0, 1 or 2 elements. <aborting> ')	
end; %if

%____________ SETUP POINTS FOR GUAGING DISTANCES & NORMALIZING ___________
fprintf('\n ____CLICK 3 POINTS FOR A RIGHT ANGLE SQUARE (FOR SCALING):'); 
fprintf('\n Click a lower left corner');          
[LL(1),LL(2)]=ginput(1); plot(LL(1),LL(2),'bo');
fprintf('\n')
LLa(1)=input(' Enter X value for lower left: ');
LLa(2)=input(' Enter Y value for lower left: ');

fprintf('\n Click a lower right corner');          
[LR(1),LR(2)]=ginput(1); plot(LR(1),LR(2),'bo');
fprintf('\n')
LRa(1)=input(' Enter X value for lower right: ');
LRa(2)=input(' Eenter Y value for lower right: ');

fprintf('\n Click a upper left corner');          
[UL(1),UL(2)]=ginput(1); plot(UL(1),UL(2),'bo');
fprintf('\n')
ULa(1)=input(' Enter X value for upper left: ');
ULa(2)=input(' Enter Y value for upper left: ');

ax=axis; 

%____________ DATA SERIES ___________ 
fprintf('\n ============================================== '); 
fprintf('\n Click the right mouse button at initial point, '); 
fprintf('\n then click the left for each point to DRAW TO, '); 
fprintf('\n the right mouse for each point to MOVE TO. '); 
fprintf('\n Press B to backup to the last point. '); 
fprintf('\n When finished, press return. \n\n'); 
X=0; Y=0; button=0;
while(1)
  point=point+1;
  [X,Y,button]=ginput(1); newdat=[X,Y,button];		% new point or kystrk
  if point==1, newdat=[X,Y,2]; end; %if			% 1st point is MOVETO
  if isempty(button) | button==13,				% return key: end pic
    fprintf('\n End.'); break;				% break
  elseif newdat(1,3)==66|newdat(1,3)==98  			% B pressed: back 1 pt
    fprintf('\nGo back, redraw. Wait...'); pause(.01);	% message
    point=point-2; raw(point+1,:)=[];				% reset to last point
    if draw=='y' & (nargin>0),				% redraw:
      clf; plot(0,0); hold; image(BMP); axis('equal');	% image
      plot([LR(1) LL(1) UL(1)],[LR(2) LL(2) UL(2)],'g', ... %
         'markersize',3);		% setup points
      h=plt_pict(raw,1,'y',2);				% picture 
      ax=axis; 
    end %if
  elseif button==1 | button==3				% mouse button pressed
    if button==1,		fprintf('\n DRAW'); 		% message		
    else, 			fprintf('\n MOVE'); 		% message 
    end %if
    fprintf('TO point#%d:  %f %f %d',point,X,Y,button); 	% message 
    raw(point,:)=newdat;  pic=raw;
    if draw=='y',						% plot new?
      if newdat(1,3)==1,
        plot([raw(point-1,1) raw(point,1)],		...	%
             [raw(point-1,2) raw(point,2)],'g','linewidth',2);%
      else 							%
        plot(raw(point,1), raw(point,2),'bo','markersize',3);%
      end %if newdat						%
      ax=axis; 						%
    end %if
  else 
    fprintf('\n invalid. try again.'); point=point-1;	%
  end %if button...
end %while(1)

%____________ FINAL PRESENTATION ___________
clf; plot(0,0); hold; image(BMP); axis('equal');		% image
plot([LR(1) LL(1) UL(1)],[LR(2) LL(2) UL(2)],'g', ... 	%
         'markersize',3);		                   	% setup points
h=plt_pict(raw,1);						% plot picture
plot(raw(:,1),raw(:,2),'o','markersize',3)
fprintf('\n hit a key to scale ... '); pause;               % message; pause

%____________ RESCALE USING SETUP POINTS ___________
fprintf('\n Scaling %d values...',length(raw(1,:))); 	% message 
pic=[LLa(1)+(raw(:,1)-LL(1)).*(LRa(1)-LLa(1))/(LR(1)-LL(1)) ... % scale-interp x
     LLa(2)+(raw(:,2)-LL(2)).*(ULa(2)-LLa(2))/(UL(2)-LL(2)) ... % scale-interp y
      raw(:,3)];	                                 	% zero
h=plt_pict(pic,1);						% plot picture
plot(pic(:,1), pic(:,2),'o','markersize',3)

fprintf('\n~ END make_pic.m ~\n');
return



%JUNK:

%____________ ROTATE USING SETUP POINTS ___________
ang=atan2(Xp-Xd,Yp-Yd);
fprintf('\n Rotating angle=%fdegrees)...',ang/pi*180); 	% message 
rot=[	 cos(ang)  sin(ang); 	... 				% set rot matrix
 	-sin(ang)  cos(ang)];					% set rot matrix
pic(:,1:2)=(rot* pic(:,1:2)')';				% rotate
hold; h=plt_pict(pic,0);			% plot pic
plot([0 0],[0 1] ,'o','markersize',3); 			% plot joints


