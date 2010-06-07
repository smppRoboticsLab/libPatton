%______*** MATLAB "M" function (jim Patton) ***_______
% make a picture (a string of xy points) by digitizing graphics
% on figure. Use to digitize pictures into data points.
% SYNTAX:	pict=make_pic(filename, draw) 
% 		pict=make_pic(filename)
% 		pict=make_pic
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
% CALLS : 	loadbmp.m	load bitmap image file format
% CALLED BY:	?
% INITIATIED:	5/20/96 by patton from nothing
% SEE ALSO:	show_pic.m	to display the results of this
%		bmp_show.m	to load and display a picture in the plot window 
% ~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function pic=make_pic(filename, draw);
fprintf('~ make_pic.m  funtion (patton) ~');

pic=zeros(1,3); point=0; clf; 

%____________ SETUP ___________

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
fprintf('\n Click zero');				[X0,Y0]=ginput(1); plot(X0,Y0 ,'bo');
ax=axis; 
fprintf('\n Click X (width)  positive');		[XP,Y0]=ginput(1); plot(XP,Y0 ,'b+');
ax=axis; 
fprintf('\n Click Y (length) positive');		[XO,YP]=ginput(1); plot(XO,YP ,'b+');
ax=axis; 
fprintf('\n ____CLICK 2 POINTS FOR LENGTH:'); 
fprintf('\n Click distal   joint (ZERO POINT)');   	[Xd,Yd]=ginput(1); plot(Xd,Yd ,'o');
ax=axis; 
fprintf('\n Click proximal joint (LENGTH POINT)'); 	[Xp,Yp]=ginput(1); plot(Xp,Yp ,'o');
ax=axis; 
spt=[X0,Y0;XP,Y0;XO,YP;Xd,Yd;Xp,Yp];

%____________ DATA SERIES ___________
fprintf('\n Click the right mouse button at initial point, '); 
fprintf('\n then click the left for each point to DRAW TO, '); 
fprintf('\n the right mouse for each point to MOVE TO. '); 
fprintf('\n Press B to backup to the last point. '); 
fprintf('\n When finished, press return. '); 
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
      plot(spt(:,1),spt(:,2),'o','markersize',3);		% setup points
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
plot(spt(:,1),spt(:,2),'o','markersize',3);			% plot joints 
h=plt_pict(raw,1);						% plot picture
fprintf('\n hit a key to normalize ... '); pause		% pause

%____________ NORMALIZE USING SETUP POINTS ___________
length=distance([Xd Yd],[Xp Yp]);
fprintf('\n Normalizing (length=%f)...',length); 		% message 
pic=[raw(:,1)-Xd              raw(:,2)-Yd       raw(:,3)];	% zero
pic=[pic(:,1)*(YP-Y0)/(XP-X0) pic(:,2)          pic(:,3)];	% XYdistortion corect
pic=[pic(:,1)/length          pic(:,2)/length   pic(:,3)];	 % scale to length
clf; plot(0,0,'o'); axis('equal'); hold; h=plt_pict(pic,1);	% plot
fprintf('\n hit a key to rotate... '); pause			% pause

%____________ ROTATE USING SETUP POINTS ___________
ang=atan2(Xp-Xd,Yp-Yd);
fprintf('\n Rotating angle=%fdegrees)...',ang/pi*180); 	% message 
rot=[	 cos(ang)  sin(ang); 	... 				% set rot matrix
 	-sin(ang)  cos(ang)];					% set rot matrix
pic(:,1:2)=(rot* pic(:,1:2)')';				% rotate
clf; plot([0 0],[0 1] ,'o','markersize',3); 			% plot joints
axis('equal'); hold; h=plt_pict(pic,0);			% plot pic
plot([0 0],[0 1] ,'o','markersize',3); 			% plot joints

fprintf('\n~ END make_pic.m ~\n');

