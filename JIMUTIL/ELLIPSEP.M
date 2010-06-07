% ************** MATLAB "M" function (jim Patton) *************
% Plots an ellipse as a patch (patch command), and returns the handle. 
% INPUTS:	x	x postion of center
%		y	y postion of center 
%		xmag 	x axis distance from center to edge
%		ymag 	x axis distance from center to edge
%		rot	Rotation counterclockwise (rads)
%		num	number of verticies (suggestion: 20)
%		plot string (example 'r+' menas plot red plusses)
% CALLED BY:	plt3.m (ensebl) and others
% INITIATIED:	6/12/96 jim patton from 'ellipse.m'
% SYNTAX:	hdl=ellipsep(x,y,xmag,ymag,rot,num,pltstr); 
% SEE:   	C:\jim\matlab\devel 
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function hdl=ellipsep(x,y,xmag,ymag,rot,num,pltstr);
%fprintf('~ellipsep.m~');

% ____ generate perimeter points:_____
%x=4; y=7; xmag=2; ymag=1; rot=20; num=20; pltstr='r'; 		% for testing purposes
n=0;
for i=0:2*pi/num:2*pi
  n=n+1;
  xe(n)= xmag *cos(i);  ye(n)=ymag*sin(i);
end % for

% ____ rotate points:_____
T = [	cos(rot) -sin(rot);	...
	sin(rot)  cos(rot)	];
for n=1:n, new=T*[xe(n);ye(n)];  xe(n)=new(1); ye(n)=new(2);  end % for

% ____ plot:_____
hdl=patch(x+xe,y+ye,pltstr,'EdgeColor','none');

%fprintf('~END ellipsep.m~');

