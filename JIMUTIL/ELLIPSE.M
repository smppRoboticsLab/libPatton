%************** MATLAB "M" function (jim Patton) *************
% Plots an ellipse as a line (plot command), and returns the handle. 
% SYNTAX 	hdl=ellipse(x,y,xmag,ymag,rot,num,pltcmd);
% INPUTS:	x        x postion of center
%		y        y postion of center 
%		xmag     x axis distance from center to edge
%		ymag     x axis distance from center to edge
%		rot      Rotation counterclockwise (rads)
%		num      number of verticies (suggestion: 20)
%		pltcmd   Plotting specification. If it is a string, 
%                       then the outline is drawn based on pltcmd 
%     		         (example: 'r+' means plot red plusses)
%		         If it is a vector of 3 RGB values, then it 
%		         shades the ellipse accroding to pltcmd 
%     		         (example: [.5 .5 .5] means shade it gray)
% CALLED BY:	plt3.m (ensebl) and others
% INITIATIED:	12/18/95 jim patton from 'plt3.m'
%		5/5/98 made it flexible to draw line or shade in,
%                     making ELLIPSEP.M obsolete

% SEE:   	C:\jim\matlab\devel 
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function hdl=ellipse(x,y,xmag,ymag,rot,num,pltcmd);
%fprintf('~ellipse.m~');

%____ SETUP:_____
T = [	cos(rot) -sin(rot);	...
	sin(rot)  cos(rot)	];

% ____ GENERATE PERIMETER POINTS:_____	
%x=4; y=7; xmag=2; ymag=1; rot=20; num=20; pltcmd='r';      % for testing 
n=0;
for i=0:2*pi/num:2*pi
  n=n+1;
  xe(n)= xmag *cos(i);  ye(n)=ymag*sin(i);
end % for

% ____ ROTATE POINTS:_____
for n=1:n, 
  new=T*[xe(n);ye(n)]; xe(n)=new(1); ye(n)=new(2);  
end % for

% ____ plot:_____
if isstr(pltcmd), 
  hdl=plot(x+xe,y+ye,pltcmd);
else
  hdl=patch(x+xe,y+ye,pltcmd,'EdgeColor','none');
end

%fprintf('~END ellipse.m~');

