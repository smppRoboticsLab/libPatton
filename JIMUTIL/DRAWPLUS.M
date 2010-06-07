% ************** MATLAB "M" function (jim Patton) *************
% Plots an plus (cross hairs), and returns the handle. 
% INPUTS:	x	x postion of center
%		y	y postion of center 
%		xmag 	x axis distance from center to edge
%		ymag 	x axis distance from center to edge
%		rot	Rotation counterclockwise (rads)
%		plot string (example 'r+' menas plot red plusses)
% CALLED BY:	? (ensebl) and others
% INITIATIED:	6/12/96 jim patton from 'ellipse.m'
% SYNTAX:	hdl=drawplus(x,y,xmag,ymag,rot,pltstr); 
% SEE:   	C:\jim\matlab\devel 
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function hdl=drawplus(x,y,xmag,ymag,rot,pltstr);
%fprintf('~drawplus.m~');

% ____ generate perimeter points:_____
%x=4; y=7; xmag=2; ymag=1; rot=20; num=20; pltstr='r'; 		% for testing purposes
xe= [xmag -xmag 0 0 0];  ye=[0 0 0 ymag -ymag];

% ____ rotate points:_____
T = [	cos(rot) -sin(rot);	...
	sin(rot)  cos(rot)	];
for n=1:5, new=T*[xe(n);ye(n)];  xe(n)=new(1); ye(n)=new(2);  end % for

% ____ plot:_____
hdl=plot(x+xe,y+ye,pltstr);

%fprintf('~END drawplus.m~');

