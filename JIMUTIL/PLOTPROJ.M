% ****************** MATLAB "M" function (jim Patton) *****************
% Create a 3d scaatter plot with linear regresion lines.
% If selected, it connects a line from each point to the z plane, & 
% draws the data points resolved to the other 2 planes (y and z).
% INPUTS:		x 	a N by 3 matrix of N triples, with :
%					x values in 1st column 
%					y values in 2nd column 
%					y values in 3rd column 
%			mrk	a marker string (example 'b+' for blue plusses)
%			vrt	set to 0 if you dont want it to connects a line
%				from each point to the z plane, 1 if you do.
% OUTPUTS:		generates a plot, and returns plot handle
% CALLS:		plot3.m, polyfit.m
% CALLED BY:		?
% INITIATIED:		12/14/95 by jim patton from fpstatic.m 
% SYNTAX:		handle=plotproj(x);
% SEE DIRECTORY:   	C:\JIM\matlab\devel
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function plt_hndl=plotproj(x,mrk,vrt);
fprintf('\n~plotproj.m MATLAB m-function (PATTON)~');

%xx=0:.51:10; xx=xx'; x=rand(20,3)+[xx xx xx]; %xlabel('x'); ylabel('y'); zlabel('z');
plt_hndl=plot3(0, 0, 0); hold on; grid on; 

%__Draw a vertical pole to xyz point from z plane, and draw marker at xyz__
for i=1:length(x(:,1)), 
  if vrt, plot3([x(i,1) x(i,1)],[x(i,2) x(i,2)],[0 x(i,3)], 'r');  end %if vrt
  hdl=plot3([x(i,1)],[ x(i,2)],[x(i,3)],mrk); 
  set(hdl,'LineWidth',2); set(hdl,'MarkerSize',5);
end; 

ax=axis;

%__resolve each xyz point to each plane, and draw marker at xyz__
for i=1:length(x(:,1)), 
  hdl=plot3([x(i,1)],ax(4),[x(i,3)],  mrk);  	set(hdl,'MarkerSize',3);
  hdl=plot3(ax(2),[ x(i,2)],[x(i,3)], mrk); 		set(hdl,'MarkerSize',3);
  hdl=plot3([x(i,1)],[x(i,2)], ax(5), mrk); 		set(hdl,'MarkerSize',3);
end;

%__ do a linear fit of the data in each plane and draw a line for this __
p = polyfit(x(:,1),x(:,2),1);
plot3(							...
  [min(x(:,1)) max(x(:,1))],				...
  [p(2)+p(1)*min(x(:,1)) p(2)+p(1)*max(x(:,1))],	...
  [ax(5) ax(5)],					...
  'b');

p = polyfit(x(:,3),x(:,2),1);
plot3(							...
  [ax(2) ax(2)],					...
  [p(2)+p(1)*min(x(:,3)) p(2)+p(1)*max(x(:,3))],	...
  [min(x(:,3)) max(x(:,3))],				...
  'b');

p = polyfit(x(:,1),x(:,3),1);
plot3(							...
  [min(x(:,1)) max(x(:,1))],				...
  [ax(4) ax(4)],					...
  [p(2)+p(1)*min(x(:,1)) p(2)+p(1)*max(x(:,1))],	...
  'b');

fprintf('~END~\n');

